import { createClient } from '@supabase/supabase-js';

const url = import.meta.env.PUBLIC_SUPABASE_URL;
const claveAnonima = import.meta.env.PUBLIC_SUPABASE_ANON_KEY;

if (!url || !claveAnonima) {
	throw new Error('Faltan PUBLIC_SUPABASE_URL o PUBLIC_SUPABASE_ANON_KEY. Copiá .env.example a .env y completalo.');
}

// La clave anónima es pública por diseño: el acceso real a los datos lo controla Supabase con RLS.
export const supabase = createClient(url, claveAnonima);
