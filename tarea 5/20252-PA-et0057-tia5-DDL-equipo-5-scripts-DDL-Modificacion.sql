--
-- Tarea 5 - Parte #1 del Proyecto de Aula
-- SCRIPTS DE MODIFICACIÓN DE LA BASE DE DATOS
--
-- Miembros del grupo
-- Andres Santiago Quiroz Gomez
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa
--
-- INSTRUCCIONES DE MODIFICACIÓN SOLICITADAS
--
--
-- 5.1.- Agregar al menos 5 índices diferentes que considere importantes en 5 tablas diferentes. 
--
-- indice en medico_especialidad
CREATE INDEX idx_medico_especialidad_medico ON medico_especialidad(medico_id);

-- indice en medico_paciente
CREATE INDEX idx_medico_paciente_paciente ON medico_paciente(paciente_id);

-- indice para búsquedas por cedula de paciente 
CREATE INDEX idx_paciente_cedula ON paciente(cedula);

-- indice para filtrar visitas por rangos de fechas
CREATE INDEX idx_visita_fecha_hora ON visita(fecha_hora);

-- indice compuesto para buscar cuartos por hospital
CREATE INDEX idx_cuarto_hospital ON cuarto(planta_id, numero_cuarto);

--
-- 5.2.- Agregar 5 campos nuevos en 5 tablas diferentes de su preferencia. 
-- 
-- Agregar email a la tabla paciente
ALTER TABLE paciente
ADD COLUMN email VARCHAR(100) UNIQUE NOT NULL;

-- Agregar fecha de emisión a la tabla tarjeta_visita
ALTER TABLE tarjeta_visita
ADD COLUMN fecha_emision DATE DEFAULT CURRENT_DATE;

--Agregar observaciones a la tabla visita
ALTER TABLE visita
ADD COLUMN observaciones TEXT;

-- Agregar dirección a la tabla hospital
ALTER TABLE hospital
ADD COLUMN direccion VARCHAR(250);

-- Agregar estado (activo/inactivo) a la tabla medico
ALTER TABLE medico
ADD COLUMN estado BOOLEAN DEFAULT TRUE;


--
-- 5.3.- Agregar 5 “CHECK” diferentes en 5 tablas diferentes  de su preferencia. 
--
-- Validar fecha de nacimiento no futura
ALTER TABLE paciente
ADD CONSTRAINT check_fecha_nacimie CHECK (fecha_nacimiento <= current_date);

-- evitar fechas futuras
ALTER TABLE atencion
ADD CONSTRAINT check_fchahora CHECK (fecha_hora <= CURRENT_TIMESTAMP);

-- evitar que el campo quede vacio
ALTER TABLE diagnostico
ADD CONSTRAINT check_cod_no_vacio CHECK (TRIM(codigo_diag) <> '');

-- Validar rol del medico diagnosticador
ALTER TABLE diagnostico_medico
ADD CONSTRAINT check_rolmed_atencion CHECK (rol IN ('diagnosticador', 'confirmador', 'consultor', 'revisor'));

-- evitar que la fecha_fin sea anterior a la fecha_inicio
ALTER TABLE tratamiento_paciente
ADD CONSTRAINT check_fechas_tratamiento CHECK (fecha_fin IS NULL OR fecha_fin >= fecha_inicio);
--
-- 5.4. Modificar los nombres de 5 campos diferentes en 5 tablas diferentes. 
--
ALTER TABLE visitante
RENAME COLUMN nombre TO nombre_completo;

ALTER TABLE medico
RENAME COLUMN codigo TO codigo_profesional;

ALTER TABLE asignacion 
RENAME COLUMN motivo TO motivo_asignacion;

ALTER TABLE planta
RENAME COLUMN numero_planta TO piso;

ALTER TABLE ciudad_pais
RENAME COLUMN pais TO nombre_pais;
