import { createClient } from 'npm:@supabase/supabase-js@2'

const corsHeaders = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Headers': 'authorization, x-client-info, apikey, content-type',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
}

const json = (body: unknown, status = 200) => new Response(JSON.stringify(body), {
  status,
  headers: { ...corsHeaders, 'Content-Type': 'application/json' },
})

const SUPABASE_URL = Deno.env.get('SUPABASE_URL')!
const SERVICE_ROLE_KEY = Deno.env.get('SUPABASE_SERVICE_ROLE_KEY')!
const admin = createClient(SUPABASE_URL, SERVICE_ROLE_KEY, {
  auth: { persistSession: false, autoRefreshToken: false },
})

const ALLOWED_ROLES = new Set([
  'Superadmin',
  'Admin',
  'Senior ID / Salesperson',
  'ID / Salesperson',
  'Project Manager',
  'Accounts',
  'Viewer',
])

const ALLOWED_PERMISSIONS = new Set([
  'Create Case','View Own Open Cases','View Closed Cases','View All Projects',
  'Create Quotation','Edit Quotation','View Actual Cost','Edit Actual Cost',
  'Approve Supplier Invoice','Override Supplier Approval','Make Supplier Payment',
  'Submit Case Closure','View Own Approved Commission','View All Commission',
  'Approve Commission','Manage Master Data','Manage Users',
])

function cleanText(v: unknown, max = 200) {
  return String(v ?? '').trim().slice(0, max)
}

function cleanPermissions(v: unknown) {
  if (!Array.isArray(v)) return [] as string[]
  return [...new Set(v.map(x => cleanText(x, 100)).filter(x => ALLOWED_PERMISSIONS.has(x)))]
}

function cleanCompanyIds(v: unknown) {
  if (!Array.isArray(v)) return [] as string[]
  return [...new Set(v.map(x => cleanText(x, 80)).filter(Boolean))]
}

async function requireSuperadmin(req: Request) {
  const authHeader = req.headers.get('Authorization') || ''
  const token = authHeader.replace(/^Bearer\s+/i, '').trim()
  if (!token) throw new Error('Authentication required')

  const { data: userData, error: userError } = await admin.auth.getUser(token)
  if (userError || !userData.user) throw new Error('Invalid or expired staff session')

  const { data: profile, error: profileError } = await admin
    .from('profiles')
    .select('id,email,name,role,active')
    .eq('id', userData.user.id)
    .single()
  if (profileError || !profile) throw new Error('Staff profile not found')
  if (!profile.active) throw new Error('This staff account is inactive')
  if (profile.role !== 'Superadmin') throw new Error('Superadmin access required')
  return { authUser: userData.user, profile }
}

async function activeCompanyIds() {
  const { data, error } = await admin.from('companies').select('id').eq('active', true)
  if (error) throw error
  return (data || []).map(x => x.id)
}

async function replaceCompanyAccess(userId: string, companyIds: string[]) {
  const allowed = new Set(await activeCompanyIds())
  const valid = companyIds.filter(id => allowed.has(id))
  const { error: delError } = await admin.from('user_company_access').delete().eq('user_id', userId)
  if (delError) throw delError
  if (valid.length) {
    const { error: insError } = await admin.from('user_company_access').insert(valid.map(company_id => ({ user_id: userId, company_id })))
    if (insError) throw insError
  }
  return valid
}

async function activeSuperadminCount() {
  const { count, error } = await admin
    .from('profiles')
    .select('id', { count: 'exact', head: true })
    .eq('role', 'Superadmin')
    .eq('active', true)
  if (error) throw error
  return count || 0
}

async function getProfile(userId: string) {
  const { data, error } = await admin
    .from('profiles')
    .select('id,email,name,role,permissions,can_view_closed_cases,active,commission_default_pct,created_at,updated_at')
    .eq('id', userId)
    .single()
  if (error || !data) throw new Error('Target staff profile not found')
  return data
}

async function protectLastSuperadmin(targetId: string, nextRole?: string, nextActive?: boolean, deleting = false) {
  const current = await getProfile(targetId)
  const removesActiveSuperadmin = current.role === 'Superadmin' && current.active && (
    deleting || nextRole !== undefined && nextRole !== 'Superadmin' || nextActive === false
  )
  if (removesActiveSuperadmin && await activeSuperadminCount() <= 1) {
    throw new Error('The last active Superadmin cannot be demoted, deactivated or deleted')
  }
  return current
}

async function audit(actor: any, targetId: string | null, targetEmail: string, action: string, detail: Record<string, unknown> = {}) {
  await admin.from('user_admin_audit').insert({
    actor_user_id: actor.id,
    actor_email: actor.email || '',
    target_user_id: targetId,
    target_email: targetEmail || '',
    action,
    detail,
  })
}

async function listUsers() {
  const { data: profiles, error: pErr } = await admin
    .from('profiles')
    .select('id,email,name,role,permissions,can_view_closed_cases,active,commission_default_pct,created_at,updated_at')
    .order('created_at', { ascending: true })
  if (pErr) throw pErr

  const { data: access, error: aErr } = await admin.from('user_company_access').select('user_id,company_id')
  if (aErr) throw aErr

  const authUsers: any[] = []
  let page = 1
  while (page <= 10) {
    const { data, error } = await admin.auth.admin.listUsers({ page, perPage: 100 })
    if (error) throw error
    authUsers.push(...(data.users || []))
    if ((data.users || []).length < 100) break
    page++
  }
  const authMap = new Map(authUsers.map(u => [u.id, u]))
  const companyMap = new Map<string, string[]>()
  for (const row of access || []) {
    if (!companyMap.has(row.user_id)) companyMap.set(row.user_id, [])
    companyMap.get(row.user_id)!.push(row.company_id)
  }

  return (profiles || []).map(p => {
    const au: any = authMap.get(p.id)
    return {
      ...p,
      email: p.email || au?.email || '',
      company_ids: companyMap.get(p.id) || [],
      email_confirmed_at: au?.email_confirmed_at || null,
      last_sign_in_at: au?.last_sign_in_at || null,
      auth_created_at: au?.created_at || null,
    }
  })
}

Deno.serve(async (req) => {
  if (req.method === 'OPTIONS') return new Response('ok', { headers: corsHeaders })
  if (req.method !== 'POST') return json({ error: 'POST required' }, 405)

  try {
    const caller = await requireSuperadmin(req)
    const body = await req.json().catch(() => ({}))
    const action = cleanText(body.action, 50).toLowerCase()

    if (action === 'list') {
      return json({ ok: true, users: await listUsers() })
    }

    if (action === 'create') {
      const email = cleanText(body.email, 320).toLowerCase()
      const name = cleanText(body.name, 160)
      const role = cleanText(body.role, 80)
      const mode = cleanText(body.mode || 'invite', 30)
      let permissions = cleanPermissions(body.permissions)
      let companyIds = cleanCompanyIds(body.company_ids)
      const canViewClosed = !!body.can_view_closed_cases
      const commission = Number(body.commission_default_pct || 0)

      if (!email || !email.includes('@')) throw new Error('Valid staff email is required')
      if (!name) throw new Error('Staff name is required')
      if (!ALLOWED_ROLES.has(role)) throw new Error('Invalid staff role')
      if (role === 'Superadmin') {
        permissions = ['ALL']
        companyIds = await activeCompanyIds()
      } else if (!companyIds.length) {
        throw new Error('Select at least one company for this staff account')
      }

      let created: any
      if (mode === 'temporary_password') {
        const password = String(body.password || '')
        if (password.length < 10) throw new Error('Temporary password must be at least 10 characters')
        const { data, error } = await admin.auth.admin.createUser({
          email,
          password,
          email_confirm: true,
          user_metadata: { name },
        })
        if (error) throw error
        created = data.user
      } else {
        const { data, error } = await admin.auth.admin.inviteUserByEmail(email, { data: { name } })
        if (error) throw error
        created = data.user
      }
      if (!created?.id) throw new Error('Supabase Auth user was not created')

      const profilePayload = {
        id: created.id,
        email,
        name,
        role,
        permissions,
        can_view_closed_cases: role === 'Superadmin' ? true : canViewClosed,
        active: true,
        commission_default_pct: ['ID / Salesperson','Senior ID / Salesperson'].includes(role) ? commission : 0,
        updated_at: new Date().toISOString(),
      }
      const { error: profileError } = await admin.from('profiles').upsert(profilePayload, { onConflict: 'id' })
      if (profileError) {
        await admin.auth.admin.deleteUser(created.id).catch(() => {})
        throw profileError
      }
      await replaceCompanyAccess(created.id, companyIds)
      await audit(caller.authUser, created.id, email, 'CREATE_USER', { role, mode, company_ids: companyIds })
      return json({ ok: true, user_id: created.id, mode })
    }

    const targetId = cleanText(body.user_id, 80)
    if (!targetId) throw new Error('Target user is required')
    const target = await getProfile(targetId)

    if (action === 'update') {
      const name = cleanText(body.name, 160)
      const role = cleanText(body.role, 80)
      let permissions = cleanPermissions(body.permissions)
      let companyIds = cleanCompanyIds(body.company_ids)
      const canViewClosed = !!body.can_view_closed_cases
      const commission = Number(body.commission_default_pct || 0)
      if (!name) throw new Error('Staff name is required')
      if (!ALLOWED_ROLES.has(role)) throw new Error('Invalid staff role')
      if (targetId === caller.authUser.id && role !== 'Superadmin') throw new Error('You cannot demote your own Superadmin account')
      await protectLastSuperadmin(targetId, role, true, false)
      if (role === 'Superadmin') {
        permissions = ['ALL']
        companyIds = await activeCompanyIds()
      } else if (!companyIds.length) {
        throw new Error('Select at least one company for this staff account')
      }
      const { error } = await admin.from('profiles').update({
        name,
        role,
        permissions,
        can_view_closed_cases: role === 'Superadmin' ? true : canViewClosed,
        commission_default_pct: ['ID / Salesperson','Senior ID / Salesperson'].includes(role) ? commission : 0,
        updated_at: new Date().toISOString(),
      }).eq('id', targetId)
      if (error) throw error
      await admin.auth.admin.updateUserById(targetId, { user_metadata: { name } })
      await replaceCompanyAccess(targetId, companyIds)
      await audit(caller.authUser, targetId, target.email || '', 'UPDATE_USER', { role, company_ids: companyIds })
      return json({ ok: true })
    }

    if (action === 'deactivate') {
      if (targetId === caller.authUser.id) throw new Error('You cannot deactivate your own account')
      await protectLastSuperadmin(targetId, undefined, false, false)
      const { error } = await admin.from('profiles').update({ active: false, updated_at: new Date().toISOString() }).eq('id', targetId)
      if (error) throw error
      await audit(caller.authUser, targetId, target.email || '', 'DEACTIVATE_USER')
      return json({ ok: true })
    }

    if (action === 'reactivate') {
      const { error } = await admin.from('profiles').update({ active: true, updated_at: new Date().toISOString() }).eq('id', targetId)
      if (error) throw error
      await audit(caller.authUser, targetId, target.email || '', 'REACTIVATE_USER')
      return json({ ok: true })
    }

    if (action === 'password_reset_link') {
      const email = target.email || ''
      if (!email) throw new Error('Target account has no email address')
      const { data, error } = await admin.auth.admin.generateLink({ type: 'recovery', email })
      if (error) throw error
      await audit(caller.authUser, targetId, email, 'GENERATE_PASSWORD_RESET_LINK')
      return json({ ok: true, action_link: data.properties?.action_link || '' })
    }

    if (action === 'delete') {
      if (targetId === caller.authUser.id) throw new Error('You cannot permanently delete your own account')
      await protectLastSuperadmin(targetId, undefined, undefined, true)
      const { data: refs, error: refError } = await admin.rpc('user_admin_profile_reference_summary', { p_user_id: targetId })
      if (refError) throw refError
      const total = Number(refs?.total || 0)
      if (total > 0) {
        const summary = (refs.references || []).slice(0, 6).map((x: any) => `${x.table}.${x.column}: ${x.count}`).join(', ')
        throw new Error(`This user has ${total} historical record reference(s). Deactivate the account instead. ${summary}`)
      }
      await admin.from('user_company_access').delete().eq('user_id', targetId)
      await audit(caller.authUser, targetId, target.email || '', 'PERMANENT_DELETE_USER')
      const { error } = await admin.auth.admin.deleteUser(targetId)
      if (error) throw error
      return json({ ok: true })
    }

    throw new Error('Unsupported user-admin action')
  } catch (e) {
    return json({ error: e instanceof Error ? e.message : String(e) }, 400)
  }
})
