# ApunteUNLu

Plataforma para subir y compartir **apuntes**, **parciales viejos** y **finales** de la Licenciatura en Sistemas de la Universidad Nacional de Luján (UNLu).

Proyecto desarrollado por el **CODES** (Centro Organizado de Estudiantes de Sistemas · UNLu).

## 📌 Alcance

- De momento solo cubre la **Licenciatura en Sistemas**.
- El material se organiza por materia.
- Tipos de material: apuntes, parciales resueltos o tomados y finales.

## 🛠️ Stack

- [Astro](https://astro.build) 7
- [Tailwind CSS](https://tailwindcss.com) 4 (vía `@tailwindcss/vite`)
- [pnpm](https://pnpm.io) como gestor de paquetes

## 🧞 Comandos

Se ejecutan desde la raíz del proyecto:

| Comando                | Acción                                           |
| :--------------------- | :----------------------------------------------- |
| `pnpm install`         | Instala las dependencias                         |
| `pnpm dev`             | Inicia el servidor de desarrollo en `localhost:4321` |
| `pnpm build`           | Genera el sitio de producción en `./dist/`       |
| `pnpm preview`         | Previsualiza el build antes de desplegar         |
| `pnpm astro ...`       | Ejecuta comandos de la CLI de Astro              |

## 📁 Estructura

```text
/
├── public/          # Archivos estáticos (favicon, imágenes)
├── src/
│   ├── pages/       # Rutas: cada archivo es una página
│   │   └── index.astro
│   └── styles/      # Estilos globales (Tailwind)
├── AGENTS.md        # Reglas para agentes de IA
├── CLAUDE.md        # Reglas para Claude Code
└── package.json
```

## 🤝 Contribuir

- Los commits siguen [Conventional Commits](https://www.conventionalcommits.org/es/v1.0.0/) en español (ver `CLAUDE.md`).
- Usar siempre `pnpm`; no se versiona `package-lock.json` ni `yarn.lock`.
