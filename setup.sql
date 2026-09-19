-- Portfolio backend for Supabase.
-- Before running: replace BOTH copies of PASTE-OWNER-USER-ID-HERE with your user's UID
-- (Authentication > Users > your user > User UID).

create table if not exists public.portfolio (
  id         int primary key default 1 check (id = 1),   -- exactly one row
  data       jsonb not null default '{}'::jsonb,          -- your whole portfolio
  updated_at timestamptz not null default now()
);

insert into public.portfolio (id, data) values (1, '{}'::jsonb)
on conflict (id) do nothing;

alter table public.portfolio enable row level security;

grant select on public.portfolio to anon, authenticated;
grant update on public.portfolio to authenticated;

-- Everyone can read the portfolio
drop policy if exists "Public can read portfolio" on public.portfolio;
create policy "Public can read portfolio"
  on public.portfolio for select
  to anon, authenticated
  using (true);

-- Only YOU can change it (no insert or delete policies exist, so those are blocked)
drop policy if exists "Owner can update portfolio" on public.portfolio;
create policy "Owner can update portfolio"
  on public.portfolio for update
  to authenticated
  using      (auth.uid() = 'df2548a9-9e04-49c8-945a-cf82dbacc5f2'::uuid)
  with check (auth.uid() = 'df2548a9-9e04-49c8-945a-cf82dbacc5f2'::uuid);   