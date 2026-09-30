# Sistem Tempahan Lawatan Parlimen

- `index.html` – pengunjung (kalendar, 4 slot sehari, borang tempahan)
- `staff.html` – kakitangan (log masuk, senarai tempahan, batal, muat turun Excel)
- `supabase.sql` – pangkalan data + peraturan keselamatan (RLS)
- `config.js` – URL & anon key Supabase

## Persediaan
1. Cipta projek percuma di supabase.com.
2. SQL Editor → tampal `supabase.sql` → Run.
3. Authentication → Sign In / Providers → matikan **Allow new users to sign up**.
4. Authentication → Users → **Add user** (e-mel + kata laluan) untuk setiap kakitangan.
5. Project Settings → API → salin **Project URL** dan **anon public key** ke `config.js`.
6. Muat naik semua fail ke GitHub → Settings → Pages → Deploy from branch (`main`, root).

Jangan sekali-kali letak `service_role` key dalam fail ini.
