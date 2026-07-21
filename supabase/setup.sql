-- ============================================================
-- FORO DE IDEAS Y BUENAS PRACTICAS — configuración de Supabase
-- ============================================================
-- Cómo usar este archivo:
-- 1) Entrá a tu proyecto en supabase.com → SQL Editor → New query
-- 2) Pegá TODO este archivo y hacé clic en "Run"
-- 3) Listo: la tabla, los permisos y las publicaciones de ejemplo
--    quedan creados de una sola vez.

-- Tabla principal: cada fila es una publicación completa, con sus
-- comentarios y "me gusta" guardados adentro (columnas jsonb).
-- Es un diseño simple a propósito, para no complicar la migración.
create table if not exists forum_posts (
  id text primary key,
  title text not null,
  description text not null,
  category text not null,
  status text not null default 'nueva',
  author text not null,
  created_at timestamptz not null default now(),
  views int not null default 0,
  likes jsonb not null default '[]'::jsonb,
  comments jsonb not null default '[]'::jsonb
);

-- Habilita seguridad a nivel de fila (obligatorio en Supabase para
-- que la clave pública de la app pueda leer/escribir).
alter table forum_posts enable row level security;

-- Como el foro no tiene login con contraseña (solo un nombre elegido
-- por cada persona), estas políticas son abiertas: cualquiera con la
-- clave pública puede leer, crear, editar y borrar. Es la app (no la
-- base de datos) la que hoy decide mostrar los botones de editar o
-- borrar solo en las publicaciones propias.
create policy "Cualquiera puede leer publicaciones"
  on forum_posts for select
  using (true);

create policy "Cualquiera puede crear publicaciones"
  on forum_posts for insert
  with check (true);

create policy "Cualquiera puede editar publicaciones"
  on forum_posts for update
  using (true);

create policy "Cualquiera puede borrar publicaciones"
  on forum_posts for delete
  using (true);

-- Publicaciones de ejemplo, para que el foro no arranque vacío.
-- Podés borrarlas cuando quieras desde la app (o desde acá con un
-- DELETE FROM forum_posts;).
insert into forum_posts (id, title, description, category, status, author, created_at, views, likes, comments)
values
(
  'p1',
  'Etiquetar los productos de reposición rápida con color',
  'Probamos en nuestra tienda poner una etiqueta de color en los productos que se reponen más de 3 veces por semana. Bajó el tiempo de reposición porque el personal nuevo identifica más rápido qué revisar primero. Lo aplicamos primero en bebidas frías y funcionó tan bien que lo extendimos a snacks.',
  'Gestión y Stock',
  'implementada',
  'Melina Suárez',
  now() - interval '6 days',
  34,
  '[]'::jsonb,
  '[{"id":"c1","author":"Diego Farías","date":"2026-07-14T12:00:00Z","text":"Lo probamos en nuestra sucursal también, excelente resultado. ¿Qué colores usaron?","likes":[]}]'::jsonb
),
(
  'p2',
  'Guion corto para ofrecer el combo AutoFull sin sonar forzado',
  'Noté que cuando ofrecemos el combo con la frase exacta del manual, suena robótico y baja la conversión. Armamos una variante más natural adaptada a cada franja horaria (café a la mañana, bebida fría a la tarde) y mejoró bastante la aceptación. Lo compartimos para que el equipo de capacitación lo evalúe.',
  'Ciclo de Servicio',
  'evaluacion',
  'Rodrigo Paz',
  now() - interval '2 days',
  21,
  '[]'::jsonb,
  '[]'::jsonb
),
(
  'p3',
  'Problema: se pierde tiempo pidiendo el ticket en Pickup cuando el cliente ya lo tiró',
  'Varios clientes tiran el ticket antes de llegar a retirar el pedido. Estamos evaluando validar por número de pedido en la app en vez de pedir el ticket físico. ¿Alguien ya probó algo similar?',
  'Atención al Cliente',
  'nueva',
  'Melina Suárez',
  now() - interval '5 hours',
  9,
  '[]'::jsonb,
  '[]'::jsonb
)
on conflict (id) do nothing;
