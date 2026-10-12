# Planes de estudio y equivalencias

Guía para quien mantenga o consulte los planes de la Licenciatura en Sistemas y sus equivalencias. Los datos no se copian acá: este documento dice dónde están y cómo se leen.

## Dónde está cada cosa

| Qué | Dónde | Notas |
| :--- | :--- | :--- |
| Planes y materias | `src/data/sistemas.json` | Fuente de verdad de la app. Un array con los planes `17.13` (anterior) y `17.14` (vigente). |
| Equivalencias | `src/data/equivalencias.json` | Mapeo del plan 17.14 hacia el 17.13. Ver las reglas abajo. |
| Optativas | `src/data/optativasData.json` | Oferta complementaria. No pertenece a un plan. |
| Estructura de cada JSON | `src/data/README.md` | Campos, tipos y ejemplos. |
| Esquema en la base | `supabase/migrations/20261012130000_carreras_planes_materias.sql` | Tablas `carreras`, `planes_estudio`, `materias`, `planes_materias` y `materias_equivalentes`. |

Las fuentes oficiales son las páginas de la UNLu: [plan 17.14](https://www.unlu.edu.ar/carg-sistemas.html) y [plan 17.13](https://www.unlu.edu.ar/carg-sistemas-1713.html). Si el JSON y la web difieren, manda la web y hay que corregir el JSON.

## Reglas de las equivalencias

- La **clave** es un código del plan **17.14** (lo que el estudiante cursa hoy).
- Los **valores** son códigos del plan **17.13** (lo que ya aprobó en el plan anterior).
- Si una clave tiene varios valores, **todos se requieren juntos** (ej.: 13021 requiere 11072 y 11073).
- Si una materia del 17.14 no tiene entrada, se busca el mismo código en el 17.13.
- Si no se encuentra en ningún lado, se muestra como "Sin origen (Materia nueva pura)".

Esta relación es **direccional**: no implica que las dos materias sean intercambiables en ambos sentidos.

## Códigos internos

Algunas entradas no tienen código oficial en la web. Usan códigos internos, con `mostrarCodigo: false` cuando no deben verse en la interfaz:

- Plan 17.13: `OP1`, `OP2`, `OP3` (optativas I, II y III).
- Plan 17.14: `PSTC-1714` (Prácticas Socio-Técnico-Culturales), `AO-1714` (Actividades Optativas), `TES-1714` (Tesina de Grado).

La base de datos debe usar estos mismos códigos, para que coincidan con la app.

## Entradas rotas en `equivalencias.json`

Estas cuatro entradas apuntan a códigos que no existen en el plan correspondiente. **No se cargan en Supabase** (la migración `20261012140000_planes_licenciatura_sistemas.sql` las omite). Hay que corregirlas en el JSON y después actualizar la migración; no conviene adivinar a qué materia apuntaban:

- Clave `11419` (no existe en el 17.14). Valores: `11412`, `11417`.
- Clave `21279` con origen `21240` (no existe en el 17.13).
- Clave `14034` con origen `11408` (no existe en el 17.13).
- Clave `11289` con origen `10043` (no existe en el 17.13).

La app las ignora según la regla de `src/data/README.md`: si la clave no existe en el 17.14, la equivalencia no aparece.

## Créditos

El relevamiento de las equivalencias entre los planes 17.13 y 17.14 lo hizo [Pri](https://github.com/PrisRedondo29). Ver también la sección de créditos del README principal.
