-- El ingreso es sólo por legajo, sin contraseña. Una sesión anónima de Supabase
-- alcanza para pedir la verificación; el legajo sólo confirma que figura en el padrón.
-- Se quita la unicidad por cuenta: si no, el primero que verifica un legajo bloquea
-- a la persona real, y el mismo estudiante no podría entrar desde otro navegador.

alter table public.perfiles drop constraint if exists perfiles_legajo_key;

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
    raise exception 'Sesión no iniciada.' using errcode = '42501';
  end if;

  if not exists (
    select 1
    from public.padron_estudiantes as p
    where p.legajo = v_legajo
      and p.carrera = 'Licenciatura en Sistemas'
  ) then
    return false;
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
