-- AI 사용 일지 테이블 (회사/학교 모드 공용) — Supabase SQL Editor에 붙여넣고 Run 한 번만 실행하세요
create table if not exists dash_ai_log (
  id          uuid primary key default gen_random_uuid(),
  mode        text not null,                 -- work(업무) / school(공부)
  log_date    date not null,
  did         text not null default '',      -- 오늘 한 일
  ai_use      text not null default '',      -- AI 사용한 부분
  my_opinion  text not null default '',      -- 나의 의견
  feedback    text not null default '',      -- 피드백
  created_at  timestamptz not null default now()
);
create index if not exists dash_ai_log_idx on dash_ai_log (mode, log_date);

alter table dash_ai_log enable row level security;
drop policy if exists "anon all dash_ai_log" on dash_ai_log;
create policy "anon all dash_ai_log" on dash_ai_log for all to anon using (true) with check (true);
