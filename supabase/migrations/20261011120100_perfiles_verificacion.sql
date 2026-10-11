-- Perfil de cada cuenta de Google, con el legajo verificado contra el padrón.
-- El cliente nunca escribe en perfiles: sólo lo hace verificar_legajo().

create table public.perfiles (
  id uuid primary key references auth.users (id) on delete cascade,
  legajo text unique,
  verificado_at timestamptz
);

comment on table public.perfiles is 'Legajo verificado por cuenta. Escritura sólo vía verificar_legajo().';

alter table public.perfiles enable row level security;

-- Cada usuario puede leer su propio perfil (para saber si ya está verificado), nada más.
create policy "perfil propio: lectura"
  on public.perfiles
  for select
  to authenticated
  using ((select auth.uid()) = id);

revoke all on table public.perfiles from anon, authenticated;
grant select on table public.perfiles to authenticated;

-- Verifica el legajo contra el padrón de la Licenciatura en Sistemas y, si coincide,
-- asocia el legajo a la cuenta actual. Devuelve false si el legajo no está en el padrón.
create or replace function public.verificar_legajo(p_legajo text)
returns boolean
language plpgsql
security definer
set search_path = ''
as $$
declare
  v_legajo text := btrim(p_legajo);
begin
  if (select auth.uid()) is null then
    raise exception 'Necesitás iniciar sesión para verificar tu legajo.' using errcode = '42501';
  end if;

  if not exists (
    select 1
    from public.padron_estudiantes as p
    where p.legajo = v_legajo
      and p.carrera = 'Licenciatura en Sistemas'
  ) then
    return false;
  end if;

  if exists (
    select 1
    from public.perfiles as p
    where p.legajo = v_legajo
      and p.id <> (select auth.uid())
  ) then
    raise exception 'Ese legajo ya está asociado a otra cuenta.' using errcode = 'P0001';
  end if;

  insert into public.perfiles (id, legajo, verificado_at)
  values ((select auth.uid()), v_legajo, now())
  on conflict (id) do update
    set legajo = excluded.legajo,
        verificado_at = excluded.verificado_at;

  return true;
end;
$$;

revoke all on function public.verificar_legajo(text) from public, anon;
grant execute on function public.verificar_legajo(text) to authenticated;
