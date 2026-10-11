import { supabase } from './supabase';

// Ingreso sólo por legajo: la sesión es anónima y el legajo verificado contra el padrón habilita el acceso.
export function iniciarControlDeSesion() {
	const modal = document.getElementById('modal-sesion') as HTMLDialogElement | null;
	const formulario = document.getElementById('paso-legajo') as HTMLFormElement | null;
	const inputLegajo = document.getElementById('legajo') as HTMLInputElement | null;
	const botonLegajo = document.getElementById('boton-legajo') as HTMLButtonElement | null;
	const mensajeError = document.getElementById('error-sesion');
	const contenido = document.querySelector('main');
	if (!modal || !formulario || !inputLegajo || !botonLegajo || !mensajeError || !contenido) return;

	const paginaProtegida = document.body.hasAttribute('data-protegida');
	// Adónde ir después de verificar el legajo.
	let destino = location.pathname;

	async function legajoVerificado(): Promise<boolean> {
		const { data: { session } } = await supabase.auth.getSession();
		if (!session) return false;
		// RLS: sólo se puede leer el perfil propio.
		const { data: perfil } = await supabase.from('perfiles').select('verificado_at').maybeSingle();
		return Boolean(perfil?.verificado_at);
	}

	function abrirModal(destinoTras: string) {
		destino = destinoTras;
		mensajeError!.textContent = '';
		botonLegajo!.disabled = false;
		modal!.showModal();
	}

	function fallar(mensaje: string) {
		mensajeError.textContent = mensaje;
		botonLegajo.disabled = false;
	}

	formulario.addEventListener('submit', async (evento) => {
		evento.preventDefault();
		botonLegajo.disabled = true;
		mensajeError.textContent = '';

		// Sin sesión previa se abre una anónima; el legajo es lo que habilita el acceso.
		const { data: { session } } = await supabase.auth.getSession();
		if (!session) {
			const { error } = await supabase.auth.signInAnonymously();
			if (error) return fallar('No pudimos iniciar sesión. Probá de nuevo.');
		}

		const { data, error } = await supabase.rpc('verificar_legajo', { p_legajo: inputLegajo.value.trim() });
		if (error) return fallar(error.message);
		if (data !== true) return fallar('No encontramos ese legajo en el padrón de Sistemas. Revisá el número.');

		modal.close();
		if (paginaProtegida) contenido.hidden = false;
		else location.assign(destino);
	});

	modal.querySelectorAll('[data-cerrar-modal]').forEach((boton) => {
		boton.addEventListener('click', () => modal.close());
	});

	modal.addEventListener('close', async () => {
		// En una sección protegida, cerrar el modal sin verificar el legajo lleva al inicio.
		if (paginaProtegida && !(await legajoVerificado())) location.replace('/');
	});

	// Enlaces protegidos: si el legajo está verificado se navega; si no, se frena la navegación y se muestra el modal.
	document.querySelectorAll<HTMLAnchorElement>('a[data-requiere-sesion]').forEach((enlace) => {
		enlace.addEventListener('click', async (evento) => {
			evento.preventDefault();
			const href = enlace.getAttribute('href') ?? '/';
			if (await legajoVerificado()) location.assign(href);
			else abrirModal(href);
		});
	});

	// Página protegida: el contenido queda oculto hasta verificar el legajo.
	if (paginaProtegida) {
		legajoVerificado().then((verificado) => {
			if (verificado) contenido.hidden = false;
			else abrirModal(destino);
		});
	}
}
