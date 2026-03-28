-- Supabase DB Schema for Golf Charity Platform
-- Run in Supabase SQL editor after creating project

-- Enable RLS later

-- Users extended by Supabase auth
-- Profile table for extra user data
create table profiles (
  id uuid references auth.users on delete cascade primary key,
  sub_status text default 'inactive' check (sub_status in ('inactive', 'monthly', 'yearly')),
  charity_id integer,
  avg_stableford numeric default 0,
  total_scores integer default 0,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Scores table
create table scores (
  id bigserial primary key,
  user_id uuid references profiles(id) on delete cascade not null,
  date date not null,
  holes integer default 18 check (holes in (9,18)),
  hole_pars integer[] not null,
  hole_strokes integer[] not null,
  total_stableford integer not null,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Charities
create table charities (
  id serial primary key,
  name text not null,
  description text,
  logo_url text
);

insert into charities (name, description) values 
('Birdies for Charity', 'Supporting junior golf programs'),
('Fairway Foundation', 'Sustainable golf courses'),
('Putt for Good', 'Community sports access');

-- Draws
create table draws (
  id serial primary key,
  month date not null, -- first of month
  status text default 'pending' check (status in ('pending', 'running', 'completed')),
  winners jsonb[], -- array of {user_id, prize}
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Subscriptions tracking
create table subscriptions (
  id uuid primary key default gen_random_uuid(),
  user_id uuid references profiles(id) on delete cascade not null,
  stripe_customer_id text,
  stripe_subscription_id text,
  charity_id integer references charities(id),
  status text,
  current_period_end timestamp with time zone,
  created_at timestamp with time zone default timezone('utc'::text, now()) not null
);

-- Indexes
create index idx_scores_user_date on scores (user_id, date desc);
create index idx_subscriptions_user on subscriptions (user_id);

-- Trigger to update profile avg after score insert
create or replace function update_profile_stats()
returns trigger as $$
begin
  update profiles p
  set 
    total_scores = (select count(*) from scores where user_id = p.id),
    avg_stableford = (select avg(total_stableford) from scores where user_id = p.id)
  where id = new.user_id;
  return new;
end;
$$ language plpgsql;

create trigger scores_update_profile
  after insert or update on scores
  for each row execute procedure update_profile_stats();

-- RLS policies (enable after)
alter table profiles enable row level security;
alter table scores enable row level security;

create policy user_profiles on profiles for all using (auth.uid() = id);
create policy user_scores on scores for all using (auth.uid() = (select id from profiles where auth.uid() = id));

