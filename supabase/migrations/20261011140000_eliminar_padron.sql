-- Elimina la verificación por legajo y el padrón de estudiantes.
-- Vuelve el acceso a ser sólo con Google. Usa IF EXISTS: sirve tanto si las
-- migraciones anteriores se aplicaron como si nunca llegaron a la base.

drop function if exists public.verificar_legajo(text);
drop table if exists public.perfiles;
drop table if exists public.padron_estudiantes;
