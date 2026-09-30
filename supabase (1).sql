-- Jalankan sekali di Supabase: SQL Editor > New query > Run
create sequence booking_seq start 1001;

create table bookings(
  id          text primary key default ('PRL-' || nextval('booking_seq')),
  visit_date  date not null,
  visit_time  text not null check (visit_time in ('09:00','11:00','14:00','15:30')),
  name        text not null,
  ic          text not null,
  phone       text not null,
  email       text not null,
  org         text not null,
  n           int  not null check (n between 1 and 30),
  oku         text default '',
  created_at  timestamptz default now(),
  unique (visit_date, visit_time)          -- mustahil 2 tempahan pada slot yang sama
);

alter table bookings enable row level security;
-- Tiada polisi untuk pengunjung (anon) => pengunjung TIDAK boleh baca/ubah jadual ini.
-- Hanya kakitangan yang log masuk (role authenticated) boleh baca & batal.
create policy "kakitangan baca"  on bookings for select to authenticated using (true);
create policy "kakitangan batal" on bookings for delete to authenticated using (true);

-- Pengunjung hanya nampak slot yang sudah penuh (tarikh + masa sahaja, tiada data peribadi)
create function get_taken(p_from date, p_to date)
returns table(d date, t text) language sql security definer set search_path = public as $$
  select visit_date, visit_time from bookings where visit_date between p_from and p_to
$$;

-- Pengunjung membuat tempahan melalui fungsi ini sahaja (disahkan di pelayan)
create function make_booking(p_date date, p_time text, p_name text, p_ic text, p_phone text,
                             p_email text, p_org text, p_n int, p_oku text)
returns text language plpgsql security definer set search_path = public as $$
declare v_id text;
begin
  if p_date < (now() at time zone 'Asia/Kuala_Lumpur')::date then raise exception 'past'; end if;
  if extract(isodow from p_date) in (6,7) then raise exception 'weekend'; end if;  -- Isnin-Jumaat sahaja
  insert into bookings(visit_date,visit_time,name,ic,phone,email,org,n,oku)
  values (p_date,p_time,trim(p_name),trim(p_ic),trim(p_phone),trim(p_email),trim(p_org),p_n,coalesce(p_oku,''))
  returning id into v_id;
  return v_id;
exception when unique_violation then raise exception 'taken';
end $$;

grant execute on function get_taken(date,date) to anon, authenticated;
grant execute on function make_booking(date,text,text,text,text,text,text,int,text) to anon, authenticated;
