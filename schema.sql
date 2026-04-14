-- Run this in your Supabase SQL Editor

-- Profiles (extends auth.users)
create table if not exists profiles (
  id uuid references auth.users on delete cascade primary key,
  username text unique not null,
  is_admin boolean default false
);
alter table profiles enable row level security;
create policy "Users can read all profiles" on profiles for select using (true);
create policy "Users can update own profile" on profiles for insert with check (auth.uid() = id);
create policy "Users can update own profile" on profiles for update using (auth.uid() = id);

-- Pool settings (single row, id=1)
create table if not exists pool_settings (
  id integer primary key default 1,
  r1_state text default 'open',
  r2_state text default 'locked',
  r3_state text default 'locked',
  r4_state text default 'locked'
);
alter table pool_settings enable row level security;
create policy "Anyone can read settings" on pool_settings for select using (true);
create policy "Admins can update settings" on pool_settings for update using (
  exists (select 1 from profiles where id = auth.uid() and is_admin = true)
);
-- Insert default row
insert into pool_settings (id) values (1) on conflict do nothing;

-- Picks
create table if not exists picks (
  id uuid default gen_random_uuid() primary key,
  user_id uuid references auth.users on delete cascade not null,
  round_id text not null,
  series_id text not null,
  winner text,
  games text,
  unique(user_id, round_id, series_id)
);
alter table picks enable row level security;
create policy "Users can read all picks" on picks for select using (true);
create policy "Users can insert own picks" on picks for insert with check (auth.uid() = user_id);
create policy "Users can update own picks" on picks for update using (auth.uid() = user_id);

-- Results (admin-entered)
create table if not exists results (
  id uuid default gen_random_uuid() primary key,
  round_id text not null,
  series_id text not null,
  winner text,
  games text,
  unique(round_id, series_id)
);
alter table results enable row level security;
create policy "Anyone can read results" on results for select using (true);
create policy "Admins can insert results" on results for insert with check (
  exists (select 1 from profiles where id = auth.uid() and is_admin = true)
);
create policy "Admins can update results" on results for update using (
  exists (select 1 from profiles where id = auth.uid() and is_admin = true)
);

-- Tiebreakers
create table if not exists tiebreakers (
  user_id text primary key,
  goals integer
);
alter table tiebreakers enable row level security;
create policy "Anyone can read tiebreakers" on tiebreakers for select using (true);
create policy "Users can upsert own tiebreaker" on tiebreakers for insert with check (auth.uid()::text = user_id or user_id = '__result__');
create policy "Users can update own tiebreaker" on tiebreakers for update using (auth.uid()::text = user_id or user_id = '__result__');
