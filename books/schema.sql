-- 채윤 독서생활 — Supabase 테이블 (SQL Editor에 통째로 붙여넣고 Run 한 번만 실행하세요)

-- 1) 책 목록
create table if not exists reading_books (
  id           uuid primary key default gen_random_uuid(),
  title        text not null,
  author       text not null default '',
  cover_url    text not null default '',
  category     text not null default '기타',
  status       text not null default 'reading',   -- reading(읽는 중) / done(완독) / wish(읽고 싶음)
  total_pages  int,
  started_at   date,
  finished_at  date,
  created_at   timestamptz not null default now()
);

-- 2) 독서 기록 (하루에 여러 번 기록 가능)
create table if not exists reading_logs (
  id          uuid primary key default gen_random_uuid(),
  book_id     uuid not null references reading_books(id) on delete cascade,
  log_date    date not null,
  page_from   int,
  page_to     int,
  pages       int not null default 0,             -- 그날 읽은 쪽수
  quote       text not null default '',           -- 필사
  thought     text not null default '',           -- 내 생각
  created_at  timestamptz not null default now()
);
create index if not exists reading_logs_date_idx on reading_logs (log_date);
create index if not exists reading_logs_book_idx on reading_logs (book_id);

-- 3) 접근 권한 (기존 대시보드와 같은 방식: 로그인 없이 anon 키로 읽기/쓰기)
alter table reading_books enable row level security;
alter table reading_logs  enable row level security;

drop policy if exists "anon all reading_books" on reading_books;
drop policy if exists "anon all reading_logs"  on reading_logs;
create policy "anon all reading_books" on reading_books for all to anon using (true) with check (true);
create policy "anon all reading_logs"  on reading_logs  for all to anon using (true) with check (true);

-- 4) (추가) '날짜 모름(월만 기록)' 기능용 칸 — 이미 위 테이블을 만든 경우 이 한 줄만 따로 실행하세요
alter table reading_logs add column if not exists date_unknown boolean not null default false;
