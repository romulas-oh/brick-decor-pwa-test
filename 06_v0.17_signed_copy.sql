-- Brick & Decor PWA v0.17 — signed-copy retrieval for authorised staff
-- Run once AFTER the existing v0.11 foundation and SQL 05.
-- Read-only RPCs: no workflow/status data is changed.

begin;

create or replace function public.get_my_esign_request_v17(p_request_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_row public.esign_requests%rowtype;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select * into v_row from public.esign_requests where id=p_request_id;
  if not found then return jsonb_build_object('ok',false,'status','NOT_FOUND'); end if;
  if not private.can_access_case(v_row.case_id) then raise exception 'Not allowed for this case'; end if;

  return jsonb_build_object(
    'ok',true,
    'id',v_row.id,
    'status',case when v_row.status='PENDING' and v_row.expires_at<now() then 'EXPIRED' else v_row.status end,
    'expires_at',v_row.expires_at,
    'snapshot',v_row.public_snapshot,
    'signed_at',v_row.signed_at,
    'signed_by',v_row.signed_by,
    'signature_data',v_row.signature_data,
    'signature_sha256',v_row.signature_sha256,
    'created_at',v_row.created_at
  );
end;
$$;

create or replace function public.get_my_document_esign_request_v17(p_request_id uuid)
returns jsonb
language plpgsql
stable
security definer
set search_path = ''
as $$
declare
  v_row public.document_esign_requests%rowtype;
begin
  if auth.uid() is null then raise exception 'Authentication required'; end if;
  select * into v_row from public.document_esign_requests where id=p_request_id;
  if not found then return jsonb_build_object('ok',false,'status','NOT_FOUND'); end if;
  if not private.has_company_access(v_row.company_id) then raise exception 'No access to selected company'; end if;

  return jsonb_build_object(
    'ok',true,
    'id',v_row.id,
    'status',case when v_row.status='PENDING' and v_row.expires_at<now() then 'EXPIRED' else v_row.status end,
    'document_type',v_row.document_type,
    'document_no',v_row.document_no,
    'snapshot',v_row.snapshot,
    'expires_at',v_row.expires_at,
    'staff_signer_name',v_row.staff_signer_name,
    'staff_signature_data',v_row.staff_signature_data,
    'staff_signed_at',v_row.staff_signed_at,
    'signed_by',v_row.signed_by,
    'signature_data',v_row.signature_data,
    'signed_at',v_row.signed_at,
    'created_at',v_row.created_at
  );
end;
$$;

revoke all on function public.get_my_esign_request_v17(uuid) from public, anon;
revoke all on function public.get_my_document_esign_request_v17(uuid) from public, anon;
grant execute on function public.get_my_esign_request_v17(uuid) to authenticated;
grant execute on function public.get_my_document_esign_request_v17(uuid) to authenticated;

commit;
notify pgrst, 'reload schema';

select routine_name
from information_schema.routines
where routine_schema='public'
  and routine_name in ('get_my_esign_request_v17','get_my_document_esign_request_v17')
order by routine_name;
