-- Jalankan di Supabase: SQL Editor > New query
create table wallets(id uuid primary key default gen_random_uuid(),user_id uuid default auth.uid() references auth.users on delete cascade,name text not null,initial numeric default 0,created_at timestamptz default now());
create table categories(id uuid primary key default gen_random_uuid(),user_id uuid default auth.uid() references auth.users on delete cascade,name text not null,type text check(type in('in','out')),is_deposit boolean default false,created_at timestamptz default now());
create table transactions(id uuid primary key default gen_random_uuid(),user_id uuid default auth.uid() references auth.users on delete cascade,wallet_id uuid references wallets on delete cascade,category_id uuid references categories on delete cascade,type text check(type in('in','out')),amount numeric check(amount>0),note text,created_at timestamptz default now());
create table goals(id uuid primary key default gen_random_uuid(),user_id uuid default auth.uid() references auth.users on delete cascade,name text not null,daily numeric default 0,locked numeric default 0,last_alloc date default current_date,created_at timestamptz default now());
do $$ declare t text; begin foreach t in array array['wallets','categories','transactions','goals'] loop
 execute format('alter table %I enable row level security',t);
 execute format('create policy own on %I for all using (user_id=auth.uid()) with check (user_id=auth.uid())',t);
end loop; end $$;
