-- Mesh Schools: secure Supabase/PostgreSQL starter schema.
-- Run only in a new Supabase project after reviewing it. Enable Auth and email confirmation.
create extension if not exists pgcrypto;
create type public.school_member_role as enum ('school_admin','teacher');
create type public.school_registration_status as enum ('pending','active','suspended');
create table public.schools (
 id uuid primary key default gen_random_uuid(), name text not null, email text not null,
 phone text, location text, postal_address text, head_teacher text, motto text,
 academic_year integer not null default extract(year from now())::int,
 registration_status public.school_registration_status not null default 'pending',
 created_at timestamptz not null default now()
);
create table public.school_members (
 school_id uuid not null references public.schools(id) on delete cascade,
 user_id uuid not null references auth.users(id) on delete cascade,
 role public.school_member_role not null default 'teacher',
 full_name text not null, email text not null, active boolean not null default true,
 primary key (school_id,user_id)
);
create table public.students (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 admission_no text not null, full_name text not null, class_name text not null, stream text,
 gender text, guardian_name text, guardian_phone text, active boolean not null default true,
 created_at timestamptz not null default now(), unique(school_id,admission_no)
);
create table public.subjects (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 name text not null, code text, max_score numeric not null default 100, unique(school_id,name)
);
create table public.examinations (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 name text not null, academic_year integer not null, term text not null, starts_on date, ends_on date
);
create table public.marks (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 student_id uuid not null references public.students(id) on delete cascade,
 subject_id uuid not null references public.subjects(id) on delete cascade,
 examination_id uuid not null references public.examinations(id) on delete cascade,
 score numeric not null check(score >= 0), max_score numeric not null default 100 check(max_score > 0),
 entered_by uuid references auth.users(id), updated_at timestamptz not null default now(),
 unique(student_id,subject_id,examination_id)
);
create table public.attendance (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 student_id uuid not null references public.students(id) on delete cascade, attendance_date date not null,
 status text not null check(status in ('present','absent','late','excused')), note text,
 recorded_by uuid references auth.users(id), unique(student_id,attendance_date)
);
create table public.fee_accounts (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 student_id uuid not null references public.students(id) on delete cascade, academic_year integer not null,
 term text not null, amount_due numeric(12,2) not null check(amount_due >= 0), description text
);
create table public.fee_payments (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 fee_account_id uuid not null references public.fee_accounts(id) on delete cascade,
 amount numeric(12,2) not null check(amount > 0), payment_method text, receipt_number text,
 paid_at timestamptz not null default now(), recorded_by uuid references auth.users(id)
);
create table public.timetable_lessons (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 class_name text not null, stream text, weekday smallint not null check(weekday between 1 and 7),
 starts_at time not null, ends_at time not null check(ends_at > starts_at),
 subject_id uuid references public.subjects(id), teacher_user_id uuid references auth.users(id), room text
);
create table public.grading_bands (
 id uuid primary key default gen_random_uuid(), school_id uuid not null references public.schools(id) on delete cascade,
 grade text not null, min_percent numeric not null check(min_percent between 0 and 100),
 points numeric, remark text, unique(school_id,grade)
);
create or replace function public.is_school_member(target_school uuid)
returns boolean language sql stable security definer set search_path=public
as $$ select exists(select 1 from public.school_members m where m.school_id=target_school and m.user_id=auth.uid() and m.active=true) $$;
create or replace function public.is_school_admin(target_school uuid)
returns boolean language sql stable security definer set search_path=public
as $$ select exists(select 1 from public.school_members m where m.school_id=target_school and m.user_id=auth.uid() and m.active=true and m.role='school_admin') $$;
-- Row Level Security: all tenant data is scoped by school membership.
do $$ declare t text; begin foreach t in array array['schools','school_members','students','subjects','examinations','marks','attendance','fee_accounts','fee_payments','timetable_lessons','grading_bands'] loop execute format('alter table public.%I enable row level security',t); end loop; end $$;
create policy "members can read their school profile" on public.schools for select using (public.is_school_member(id));
create policy "admins can update their school profile" on public.schools for update using (public.is_school_admin(id)) with check (public.is_school_admin(id));
create policy "members can read their membership" on public.school_members for select using (user_id=auth.uid() or public.is_school_admin(school_id));
create policy "admins manage memberships" on public.school_members for all using (public.is_school_admin(school_id)) with check (public.is_school_admin(school_id));
-- Shared tenant policy for school-owned data. Teacher permissions should be tightened by role before production use.
do $$ declare t text; begin foreach t in array array['students','subjects','examinations','marks','attendance','fee_accounts','fee_payments','timetable_lessons','grading_bands'] loop execute format('create policy "school members access own tenant rows" on public.%I for all using (public.is_school_member(school_id)) with check (public.is_school_member(school_id))',t); end loop; end $$;
-- IMPORTANT: school signup should be implemented through a trusted server/Edge Function:
-- 1) create auth user with email verification; 2) create school in pending state;
-- 3) create school_members row with school_admin role; 4) platform admin activates school.
-- Never expose service-role keys in browser or mobile app. Review RLS and role-specific write access before production.
