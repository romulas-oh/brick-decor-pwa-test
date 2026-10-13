-- Brick & Decor PWA v0.18.2 — signed quotation revision history
-- Run once AFTER the existing quotation E-sign foundation and SQL 06.
-- Read-only RPC: exposes request IDs/status metadata to authorised staff only.

begin;

create or replace function public.list_my_esign_requests_v182()
returns table(
  id uuid,
  quotation_no text,
  revision_id uuid,
  revision_no integer,
  revision_label text,
  status text,
  expires_at timestamptz,
  signed_at timestamptz,
  signed_by text,
  created_at timestamptz
)
language sql
stable
security definer
set search_path = ''
as $$
  select
    e.id,
    q.quotation_no,
    e.quotation_revision_id,
    r.revision_no,
    r.revision_label,
    case
      when e.status='PENDING' and e.expires_at < now() then 'EXPIRED'
      else e.status
    end as status,
    e.expires_at,
    e.signed_at,
    e.signed_by,
    e.created_at
  from public.esign_requests e
  join public.quotation_revisions r on r.id=e.quotation_revision_id
  join public.quotations q on q.id=r.quotation_id
  where auth.uid() is not null
    and private.can_access_case(e.case_id)
  order by q.quotation_no, r.revision_no, e.created_at desc;
$$;

revoke all on function public.list_my_esign_requests_v182() from public, anon;
grant execute on function public.list_my_esign_requests_v182() to authenticated;

commit;
notify pgrst, 'reload schema';

select routine_name
from information_schema.routines
where routine_schema='public'
  and routine_name='list_my_esign_requests_v182';
