-- Brick & Decor PWA v0.12 backend migration
-- Run once in Supabase SQL Editor after the v0.11 foundation.
-- Purpose:
-- 1) Fix E-sign quotation sync without weakening RLS.
-- 2) Prepare multi-ID assignments + configurable commission defaults.
-- 3) Prepare flexible customer invoice amounts.
-- 4) Prepare supplier invoice Work Section allocation.

begin;

-- -----------------------------------------------------------------------------
-- A. MULTI-ID + COMMISSION SETTINGS
-- -----------------------------------------------------------------------------
alter table public.profiles
  add column if not exists commission_default_pct numeric(6,2) not null default 40;

alter table public.case_assignments
  add column if not exists is_primary boolean not null default false,
  add column if not exists commission_base_pct numeric(6,2),
  add column if not exists assigned_by uuid references public.profiles(id),
  add column if not exists updated_at timestamptz not null default now();

alter table public.commissions
  add column if not exists profit_basis numeric(14,2) not null default 0,
  add column if not exists default_percentage numeric(6,2),
  add column if not exists approved_percentage numeric(6,2),
  add column if not exists amount_overridden boolean not null default false,
  add column if not exists updated_at timestamptz not null default now();

-- Existing normal IDs default to 40% unless Superadmin later changes the staff master.
update public.profiles
set commission_default_pct = 40
where commission_default_pct is null;

-- -----------------------------------------------------------------------------
-- B. FLEXIBLE CUSTOMER INVOICE AMOUNTS
-- -----------------------------------------------------------------------------
alter table public.customer_invoices
  add column if not exists schedule_pct numeric(6,2),
  add column if not exists custom_amount boolean not null default false;

-- -----------------------------------------------------------------------------
-- C. SUPPLIER INVOICE WORK-SECTION ALLOCATION
-- -----------------------------------------------------------------------------
alter table public.supplier_invoices
  add column if not exists work_sections text[] not null default '{}'::text[],
  add column if not exists allocation_mode text not null default 'EVEN_BY_WORK_SECTION',
  add column if not exists special_split boolean not null default false;

create table if not exists public.supplier_invoice_work_sections (
  id uuid primary key default gen_random_uuid(),
  supplier_invoice_id uuid not null references public.supplier_invoices(id) on delete cascade,
  work_section text not null,
  allocation_pct numeric(7,4) not null default 0,
  allocated_amount numeric(14,2) not null default 0,
  created_at timestamptz not null default now(),
  unique(supplier_invoice_id, work_section)
);

alter table public.supplier_invoice_work_sections enable row level security;
grant select,insert,update,delete on public.supplier_invoice_work_sections to authenticated;

drop policy if exists supplier_invoice_work_sections_access on public.supplier_invoice_work_sections;
create policy supplier_invoice_work_sections_access
on public.supplier_invoice_work_sections
for all to authenticated
using (
  exists(
    select 1
    from public.supplier_invoices si
    where si.id = supplier_invoice_id
      and private.can_access_case(si.case_id)
  )
)
with check (
  exists(
    select 1
    from public.supplier_invoices si
    where si.id = supplier_invoice_id
      and private.can_access_case(si.case_id)
  )
);

-- -----------------------------------------------------------------------------
-- D. SECURE QUOTATION SYNC RPC FOR E-SIGN
-- -----------------------------------------------------------------------------
-- v0.11 synced local demo data to clients/cases/quotations directly through
-- PostgREST. That can be correctly blocked by case RLS. This SECURITY DEFINER
-- function performs the same sync server-side, but checks the authenticated
-- staff user and company/case access before changing anything.

create or replace function public.sync_local_quotation_for_esign(
  p_case_no text,
  p_company_id uuid,
  p_client_name text,
  p_client_nric_uen text default null,
  p_client_phone text default null,
  p_client_email text default null,
  p_project_name text default null,
  p_site_address text default null,
  p_postal_code text default null,
  p_property_type text default null,
  p_lead_source text default null,
  p_estimated_budget numeric default 0,
  p_case_status text default 'Quotation Sent',
  p_quotation_no text default null,
  p_revision_no integer default 1,
  p_revision_label text default 'Rev 01',
  p_template_name text default null,
  p_subtotal numeric default 0,
  p_discount_amount numeric default 0,
  p_gst_rate numeric default 0,
  p_gst_amount numeric default 0,
  p_total numeric default 0,
  p_revision_snapshot jsonb default '{}'::jsonb,
  p_sent_at timestamptz default now(),
  p_items jsonb default '[]'::jsonb
)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_uid uuid := auth.uid();
  v_case_id uuid;
  v_client_id uuid;
  v_quote_id uuid;
  v_revision_id uuid;
  v_existing_revision_status text;
  v_item jsonb;
  v_line integer := 0;
begin
  if v_uid is null then
    raise exception 'Authentication required';
  end if;

  if not exists(
    select 1 from public.profiles
    where id = v_uid and active = true
  ) then
    raise exception 'Active staff profile required';
  end if;

  if p_company_id is null or not private.has_company_access(p_company_id) then
    raise exception 'No access to selected company';
  end if;

  if nullif(trim(coalesce(p_case_no,'')),'') is null then
    raise exception 'Case number is required';
  end if;
  if nullif(trim(coalesce(p_quotation_no,'')),'') is null then
    raise exception 'Quotation number is required';
  end if;
  if nullif(trim(coalesce(p_client_name,'')),'') is null then
    raise exception 'Client name is required';
  end if;

  select c.id, c.client_id
    into v_case_id, v_client_id
  from public.cases c
  where c.case_no = p_case_no
  limit 1;

  if v_case_id is not null then
    if not private.can_access_case(v_case_id) then
      raise exception 'No access to existing case';
    end if;

    update public.clients
       set name = trim(p_client_name),
           nric_uen = nullif(trim(coalesce(p_client_nric_uen,'')),''),
           phone = nullif(trim(coalesce(p_client_phone,'')),''),
           email = nullif(trim(coalesce(p_client_email,'')),''),
           updated_at = now()
     where id = v_client_id;

    update public.cases
       set company_id = p_company_id,
           project_name = coalesce(nullif(trim(coalesce(p_project_name,'')),''),'Renovation Project'),
           site_address = coalesce(nullif(trim(coalesce(p_site_address,'')),''),'Project Site'),
           postal_code = nullif(trim(coalesce(p_postal_code,'')),''),
           property_type = nullif(trim(coalesce(p_property_type,'')),''),
           lead_source = nullif(trim(coalesce(p_lead_source,'')),''),
           estimated_budget = coalesce(p_estimated_budget,0),
           status = coalesce(nullif(trim(coalesce(p_case_status,'')),''),status),
           updated_at = now()
     where id = v_case_id;
  else
    if not (private.is_superadmin() or private.has_permission('Create Case')) then
      raise exception 'Create Case permission required';
    end if;

    insert into public.clients(name,nric_uen,phone,email,created_by)
    values(
      trim(p_client_name),
      nullif(trim(coalesce(p_client_nric_uen,'')),''),
      nullif(trim(coalesce(p_client_phone,'')),''),
      nullif(trim(coalesce(p_client_email,'')),''),
      v_uid
    )
    returning id into v_client_id;

    insert into public.cases(
      case_no,company_id,client_id,project_name,site_address,postal_code,
      property_type,lead_source,estimated_budget,status,created_by
    )
    values(
      p_case_no,p_company_id,v_client_id,
      coalesce(nullif(trim(coalesce(p_project_name,'')),''),'Renovation Project'),
      coalesce(nullif(trim(coalesce(p_site_address,'')),''),'Project Site'),
      nullif(trim(coalesce(p_postal_code,'')),''),
      nullif(trim(coalesce(p_property_type,'')),''),
      nullif(trim(coalesce(p_lead_source,'')),''),
      coalesce(p_estimated_budget,0),
      coalesce(nullif(trim(coalesce(p_case_status,'')),''),'Quotation Sent'),
      v_uid
    )
    returning id into v_case_id;
  end if;

  select q.id into v_quote_id
  from public.quotations q
  where q.quotation_no = p_quotation_no
  limit 1;

  if v_quote_id is null then
    insert into public.quotations(
      quotation_no,case_id,company_id,status,current_revision_no,created_by
    )
    values(
      p_quotation_no,v_case_id,p_company_id,'Sent',greatest(coalesce(p_revision_no,1),1),v_uid
    )
    returning id into v_quote_id;
  else
    if not private.can_access_quotation(v_quote_id) then
      raise exception 'No access to existing quotation';
    end if;
    update public.quotations
       set case_id=v_case_id,
           company_id=p_company_id,
           status=case when status='Accepted' then status else 'Sent' end,
           current_revision_no=greatest(current_revision_no,coalesce(p_revision_no,1)),
           updated_at=now()
     where id=v_quote_id;
  end if;

  select r.id, r.status
    into v_revision_id, v_existing_revision_status
  from public.quotation_revisions r
  where r.quotation_id=v_quote_id
    and r.revision_no=greatest(coalesce(p_revision_no,1),1)
  limit 1;

  if v_revision_id is null then
    insert into public.quotation_revisions(
      quotation_id,revision_no,revision_label,template_name,status,
      subtotal,discount_amount,gst_rate,gst_amount,total,snapshot,
      sent_at,sent_by,created_by
    )
    values(
      v_quote_id,greatest(coalesce(p_revision_no,1),1),
      coalesce(nullif(trim(coalesce(p_revision_label,'')),''),'Rev 01'),
      p_template_name,'Sent',coalesce(p_subtotal,0),coalesce(p_discount_amount,0),
      coalesce(p_gst_rate,0),coalesce(p_gst_amount,0),coalesce(p_total,0),
      coalesce(p_revision_snapshot,'{}'::jsonb),coalesce(p_sent_at,now()),v_uid,v_uid
    )
    returning id into v_revision_id;
  elsif v_existing_revision_status <> 'Accepted' then
    update public.quotation_revisions
       set revision_label=coalesce(nullif(trim(coalesce(p_revision_label,'')),''),revision_label),
           template_name=p_template_name,
           status='Sent',
           subtotal=coalesce(p_subtotal,0),
           discount_amount=coalesce(p_discount_amount,0),
           gst_rate=coalesce(p_gst_rate,0),
           gst_amount=coalesce(p_gst_amount,0),
           total=coalesce(p_total,0),
           snapshot=coalesce(p_revision_snapshot,'{}'::jsonb),
           sent_at=coalesce(p_sent_at,now()),
           sent_by=v_uid
     where id=v_revision_id;

    delete from public.quotation_items where revision_id=v_revision_id;
  end if;

  if coalesce(v_existing_revision_status,'') <> 'Accepted' then
    for v_item in
      select value from jsonb_array_elements(coalesce(p_items,'[]'::jsonb))
    loop
      v_line := v_line + 1;
      insert into public.quotation_items(
        revision_id,line_no,area_location,work_section,item_name,description,
        internal_category,qty,unit,estimated_cost,charge_amount,pricing_type,internal_remark
      )
      values(
        v_revision_id,v_line,
        nullif(trim(coalesce(v_item->>'area_location','')),''),
        nullif(trim(coalesce(v_item->>'work_section','')),''),
        coalesce(nullif(trim(coalesce(v_item->>'item_name','')),''),'Item '||v_line),
        nullif(trim(coalesce(v_item->>'description','')),''),
        nullif(trim(coalesce(v_item->>'internal_category','')),''),
        coalesce((v_item->>'qty')::numeric,0),
        nullif(trim(coalesce(v_item->>'unit','')),''),
        coalesce((v_item->>'estimated_cost')::numeric,0),
        coalesce((v_item->>'charge_amount')::numeric,0),
        coalesce(nullif(trim(coalesce(v_item->>'pricing_type','')),''),'Amount'),
        nullif(trim(coalesce(v_item->>'internal_remark','')),'')
      );
    end loop;
  end if;

  insert into public.activity_logs(case_id,user_id,actor_name,action,detail,metadata)
  values(
    v_case_id,v_uid,
    (select name from public.profiles where id=v_uid),
    'Quotation synced for E-sign',
    p_quotation_no||' • '||coalesce(p_revision_label,'Rev 01'),
    jsonb_build_object('quotation_id',v_quote_id,'revision_id',v_revision_id)
  );

  return jsonb_build_object(
    'ok',true,
    'case_id',v_case_id,
    'client_id',v_client_id,
    'quotation_id',v_quote_id,
    'revision_id',v_revision_id,
    'revision_label',coalesce(p_revision_label,'Rev 01')
  );
end;
$$;

revoke all on function public.sync_local_quotation_for_esign(
  text,uuid,text,text,text,text,text,text,text,text,text,numeric,text,text,integer,text,text,numeric,numeric,numeric,numeric,numeric,jsonb,timestamptz,jsonb
) from public;
grant execute on function public.sync_local_quotation_for_esign(
  text,uuid,text,text,text,text,text,text,text,text,text,numeric,text,text,integer,text,text,numeric,numeric,numeric,numeric,numeric,jsonb,timestamptz,jsonb
) to authenticated;

commit;

-- Quick verification
select routine_name
from information_schema.routines
where routine_schema='public'
  and routine_name in ('sync_local_quotation_for_esign','create_esign_request','submit_esign')
order by routine_name;
