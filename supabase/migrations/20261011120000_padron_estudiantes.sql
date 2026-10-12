-- Padrón de estudiantes de la UNLu, cargado a mano desde el padrón electoral.
-- Sólo guarda lo necesario para verificar el legajo: no hay nombres ni DNI.
-- RLS activado y sin políticas: ni anon ni authenticated pueden leer la tabla.
-- Sólo la consulta de verificar_legajo (security definer) mira el padrón.

create table public.padron_estudiantes (
  legajo text primary key,
  carrera text not null
);

comment on table public.padron_estudiantes is 'Padrón electoral de estudiantes. Carga manual. No exponer al cliente.';

alter table public.padron_estudiantes enable row level security;

revoke all on table public.padron_estudiantes from anon, authenticated;
