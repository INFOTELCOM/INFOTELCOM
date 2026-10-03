create table if not exists profiles (id uuid primary key references auth.users(id) on delete cascade, full_name text, role text not null default 'secretaire' check (role in ('admin','secretaire','surveillant')), created_at timestamptz not null default now());

alter table students enable row level security;
alter table school_years enable row level security;
alter table classes enable row level security;
alter table enrollments enable row level security;
alter table subjects enable row level security;
alter table class_subjects enable row level security;
alter table evaluations enable row level security;
alter table grades enable row level security;
alter table audit_logs enable row level security;
alter table profiles enable row level security;

create policy "authenticated school access" on students for all to authenticated using (true) with check (true);
create policy "authenticated school years" on school_years for all to authenticated using (true) with check (true);
create policy "authenticated classes" on classes for all to authenticated using (true) with check (true);
create policy "authenticated enrollments" on enrollments for all to authenticated using (true) with check (true);
create policy "authenticated subjects" on subjects for all to authenticated using (true) with check (true);
create policy "authenticated class subjects" on class_subjects for all to authenticated using (true) with check (true);
create policy "authenticated evaluations" on evaluations for all to authenticated using (true) with check (true);
create policy "authenticated grades" on grades for all to authenticated using (true) with check (true);
create policy "authenticated audit" on audit_logs for select to authenticated using (true);
create policy "authenticated profiles" on profiles for select to authenticated using (true);

create or replace function public.handle_new_user() returns trigger set search_path = public language plpgsql security definer as $$ begin insert into public.profiles(id,full_name) values(new.id,coalesce(new.raw_user_meta_data->>'full_name',new.email)); return new; end; $$;
drop trigger if exists on_auth_user_created on auth.users;
create trigger on_auth_user_created after insert on auth.users for each row execute procedure public.handle_new_user();