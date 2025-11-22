--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CONSULTAS BÁSICAS (SELECT sin JOIN)
--
-- Miembros del grupo
-- Andres Santiago Quiroz Gomez 
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa

--
-- CONSULTAS BÁSICAS
--

--
-- Consulta 1
--
--Total de pacientes por sexo
SELECT sexo,
	COUNT(*) as total_pacientes
FROM paciente
GROUP BY sexo 
ORDER BY sexo ASC;
--
-- Consulta 2
--
-- Última hospitalización por tipo
SELECT tipo,
	MAX(fecha_hora) as fecha_mas_reciente,
	COUNT(*) as total_hospitalizaciones
FROM hospitalizaciones
GROUP BY tipo 
ORDER BY fecha_mas_reciente DESC;
	
--
-- Consulta 3
--
-- Paciente más antiguo por ciudad
SELECT 
    ciudad_id,
    MIN(fecha_nacimiento) as paciente_mas_viejo,
    COUNT(*) as total_pacientes
FROM paciente
GROUP BY ciudad_id
ORDER BY paciente_mas_viejo ASC;
--
-- Consulta 4
--
---- Edad promedio de pacientes por EPS
SELECT 
    eps_id,
    AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, fecha_nacimiento))) as edad_promedio,
    COUNT(*) as total_pacientes
FROM paciente
GROUP BY eps_id
ORDER BY edad_promedio DESC;
--
-- Consulta 5
--
-- Total de tarjetas disponibles vs utilizadas
SELECT 
    estado,
    COUNT(*) as cantidad_tarjetas,
    SUM(numero_tarj) as suma_numeros_tarjeta
FROM tarjeta_visita
GROUP BY estado
ORDER BY cantidad_tarjetas DESC;
--
-- Consulta 6
--
-- Médicos por estado (activo/inactivo)
SELECT 
    medico_id,
    codigo_profesional,
    nombre,
    sexo,
    estado,
    telefono
FROM medico
WHERE estado = TRUE 
ORDER BY nombre ASC;
--
-- Consulta 7
--
-- Hospitalizaciones del último mes
SELECT 
    hospitalizacion_id,
    medico_paciente_id,
    fecha_hora,
    tipo
FROM hospitalizaciones
WHERE fecha_hora >= CURRENT_DATE - INTERVAL '30 days'
ORDER BY fecha_hora DESC;
--
-- Consulta 8
--
-- Enfermeras distribuidas por hospital
SELECT 
    hospital_id,
    sexo,
    COUNT(*) as total_enfermeras
FROM enfermera
WHERE estado = TRUE
GROUP BY hospital_id, sexo
ORDER BY hospital_id ASC, sexo ASC;
--
-- Consulta 9
--
-- Pacientes que tienen hospital asignado
SELECT 
	hospital_id,
    id_paciente,
    nombre,
    primer_apellido,
    segundo_apellido,
    cedula,
    fecha_nacimiento
FROM paciente
WHERE hospital_id = '1'
ORDER BY fecha_nacimiento DESC;
--
-- Consulta 10
--
-- Visitantes sin información de contacto
SELECT 
    paciente_id,
    numero_visitante,
    nombre_completo,
	telefono
FROM visitante
WHERE telefono IS NULL
ORDER BY paciente_id ASC, numero_visitante ASC;
