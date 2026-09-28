-- Brick & Decor PWA v0.14 - generic document E-sign migration
-- Run once AFTER 01 backend foundation and 03 v0.12 backend hotfix.
-- Adds secure cross-device E-sign for Letter of Appointment, VO and Handover documents.

begin;

create extension if not exists pgcrypto with schema extensions;

create table if not exists public.document_esign_requests (
  id uuid primary key default gen_random_uuid(),
  company_id uuid not null references public.companies(id),
  local_case_no text not null,
  document_type text not null check (document_type in ('LOA','VO','HANDOVER','OTHER')),
  document_no text not null,
  snapshot jsonb not null default '{}'::jsonb,
  status text not null default 'PENDING' check (status in ('PENDING','SIGNED','REVOKED','EXPIRED')),
  token_hash text not null unique,
  expires_at timestamptz not null,
  staff_signed_by uuid references public.profiles(id),
  staff_signer_name text,
  staff_signature_data text,
  staff_signed_at timestamptz,
  signed_by text,
  signature_data text,
  signed_at timestamptz,
  user_agent text,
  created_by uuid not null references public.profiles(id),
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

create index if not exists document_esign_requests_company_idx on public.document_esign_requests(company_id);
create index if not exists document_esign_requests_doc_idx on public.document_esign_requests(document_type, document_no);
create index if not exists document_esign_requests_status_idx on public.document_esign_requests(status, expires_at);

alter table public.document_esign_requests enable row level security;
grant select, insert, update on public.document_esign_requests to authenticated;

-- Staff can only see document-signing records for companies they can access.
drop policy if exists document_esign_staff_access on public.document_esign_requests;
create policy document_esign_staff_access
on public.document_esign_requests
for select to authenticated
using (private.has_company_access(company_id));

-- Direct browser writes remain blocked. Creation/signing is through the RPCs below.

create or replace function public.create_document_esign_request(
  p_company_id uuid,
  p_local_case_no text,
  p_document_type text,
  p_document_no text,
  p_document_snapshot jsonb,
  p_staff_signer_name text,
  p_staff_signature_data text,
  p_expires_days integer default 14
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_token text;
  v_hash text;
  v_row public.document_esign_requests%rowtype;
  v_type text := upper(trim(coalesce(p_document_type,'')));
begin
  if v_uid is null then raise exception 'Authentication required'; end if;
  if not exists(select 1 from public.profiles where id=v_uid and active=true) then
    raise exception 'Active staff profile required';
  end if;
  if not private.has_company_access(p_company_id) then raise exception 'No access to selected company'; end if;
  if nullif(trim(coalesce(p_local_case_no,'')),'') is null then raise exception 'Case reference is required'; end if;
  if v_type not in ('LOA','VO','HANDOVER','OTHER') then raise exception 'Unsupported document type'; end if;
  if nullif(trim(coalesce(p_document_no,'')),'') is null then raise exception 'Document number is required'; end if;
  if nullif(trim(coalesce(p_staff_signer_name,'')),'') is null or nullif(trim(coalesce(p_staff_signature_data,'')),'') is null then
    raise exception 'Staff signature is required before sending';
  end if;

  update public.document_esign_requests
     set status='REVOKED', updated_at=now()
   where company_id=p_company_id
     and local_case_no=p_local_case_no
     and document_type=v_type
     and document_no=p_document_no
     and status='PENDING';

  v_token := encode(extensions.gen_random_bytes(32),'hex');
  v_hash := encode(extensions.digest(v_token,'sha256'),'hex');

  insert into public.document_esign_requests(
    company_id,local_case_no,document_type,document_no,snapshot,status,token_hash,
    expires_at,staff_signed_by,staff_signer_name,staff_signature_data,staff_signed_at,
    created_by
  ) values (
    p_company_id,trim(p_local_case_no),v_type,trim(p_document_no),coalesce(p_document_snapshot,'{}'::jsonb),
    'PENDING',v_hash,now()+make_interval(days=>greatest(1,least(coalesce(p_expires_days,14),60))),
    v_uid,trim(p_staff_signer_name),p_staff_signature_data,now(),v_uid
  ) returning * into v_row;

  return jsonb_build_object(
    'id',v_row.id,'token',v_token,'status',v_row.status,'document_type',v_row.document_type,
    'document_no',v_row.document_no,'expires_at',v_row.expires_at
  );
end;
$$;

create or replace function public.get_document_esign_request(p_token text)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_hash text := encode(extensions.digest(coalesce(p_token,''),'sha256'),'hex');
  v_row public.document_esign_requests%rowtype;
begin
  select * into v_row from public.document_esign_requests where token_hash=v_hash limit 1;
  if v_row.id is null then return jsonb_build_object('ok',false,'status','NOT_FOUND'); end if;

  if v_row.status='PENDING' and v_row.expires_at < now() then
    update public.document_esign_requests set status='EXPIRED',updated_at=now() where id=v_row.id returning * into v_row;
  end if;

  return jsonb_build_object(
    'ok',true,
    'id',v_row.id,
    'status',v_row.status,
    'document_type',v_row.document_type,
    'document_no',v_row.document_no,
    'snapshot',v_row.snapshot,
    'expires_at',v_row.expires_at,
    'staff_signer_name',v_row.staff_signer_name,
    'staff_signed_at',v_row.staff_signed_at,
    'signed_by',v_row.signed_by,
    'signed_at',v_row.signed_at
  );
end;
$$;

create or replace function public.submit_document_esign(
  p_token text,
  p_signed_by text,
  p_signature_data text,
  p_user_agent text default null
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_hash text := encode(extensions.digest(coalesce(p_token,''),'sha256'),'hex');
  v_row public.document_esign_requests%rowtype;
begin
  select * into v_row from public.document_esign_requests where token_hash=v_hash for update;
  if v_row.id is null then raise exception 'Signing link not found'; end if;
  if v_row.status<>'PENDING' then raise exception 'Signing link is no longer pending'; end if;
  if v_row.expires_at < now() then
    update public.document_esign_requests set status='EXPIRED',updated_at=now() where id=v_row.id;
    raise exception 'Signing link has expired';
  end if;
  if nullif(trim(coalesce(p_signed_by,'')),'') is null then raise exception 'Signer name is required'; end if;
  if nullif(trim(coalesce(p_signature_data,'')),'') is null then raise exception 'Signature is required'; end if;

  update public.document_esign_requests
     set status='SIGNED',signed_by=trim(p_signed_by),signature_data=p_signature_data,
         signed_at=now(),user_agent=left(coalesce(p_user_agent,''),1000),updated_at=now()
   where id=v_row.id
   returning * into v_row;

  return jsonb_build_object('ok',true,'id',v_row.id,'status',v_row.status,'signed_by',v_row.signed_by,'signed_at',v_row.signed_at,'document_type',v_row.document_type,'document_no',v_row.document_no);
end;
$$;

create or replace function public.list_my_document_esign_requests()
returns table(
  id uuid,
  document_type text,
  document_no text,
  local_case_no text,
  status text,
  expires_at timestamptz,
  signed_by text,
  signed_at timestamptz,
  created_at timestamptz
)
language sql
security definer
set search_path = ''
as $$
  select d.id,d.document_type,d.document_no,d.local_case_no,d.status,d.expires_at,d.signed_by,d.signed_at,d.created_at
  from public.document_esign_requests d
  where auth.uid() is not null
    and exists(select 1 from public.profiles p where p.id=auth.uid() and p.active=true)
    and private.has_company_access(d.company_id)
  order by d.created_at desc;
$$;

revoke all on function public.create_document_esign_request(uuid,text,text,text,jsonb,text,text,integer) from public;
revoke all on function public.get_document_esign_request(text) from public;
revoke all on function public.submit_document_esign(text,text,text,text) from public;
revoke all on function public.list_my_document_esign_requests() from public;

grant execute on function public.create_document_esign_request(uuid,text,text,text,jsonb,text,text,integer) to authenticated;
grant execute on function public.get_document_esign_request(text) to anon, authenticated;
grant execute on function public.submit_document_esign(text,text,text,text) to anon, authenticated;
grant execute on function public.list_my_document_esign_requests() to authenticated;

commit;

-- Verification
select routine_name
from information_schema.routines
where routine_schema='public'
  and routine_name in (
    'create_document_esign_request',
    'get_document_esign_request',
    'submit_document_esign',
    'list_my_document_esign_requests'
  )
order by routine_name;
