-- Planes vigentes de la Licenciatura en Sistemas de la UNLu: 17.14 (vigente) y 17.13 (anterior).
-- Datos generados desde src/data/sistemas.json, optativasData.json y equivalencias.json.
--  - Cuatrimestre absoluto de 1 a 11 (11 = final de carrera: tesina, prácticas y optativas).
--  - Equivalencias direccionales: materia_destino_id es del 17.14 y materia_origen_id del 17.13.
--    Todas las origenes de un mismo destino se requieren juntas.
--  - Entradas de equivalencias.json con códigos inexistentes: se omiten (ver docs/planes-y-equivalencias.md).
--  - Las optativas del catálogo se cargan como materias sin plan.

alter table public.planes_materias
  add column cuatrimestre smallint,
  add constraint planes_materias_cuatrimestre_valido check (cuatrimestre between 1 and 11);

comment on column public.planes_materias.cuatrimestre is 'Cuatrimestre de la materia en ese plan (1 a 11). 11 = final de carrera.';

-- Equivalencias pasan de pares simétricos a direccionales.
drop index public.materias_equivalentes_par_key;

alter table public.materias_equivalentes rename column materia_id to materia_destino_id;
alter table public.materias_equivalentes rename column equivalente_id to materia_origen_id;
alter table public.materias_equivalentes add primary key (materia_destino_id, materia_origen_id);

create index materias_equivalentes_origen_id_idx on public.materias_equivalentes (materia_origen_id);

comment on table public.materias_equivalentes is 'Equivalencias del plan 17.14 hacia el 17.13: la materia destino (17.14) requiere todas las origen (17.13).';


insert into public.carreras (nombre)
values ('Licenciatura en Sistemas');

insert into public.planes_estudio (carrera_id, identificador, nombre)
select c.id, p.identificador, p.nombre
from public.carreras as c
cross join (values
  ('17.14', 'Plan 17.14 (vigente)'),
  ('17.13', 'Plan 17.13 (anterior)')
) as p (identificador, nombre)
where c.nombre = 'Licenciatura en Sistemas';

insert into public.materias (identificador, nombre) values
  ('19054', 'Competencias Básicas en Informática'),
  ('39553', 'Competencias Básicas en Idioma Inglés'),
  ('14026', 'Taller Introductorio de Interpretación de Problemas'),
  ('11271', 'Introducción a la Programación'),
  ('13014', 'Matemática Básica'),
  ('21256', 'Introducción a los Sistemas de Información'),
  ('11256', 'Sistemas de Información 1'),
  ('11274', 'Programación Estructurada'),
  ('41407', 'Organización de Computadoras'),
  ('13021', 'Algebra Lineal y Geometría'),
  ('11275', 'Estructuras de Datos y Algoritmos I'),
  ('11258', 'Sistemas de Información II'),
  ('13022', 'Análisis Matemático I'),
  ('41426', 'Arquitectura de Computadoras'),
  ('11276', 'Programación Orientada a Objetos'),
  ('13923', 'Análisis Matemático II'),
  ('11259', 'Sistemas de Información III'),
  ('11410', 'Sistemas Operativos'),
  ('11083', 'Estadística y Probabilidad'),
  ('14027', 'Fundamentos de Redes de Datos'),
  ('11286', 'Programación en Ambiente Web'),
  ('11277', 'Bases de Datos Relacionales'),
  ('21279', 'Gestión de Soluciones Innovadoras'),
  ('11287', 'Seminario de Integración Profesional'),
  ('11278', 'Bases de Datos Distribuidas'),
  ('14028', 'Matemática Computacional'),
  ('14029', 'Administración de Redes'),
  ('14030', 'Estructuras de Datos y Algoritmos II'),
  ('14031', 'Teoría de la Computación'),
  ('11260', 'Sistemas de Información IV'),
  ('11288', 'Gestión de Datos Masivos'),
  ('14032', 'Diseño Avanzado de Software'),
  ('41429', 'Sistemas Distribuidos y Programación Paralela'),
  ('14034', 'Modelos de decisión y optimización'),
  ('11292', 'Seguridad Informática'),
  ('11289', 'Inteligencia Artificial'),
  ('14033', 'Bases de Datos Textuales'),
  ('21258', 'Gestión de Proyectos'),
  ('21257', 'Aspectos Profesionales y Sociales'),
  ('11091', 'Taller de Tesina'),
  ('PSTC-1714', 'Prácticas Socio-Técnico-Culturales'),
  ('AO-1714', 'Actividades Optativas'),
  ('TES-1714', 'Tesina de Grado'),
  ('11071', 'Introducción a la Programación'),
  ('11072', 'Álgebra y Lógica Computacional'),
  ('21056', 'Introducción a los Sistemas de Información'),
  ('11073', 'Matemática Discreta'),
  ('11074', 'Programación I'),
  ('41406', 'Arquitectura de Computadoras'),
  ('31971', 'Inglés I'),
  ('11081', 'Análisis Matemático I'),
  ('11075', 'Programación II'),
  ('11056', 'Sistemas de Información I'),
  ('31972', 'Inglés II'),
  ('11082', 'Análisis Matemático II'),
  ('11076', 'Programación Orientada a Objetos'),
  ('11077', 'Base de Datos I'),
  ('11058', 'Sistemas de Información II'),
  ('10040', 'Teleinformática y Redes'),
  ('11079', 'Programación Funcional y Lógica'),
  ('11059', 'Sistemas de Información III'),
  ('11078', 'Base de Datos II'),
  ('21057', 'Aspectos Profesionales y Sociales'),
  ('11085', 'Administración y Gestión de Redes'),
  ('41408', 'Modelos, Simulación y Teoría de la Decisión'),
  ('41409', 'Sistemas Distribuidos y Programación Paralela'),
  ('11086', 'Programación en Ambiente Web'),
  ('11087', 'Seminario de Integración Profesional'),
  ('11412', 'Teoría de la Computación I'),
  ('11088', 'Base de Datos Masivas (Gestión y Análisis)'),
  ('OP1', 'Optativa I'),
  ('11060', 'Sistemas de Información IV'),
  ('11089', 'Sistemas Inteligentes'),
  ('OP2', 'Optativa II'),
  ('11092', 'Seguridad de la Información'),
  ('11090', 'Recuperación de Información'),
  ('11417', 'Teoría de la Computación II'),
  ('21058', 'Gestión de Proyectos'),
  ('OP3', 'Optativa III'),
  ('41410', 'Calidad de los Sistemas de Información'),
  ('11095', 'Tesina de Grado'),
  ('11804', 'Procesamiento de Imágenes'),
  ('11806', 'Programación Científica'),
  ('11807', 'Análisis y Minería de Grafos y Redes'),
  ('11808', 'Artefactor Digitales Interactivos'),
  ('11809', 'Compiladores'),
  ('11949', 'Taller de Bioinformática'),
  ('20395', 'Sistemas de Información Geográfica');

insert into public.planes_materias (plan_id, materia_id, cuatrimestre)
select p.id, m.id, v.cuatrimestre
from (values
  ('17.14', '19054', 1),
  ('17.14', '39553', 1),
  ('17.14', '14026', 1),
  ('17.14', '11271', 1),
  ('17.14', '13014', 1),
  ('17.14', '21256', 1),
  ('17.14', '11256', 2),
  ('17.14', '11274', 2),
  ('17.14', '41407', 2),
  ('17.14', '13021', 2),
  ('17.14', '11275', 3),
  ('17.14', '11258', 3),
  ('17.14', '13022', 3),
  ('17.14', '41426', 3),
  ('17.14', '11276', 4),
  ('17.14', '13923', 4),
  ('17.14', '11259', 4),
  ('17.14', '11410', 4),
  ('17.14', '11083', 5),
  ('17.14', '14027', 5),
  ('17.14', '11286', 5),
  ('17.14', '11277', 5),
  ('17.14', '21279', 6),
  ('17.14', '11287', 6),
  ('17.14', '11278', 6),
  ('17.14', '14028', 6),
  ('17.14', '14029', 7),
  ('17.14', '14030', 7),
  ('17.14', '14031', 7),
  ('17.14', '11260', 7),
  ('17.14', '11288', 8),
  ('17.14', '14032', 8),
  ('17.14', '41429', 8),
  ('17.14', '14034', 8),
  ('17.14', '11292', 9),
  ('17.14', '11289', 9),
  ('17.14', '14033', 9),
  ('17.14', '21258', 10),
  ('17.14', '21257', 10),
  ('17.14', '11091', 10),
  ('17.14', 'PSTC-1714', 11),
  ('17.14', 'AO-1714', 11),
  ('17.14', 'TES-1714', 11),
  ('17.13', '11071', 1),
  ('17.13', '11072', 1),
  ('17.13', '21056', 1),
  ('17.13', '41407', 1),
  ('17.13', '11073', 2),
  ('17.13', '11074', 2),
  ('17.13', '41406', 2),
  ('17.13', '31971', 2),
  ('17.13', '11081', 3),
  ('17.13', '11075', 3),
  ('17.13', '11056', 3),
  ('17.13', '31972', 3),
  ('17.13', '11082', 4),
  ('17.13', '11410', 4),
  ('17.13', '11076', 4),
  ('17.13', '11077', 4),
  ('17.13', '11058', 5),
  ('17.13', '10040', 5),
  ('17.13', '11083', 5),
  ('17.13', '11079', 5),
  ('17.13', '11059', 6),
  ('17.13', '11078', 6),
  ('17.13', '21057', 6),
  ('17.13', '11085', 6),
  ('17.13', '41408', 7),
  ('17.13', '41409', 7),
  ('17.13', '11086', 7),
  ('17.13', '11087', 7),
  ('17.13', '11412', 8),
  ('17.13', '11088', 8),
  ('17.13', 'OP1', 8),
  ('17.13', '11060', 8),
  ('17.13', '11089', 9),
  ('17.13', 'OP2', 9),
  ('17.13', '11092', 9),
  ('17.13', '11090', 9),
  ('17.13', '11091', 9),
  ('17.13', '11417', 10),
  ('17.13', '21058', 10),
  ('17.13', 'OP3', 10),
  ('17.13', '41410', 10),
  ('17.13', '11095', 11)
) as v (plan, codigo, cuatrimestre)
join public.planes_estudio as p on p.identificador = v.plan
join public.materias as m on m.identificador = v.codigo;

insert into public.materias_equivalentes (materia_destino_id, materia_origen_id)
select d.id, o.id
from (values
  ('11256', '11056'),
  ('11258', '11058'),
  ('11259', '11059'),
  ('11260', '11060'),
  ('11271', '11071'),
  ('11274', '11074'),
  ('11275', '11075'),
  ('11276', '11076'),
  ('11277', '11077'),
  ('11278', '11078'),
  ('11286', '11086'),
  ('11287', '11087'),
  ('11288', '11088'),
  ('11292', '11092'),
  ('13014', '11072'),
  ('13021', '11072'),
  ('13021', '11073'),
  ('13022', '11081'),
  ('13923', '11082'),
  ('14026', '11072'),
  ('14027', '10040'),
  ('14028', '11072'),
  ('14028', '11073'),
  ('14029', '11085'),
  ('14030', '11075'),
  ('14033', '11090'),
  ('19054', '11074'),
  ('21256', '21056'),
  ('21257', '21057'),
  ('21258', '21058'),
  ('39553', '31972'),
  ('41426', '41406'),
  ('41429', '41409'),
  ('AO-1714', 'OP1'),
  ('AO-1714', 'OP2'),
  ('AO-1714', 'OP3'),
  ('TES-1714', '11095')
) as v (destino, origen)
join public.materias as d on d.identificador = v.destino
join public.materias as o on o.identificador = v.origen;
