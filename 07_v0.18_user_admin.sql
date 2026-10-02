-- Brick & Decor PWA v0.18 — Superadmin User Administration Foundation
-- Run ONCE in Supabase SQL Editor after the existing backend migrations.
-- This migration does NOT create Auth users itself. Auth creation/deletion is handled
-- securely by the user-admin Edge Function using the Supabase service-role key.

begin;

alter table public.profiles
  add column if not exists commission_default_pct numeric(6,2) not null default 40;

create table if not exists public.user_admin_audit (
  id bigint generated always as identity primary key,
  actor_user_id uuid,
  actor_email text,
  target_user_id uuid,
  target_email text,
  action text not null,
  detail jsonb not null default '{}'::jsonb,
  created_at timestamptz not null default now()
);

alter table public.user_admin_audit enable row level security;
revoke all on public.user_admin_audit from anon;
grant select on public.user_admin_audit to authenticated;

drop policy if exists user_admin_audit_superadmin_select on public.user_admin_audit;
create policy user_admin_audit_superadmin_select
on public.user_admin_audit
for select to authenticated
using (private.is_superadmin());

-- Service-role-only helper used before a permanent Auth user deletion.
-- It dynamically counts PUBLIC foreign-key references to profiles(id), excluding
-- user_company_access because those access rows are intentionally removable.
create or replace function public.user_admin_profile_reference_summary(p_user_id uuid)
returns jsonb
language plpgsql
security definer
set search_path = ''
as $$
declare
  r record;
  v_count bigint;
  v_total bigint := 0;
  v_details jsonb := '[]'::jsonb;
begin
  if p_user_id is null then
    return jsonb_build_object('total',0,'references','[]'::jsonb);
  end if;

  for r in
    select
      n.nspname as schema_name,
      c.relname as table_name,
      a.attname as column_name
    from pg_catalog.pg_constraint con
    join pg_catalog.pg_class c on c.oid = con.conrelid
    join pg_catalog.pg_namespace n on n.oid = c.relnamespace
    join pg_catalog.pg_class rc on rc.oid = con.confrelid
    join pg_catalog.pg_namespace rn on rn.oid = rc.relnamespace
    join pg_catalog.pg_attribute a
      on a.attrelid = con.conrelid
     and a.attnum = con.conkey[1]
    where con.contype = 'f'
      and rn.nspname = 'public'
      and rc.relname = 'profiles'
      and n.nspname = 'public'
      and array_length(con.conkey,1) = 1
      and c.relname not in ('user_company_access','user_admin_audit')
    order by c.relname, a.attname
  loop
    execute format(
      'select count(*) from %I.%I where %I = $1',
      r.schema_name, r.table_name, r.column_name
    ) into v_count using p_user_id;

    if coalesce(v_count,0) > 0 then
      v_total := v_total + v_count;
      v_details := v_details || jsonb_build_array(
        jsonb_build_object(
          'table',r.table_name,
          'column',r.column_name,
          'count',v_count
        )
      );
    end if;
  end loop;

  return jsonb_build_object('total',v_total,'references',v_details);
end;
$$;

revoke all on function public.user_admin_profile_reference_summary(uuid) from public;
revoke all on function public.user_admin_profile_reference_summary(uuid) from anon;
revoke all on function public.user_admin_profile_reference_summary(uuid) from authenticated;
grant execute on function public.user_admin_profile_reference_summary(uuid) to service_role;

commit;

notify pgrst, 'reload schema';

-- Verification. Both rows should appear.
select routine_name
from information_schema.routines
where routine_schema='public'
  and routine_name in ('user_admin_profile_reference_summary')
order by routine_name;

select table_name
from information_schema.tables
where table_schema='public'
  and table_name='user_admin_audit';
