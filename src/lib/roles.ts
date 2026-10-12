import { supabase } from './supabase';

export type Rol = 'estudiante' | 'administrador';

// Rol de la cuenta con sesión iniciada. Devuelve null si no hay sesión o si no se pudo leer el perfil.
export async function obtenerRol(): Promise<Rol | null> {
	const { data: sesion } = await supabase.auth.getSession();
	if (!sesion.session) return null;

	const { data, error } = await supabase
		.from('perfiles')
		.select('rol')
		.eq('id', sesion.session.user.id)
		.maybeSingle();

	if (error || !data) return null;
	return data.rol as Rol;
}
