-- Catálogo académico: carreras, planes de estudio y materias.
--  - Cada tabla tiene `id` propio, generado por la base (clave primaria).
--  - `identificador` es el código que trae cada plan o materia. No es clave y puede repetirse.
--  - Una materia puede estar en varios planes (y en varias carreras): tabla intermedia planes_materias.
--  - Dos materias pueden ser equivalentes aunque tengan distinto identificador: materias_equivalentes.
--  - Lectura para cualquier cuenta autenticada. Escritura sólo para administradores.

create table public.carreras (
  id bigint generated always as identity primary key,
  nombre text not null
);

comment on table public.carreras is 'Carreras de la UNLu. Escritura sólo para administradores.';

create table public.planes_estudio (
  id bigint generated always as identity primary key,
  carrera_id bigint not null references public.carreras (id) on delete cascade,
  identificador text not null,
  nombre text not null
);

comment on table public.planes_estudio is 'Planes de estudio de cada carrera. El identificador no es clave y puede repetirse.';

create index planes_estudio_carrera_id_idx on public.planes_estudio (carrera_id);

create table public.materias (
  id bigint generated always as identity primary key,
  identificador text not null,
  nombre text not null
);

comment on table public.materias is 'Materias. Se vinculan a planes con planes_materias. El identificador no es clave y puede repetirse.';

-- Una materia puede estar en varios planes y un plan tiene muchas materias.
create table public.planes_materias (
  plan_id bigint not null references public.planes_estudio (id) on delete cascade,
  materia_id bigint not null references public.materias (id) on delete cascade,
  primary key (plan_id, materia_id)
);

comment on table public.planes_materias is 'Materias que forman parte de cada plan de estudio.';

create index planes_materias_materia_id_idx on public.planes_materias (materia_id);

-- Equivalencias entre materias (por ejemplo, la misma materia con otro código en otro plan).
-- Cada par se guarda una sola vez, sin importar el orden: el índice único sobre
-- least/greatest impide tener (A, B) y (B, A) a la vez.
create table public.materias_equivalentes (
  materia_id bigint not null references public.materias (id) on delete cascade,
  equivalente_id bigint not null references public.materias (id) on delete cascade,
  constraint materias_equivalentes_distintas check (materia_id <> equivalente_id)
);

comment on table public.materias_equivalentes is 'Pares de materias equivalentes. Cada par aparece una sola vez, en cualquier orden.';

create unique index materias_equivalentes_par_key
  on public.materias_equivalentes (
    least(materia_id, equivalente_id),
    greatest(materia_id, equivalente_id)
  );

-- RLS: todas las tablas quedan cerradas por defecto, y se abren sólo lo necesario.
alter table public.carreras enable row level security;
alter table public.planes_estudio enable row level security;
alter table public.materias enable row level security;
alter table public.planes_materias enable row level security;
alter table public.materias_equivalentes enable row level security;

create policy "carreras: lectura autenticados"
  on public.carreras for select to authenticated using (true);

create policy "carreras: escritura administradores"
  on public.carreras for all to authenticated
  using ((select public.es_administrador()))
  with check ((select public.es_administrador()));

create policy "planes_estudio: lectura autenticados"
  on public.planes_estudio for select to authenticated using (true);

create policy "planes_estudio: escritura administradores"
  on public.planes_estudio for all to authenticated
  using ((select public.es_administrador()))
  with check ((select public.es_administrador()));

create policy "materias: lectura autenticados"
  on public.materias for select to authenticated using (true);

create policy "materias: escritura administradores"
  on public.materias for all to authenticated
  using ((select public.es_administrador()))
  with check ((select public.es_administrador()));

create policy "planes_materias: lectura autenticados"
  on public.planes_materias for select to authenticated using (true);

create policy "planes_materias: escritura administradores"
  on public.planes_materias for all to authenticated
  using ((select public.es_administrador()))
  with check ((select public.es_administrador()));

create policy "materias_equivalentes: lectura autenticados"
  on public.materias_equivalentes for select to authenticated using (true);

create policy "materias_equivalentes: escritura administradores"
  on public.materias_equivalentes for all to authenticated
  using ((select public.es_administrador()))
  with check ((select public.es_administrador()));

-- Permisos de tabla: anon no ve nada; authenticated lee, y las escrituras las filtra RLS.
revoke all on table
  public.carreras,
  public.planes_estudio,
  public.materias,
  public.planes_materias,
  public.materias_equivalentes
from anon, authenticated;

grant select, insert, update, delete on table
  public.carreras,
  public.planes_estudio,
  public.materias,
  public.planes_materias,
  public.materias_equivalentes
to authenticated;

-- Las columnas identity necesitan uso de su secuencia para insertar.
grant usage, select on sequence
  public.carreras_id_seq,
  public.planes_estudio_id_seq,
  public.materias_id_seq
to authenticated;
