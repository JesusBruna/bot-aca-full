-- ============================================================
-- CACHE DE PREGUNTAS FRECUENTES DEL BOT
-- ============================================================
-- Cómo usar: entrá a tu proyecto de Supabase → SQL Editor → New query,
-- pegá todo este archivo y hacé clic en "Run".

create table if not exists faq_cache (
  question_normalized text primary key,
  question_original text not null,
  answer text not null,
  sources jsonb not null default '[]'::jsonb,
  hit_count int not null default 0,
  created_at timestamptz not null default now(),
  updated_at timestamptz not null default now()
);

alter table faq_cache enable row level security;

-- La función (netlify/functions/chat.js) necesita leer y escribir en esta
-- tabla usando la misma clave publica que ya usa el resto del proyecto.
create policy "Cualquiera puede leer la cache"
  on faq_cache for select
  using (true);

create policy "Cualquiera puede crear entradas en la cache"
  on faq_cache for insert
  with check (true);

create policy "Cualquiera puede actualizar la cache"
  on faq_cache for update
  using (true);

-- Función auxiliar para sumar 1 al contador de veces que se uso una
-- respuesta cacheada (solo para que puedas ver, mirando la tabla, cuáles
-- son las preguntas más repetidas).
create or replace function increment_faq_hit(q text)
returns void as $$
  update faq_cache set hit_count = hit_count + 1 where question_normalized = q;
$$ language sql;
