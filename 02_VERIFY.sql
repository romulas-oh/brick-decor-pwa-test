-- Brick & Decor PWA v0.11 — quick backend verification
select 'companies' as check_name, count(*)::text as result from public.companies
union all
select 'workflow_settings', count(*)::text from public.workflow_settings
union all
select 'profiles', count(*)::text from public.profiles
union all
select 'esign_requests', count(*)::text from public.esign_requests;

select id, legacy_code, name, uen, bank_details, paynow_uen, payment_details_verified
from public.companies
order by legacy_code;

select routine_name
from information_schema.routines
where routine_schema='public'
  and routine_name in ('bootstrap_first_superadmin','create_esign_request','get_esign_request','submit_esign','list_my_esign_requests')
order by routine_name;
