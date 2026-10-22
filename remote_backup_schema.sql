-- Mesh Schools remote-backup schema add-on for Supabase/PostgreSQL.
-- Review and apply only AFTER schema.sql, and only in a dedicated project.
-- Store client-encrypted backup blobs here; never store plaintext student records as snapshots.
create table if not exists public.backup_snapshots (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id) on delete cascade,
  created_by uuid not null references auth.users(id) on delete restrict,
  created_at timestamptz not null default now(),
  format_version integer not null default 1,
  encryption_algorithm text not null check (encryption_algorithm = 'AES-GCM'),
  key_derivation text not null check (key_derivation = 'PBKDF2-SHA-256'),
  encrypted_payload jsonb not null,
  byte_size bigint not null check (byte_size > 0),
  device_label text,
  restore_tested_at timestamptz,
  constraint backup_payload_size_limit check (byte_size <= 10485760)
);
create index if not exists backup_snapshots_school_created_idx
  on public.backup_snapshots (school_id, created_at desc);

create table if not exists public.backup_events (
  id uuid primary key default gen_random_uuid(),
  school_id uuid not null references public.schools(id) on delete cascade,
  actor_user_id uuid references auth.users(id) on delete set null,
  event_type text not null check (event_type in ('backup_uploaded','backup_restored','backup_deleted','restore_failed')),
  snapshot_id uuid references public.backup_snapshots(id) on delete set null,
  occurred_at timestamptz not null default now(),
  details jsonb not null default '{}'::jsonb
);
create index if not exists backup_events_school_time_idx
  on public.backup_events (school_id, occurred_at desc);

alter table public.backup_snapshots enable row level security;
alter table public.backup_events enable row level security;

-- Only authenticated school admins can manage encrypted snapshots.
create policy "school admins read backup snapshots" on public.backup_snapshots
  for select to authenticated using (public.is_school_admin(school_id));
create policy "school admins create backup snapshots" on public.backup_snapshots
  for insert to authenticated with check (
    public.is_school_admin(school_id) and created_by = auth.uid()
  );
create policy "school admins delete backup snapshots" on public.backup_snapshots
  for delete to authenticated using (public.is_school_admin(school_id));

create policy "school admins read backup events" on public.backup_events
  for select to authenticated using (public.is_school_admin(school_id));
create policy "school admins record backup events" on public.backup_events
  for insert to authenticated with check (
    public.is_school_admin(school_id) and actor_user_id = auth.uid()
  );

-- Intentionally no UPDATE policy: backup snapshots and event records are immutable.
-- A production service should enforce upload size, rate limits, retention limits,
-- restore verification, and deletion/retention policy outside the client.
