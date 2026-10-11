import { supabase } from './supabase';

// Control de sesión: antes de entrar a una sección protegida se verifica la sesión y, si no hay, se abre el modal de inicio.
export function iniciarControlDeSesion() {
	const modal = document.getElementById('modal-sesion') as HTMLDialogElement | null;
	const botonGoogle = document.getElementById('boton-google') as HTMLButtonElement | null;
	const mensajeError = document.getElementById('error-sesion');
	const contenido = document.querySelector('main');
	if (!modal || !botonGoogle || !mensajeError || !contenido) return;

	const paginaProtegida = document.body.hasAttribute('data-protegida');
	// Adónde volver después de iniciar sesión.
	let destino = location.pathname;

	async function haySesion() {
		const { data } = await supabase.auth.getSession();
		return data.session !== null;
	}

	function abrirModal(destinoTras: string) {
		destino = destinoTras;
		mensajeError!.textContent = '';
		botonGoogle!.disabled = false;
		modal!.showModal();
	}

	botonGoogle.addEventListener('click', async () => {
		botonGoogle.disabled = true;
		const { error } = await supabase.auth.signInWithOAuth({
			provider: 'google',
			options: { redirectTo: new URL(destino, location.origin).href },
		});
		// Si todo sale bien, el navegador se va a Google; sólo llegamos acá si falla.
		if (error) {
			mensajeError.textContent = 'No pudimos iniciar sesión. Probá de nuevo.';
			botonGoogle.disabled = false;
		}
	});

	modal.querySelectorAll('[data-cerrar-modal]').forEach((boton) => {
		boton.addEventListener('click', () => modal.close());
	});

	modal.addEventListener('close', async () => {
		// En una sección protegida, cerrar el modal sin iniciar sesión lleva al inicio.
		if (paginaProtegida && !(await haySesion())) location.replace('/');
	});

	// Enlaces protegidos: si hay sesión se navega; si no, se frena la navegación y se muestra el modal.
	document.querySelectorAll<HTMLAnchorElement>('a[data-requiere-sesion]').forEach((enlace) => {
		enlace.addEventListener('click', async (evento) => {
			evento.preventDefault();
			const href = enlace.getAttribute('href') ?? '/';
			if (await haySesion()) location.assign(href);
			else abrirModal(href);
		});
	});

	// Página protegida: el contenido queda oculto hasta confirmar la sesión.
	if (paginaProtegida) {
		haySesion().then((activa) => {
			if (activa) contenido.hidden = false;
			else abrirModal(destino);
		});
	}
}
