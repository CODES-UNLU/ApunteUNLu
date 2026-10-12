-- Roles de usuario. Cada cuenta de Google tiene un perfil con un rol:
--  - 'estudiante': valor por defecto, para todas las cuentas nuevas.
--  - 'administrador': se asigna a mano desde el SQL editor de Supabase.
-- El cliente puede leer su propio perfil, pero nunca cambiar el rol.

create table public.perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  rol text not null default 'estudiante',
  creado_at timestamptz not null default now(),
  constraint perfiles_rol_valido check (rol in ('estudiante', 'administrador'))
);

comment on table public.perfiles is 'Perfil y rol de cada cuenta. Escritura sólo desde el servidor (triggers y SQL editor).';
comment on column public.perfiles.rol is 'estudiante (por defecto) o administrador. Lo cambia sólo un administrador desde Supabase.';

alter table public.perfiles enable row level security;

-- Cada usuario ve su propia fila (para saber su rol), nada más.
create policy "perfil propio: lectura"
  on public.perfiles
  for select
  to authenticated
  using ((select auth.uid()) = id);

revoke all on table public.perfiles from anon, authenticated;
grant select on table public.perfiles to authenticated;

-- Crea el perfil con rol 'estudiante' en cada cuenta nueva.
create or replace function public.crear_perfil_nuevo()
returns trigger
language plpgsql
security definer
set search_path = ''
as $$
begin
  insert into public.perfiles (id)
  values (new.id)
  on conflict (id) do nothing;

  return new;
end;
$$;

revoke all on function public.crear_perfil_nuevo() from public, anon, authenticated;

create trigger al_crear_usuario
  after insert on auth.users
  for each row
  execute function public.crear_perfil_nuevo();

-- Las cuentas que ya existían también reciben su perfil.
insert into public.perfiles (id)
select u.id
from auth.users as u
on conflict (id) do nothing;

-- Para usar en políticas RLS de otras tablas (apuntes, finales, etc.).
create or replace function public.es_administrador()
returns boolean
language sql
stable
security definer
set search_path = ''
as $$
  select exists (
    select 1
    from public.perfiles as p
    where p.id = (select auth.uid())
      and p.rol = 'administrador'
  );
$$;

revoke all on function public.es_administrador() from public, anon;
grant execute on function public.es_administrador() to authenticated;
