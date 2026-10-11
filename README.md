# ApunteUNLu

Plataforma para subir y compartir **apuntes**, **parciales viejos** y **finales** de la Licenciatura en Sistemas de la Universidad Nacional de Luján (UNLu).

Proyecto desarrollado por el **CODES** (Centro Organizado de Estudiantes de Sistemas · UNLu).

## 📌 Alcance

- De momento solo cubre la **Licenciatura en Sistemas**.
- El material se organiza por materia.
- Tipos de material: apuntes, parciales resueltos o tomados y finales.

## 🛠️ Tecnologías

| Tecnología | Para qué se usa | Dónde está |
| :--- | :--- | :--- |
| [Astro](https://astro.build) 7 | Framework del sitio. Genera páginas estáticas en `dist/`. | `src/pages/`, `src/layouts/` |
| [Tailwind CSS](https://tailwindcss.com) 4 (vía `@tailwindcss/vite`) | Estilos con clases utilitarias. La paleta y las fuentes se definen como tokens en `@theme`. | `src/styles/global.css` |
| [Literata](https://fonts.google.com/specimen/Literata) y [Public Sans](https://fonts.google.com/specimen/Public+Sans) | Tipografía de títulos (serif) y de texto (sans), desde Google Fonts. | `src/layouts/Layout.astro` |
| [Supabase](https://supabase.com) (`@supabase/supabase-js`) | Autenticación de usuarios con Google. | `src/lib/supabase.ts`, `src/lib/sesion.ts` |
| [pnpm](https://pnpm.io) | Gestor de paquetes. El lockfile es `pnpm-lock.yaml`. | `pnpm-lock.yaml` |

Requisitos: **Node.js 22.12 o superior** y pnpm.

## 🔐 Inicio de sesión

Ver el material y subir apuntes requiere iniciar sesión **con Google** (no hay otros proveedores). Antes de entrar a esas secciones se abre un modal de inicio de sesión.

Para configurarlo:

1. Copiar `.env.example` a `.env` y completar `PUBLIC_SUPABASE_URL` y `PUBLIC_SUPABASE_ANON_KEY` (Project Settings > API en Supabase).
2. En Supabase, habilitar sólo el proveedor **Google** (Authentication > Sign In / Providers). Deshabilitar el resto.
3. En Authentication > URL Configuration, agregar a *Redirect URLs* la URL local (`http://localhost:4321/**`) y la de producción.
4. En GitHub, cargar los secretos `PUBLIC_SUPABASE_URL` y `PUBLIC_SUPABASE_ANON_KEY` para el deploy.

## 🧞 Comandos

Se ejecutan desde la raíz del proyecto:

| Comando                | Acción                                               |
| :--------------------- | :--------------------------------------------------- |
| `pnpm install`         | Instala las dependencias                             |
| `pnpm dev`             | Inicia el servidor de desarrollo en `localhost:4321` |
| `pnpm build`           | Genera el sitio de producción en `./dist/`           |
| `pnpm preview`         | Previsualiza el build antes de desplegar             |
| `pnpm check:agentes`   | Verifica que `AGENTS.md` y `CLAUDE.md` sean idénticos |
| `pnpm astro ...`       | Ejecuta comandos de la CLI de Astro                  |

## 🤖 Agentes de IA

El repo tiene dos archivos con las reglas para agentes, y **deben tener exactamente el mismo contenido**:

- `CLAUDE.md`: lo lee Claude Code.
- `AGENTS.md`: lo leen el resto de las herramientas de IA.

Para que no se desincronicen:

- `pnpm check:agentes` (`scripts/check-agentes.mjs`) compara ambos archivos.
- Corre automáticamente antes de `pnpm build` (en el script `prebuild`), así que el build falla si difieren.
- Para cambiar una regla, editá `CLAUDE.md` y copiá el archivo sobre `AGENTS.md`.

Las reglas principales son:

- Usar siempre **pnpm**. Nunca `npm`, `npx` ni `yarn`.
- Los commits siguen **Conventional Commits en español**, por ejemplo `feat(inicio): agregar la página de inicio`.
- El servidor de desarrollo se inicia en segundo plano con `pnpm exec astro dev --background`.

## 📁 Estructura

```text
/
├── public/                 # Archivos estáticos (favicon)
├── scripts/
│   └── check-agentes.mjs   # Verifica que AGENTS.md y CLAUDE.md sean iguales
├── src/
│   ├── components/         # Piezas reutilizables: Header, Footer, Boton
│   ├── layouts/            # Layout.astro: estructura común de las páginas
│   ├── pages/              # Rutas: cada archivo es una página (index.astro)
│   └── styles/             # global.css: fuentes y paleta de colores
├── AGENTS.md               # Reglas para agentes de IA
├── CLAUDE.md               # Reglas para Claude Code
├── astro.config.mjs
└── package.json
```

## 🤝 Contribuir

- Los commits siguen [Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/) en español (ver `CLAUDE.md`).
- Usar siempre `pnpm`; no se versiona `package-lock.json` ni `yarn.lock`.

## 📄 Licencia

Este proyecto está bajo la [Licencia MIT](LICENSE). Copyright © 2026 CODES (Centro Organizado de Estudiantes de Sistemas · UNLu).
