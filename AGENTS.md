## Proyecto

ApunteUNLu es una web para subir y compartir **apuntes**, **parciales viejos** y **finales** de la Licenciatura en Sistemas de la UNLu (Universidad Nacional de Luján).

- Lo desarrolla el **CODES** (Centro Organizado de Estudiantes de Sistemas · UNLu).
- De momento solo cubre la **Licenciatura en Sistemas**; el material se organiza por materia.
- La interfaz y los textos visibles para el usuario van en **español**.

Stack: Astro 7, Tailwind CSS 4 (vía `@tailwindcss/vite`) y pnpm. Más detalles en `README.md`.

## Reglas para agentes

Estas reglas aplican siempre, sin excepción, a cualquier agente que trabaje en este repositorio.

### Gestor de paquetes: pnpm

- Usar **siempre `pnpm`** para instalar dependencias, ejecutar scripts y gestionar paquetes.
- **Nunca usar `npm`, `npx`, `yarn`, `node` ni otras herramientas de Node.js por defecto.** Si una herramienta necesita ejecutarse, usar `pnpm exec <bin>` (binarios locales) o `pnpm dlx <paquete>` (ejecución puntual).
- No crear ni modificar `package-lock.json`, `yarn.lock` ni similares; el lockfile del proyecto es `pnpm-lock.yaml`.

### Commits: Conventional Commits en español

- Todos los commits siguen la especificación [Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/): `tipo(ámbito opcional): descripción`.
- La **descripción, el cuerpo y el pie** del commit se escriben **en español**.
- Tipos permitidos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.
- La descripción va en modo imperativo, en minúsculas y sin punto final. Ejemplo: `feat(ui): agregar integración de Tailwind CSS`.
- Los cambios incompatibles se marcan con `!` después del tipo o con un pie `BREAKING CHANGE:`.

## Desarrollo

Iniciar el servidor de desarrollo en segundo plano:

```
pnpm exec astro dev --background
```

Gestionar el servidor en segundo plano con `pnpm exec astro dev stop`, `pnpm exec astro dev status` y `pnpm exec astro dev logs`.

## Documentation

Full documentation: https://docs.astro.build

Consult these guides before working on related tasks:

- [Adding pages, dynamic routes, or middleware](https://docs.astro.build/en/guides/routing/)
- [Working with Astro components](https://docs.astro.build/en/basics/astro-components/)
- [Using React, Vue, Svelte, or other framework components](https://docs.astro.build/en/guides/framework-components/)
- [Adding or managing content](https://docs.astro.build/en/guides/content-collections/)
- [Adding styles or using Tailwind](https://docs.astro.build/en/guides/styling/)
- [Supporting multiple languages](https://docs.astro.build/en/guides/internationalization/)
