const SLOTS=["09:00","11:00","14:00","15:30"];
// Tarikh persidangan CONTOH - gantikan dengan jadual rasmi Parlimen
const SIT={};
["2026-10-05","2026-10-06","2026-10-07","2026-10-08","2026-10-12","2026-10-13","2026-10-14","2026-10-15"].forEach(d=>SIT[d]="dr");
["2026-10-19","2026-10-20","2026-10-21","2026-10-22"].forEach(d=>SIT[d]="dn");
const $=id=>document.getElementById(id);
const pad=n=>String(n).padStart(2,"0");
const fmt=d=>`${d.getFullYear()}-${pad(d.getMonth()+1)}-${pad(d.getDate())}`;
const todayS=fmt(new Date());
const esc=s=>String(s??"").replace(/[&<>"]/g,c=>({"&":"&amp;","<":"&lt;",">":"&gt;",'"':"&quot;"}[c]));
const mask=ic=>"******"+String(ic).replace(/\D/g,"").slice(-4);
const configured=!String(APP_CONFIG.url).includes("PASTE");
const sb=configured?supabase.createClient(APP_CONFIG.url,APP_CONFIG.key):null;
