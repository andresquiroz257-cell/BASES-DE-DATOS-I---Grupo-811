--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CREACIÓN y CONSULTAS DE UNA VISTA 
--
-- Miembros del grupo
-- Andres Santiago Quiroz Gomez 
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa

--
-- SCRIPT CREACIÖN DE LA VISTA
--

CREATE OR REPLACE VIEW vista_hospitalizacion_completa AS
SELECT 
    -- Información de hospitalización
    h.hospitalizacion_id,
    h.fecha_hora as fecha_hospitalizacion,
    h.tipo as tipo_hospitalizacion,  
    -- Información del paciente
    p.id_paciente,
    p.nombre as nombre_paciente,
    p.primer_apellido,
    p.segundo_apellido,
    p.cedula,
    p.sexo as sexo_paciente,
    p.fecha_nacimiento,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, p.fecha_nacimiento)) as edad_paciente,
    p.email,
    p.tel1,
    -- Información de ciudad y país 
    c.nombre_ciudad,
    c.nombre_pais,    
    -- Información de EPS
    e.nombre_eps,
    e.codigo_eps,   
    -- Información del médico
    m.medico_id,
    m.codigo_profesional as codigo_medico,
    m.nombre as nombre_medico,
    m.sexo as sexo_medico,
    m.telefono as telefono_medico,    
    -- Información de especialidad
    esp.especialidad_id,
    esp.nombre_especialidad,    
    -- Información del hospital
    hosp.hospital_id,
    hosp.codigo_hospital,
    hosp.nombre_hospital,
    hosp.direccion as direccion_hospital,    
    -- Relación médico-paciente
    mp.medico_paciente_id,
    mp.rol as rol_medico

FROM hospitalizaciones h
INNER JOIN medico_paciente mp ON h.medico_paciente_id = mp.medico_paciente_id
INNER JOIN paciente p ON mp.paciente_id = p.id_paciente
INNER JOIN ciudad_pais c ON p.ciudad_id = c.ciudad_id
INNER JOIN eps e ON p.eps_id = e.eps_id
INNER JOIN medico m ON mp.medico_id = m.medico_id
INNER JOIN especialidad esp ON m.especialidad_id = esp.especialidad_id
LEFT JOIN hospital hosp ON p.hospital_id = hosp.hospital_id;



--
-- SCRIPT DE CONSULTAS UTILIZANDO LA VISTA
--
-- Ver estructura de la vista
SELECT column_name, data_type 
FROM information_schema.columns 
WHERE table_name = 'vista_hospitalizacion_completa'
ORDER BY ordinal_position;

-- Ver primeras 5 filas
SELECT * FROM vista_hospitalizacion_completa
order by edad_paciente desc;
--
-- Consulta 1
--
SELECT 
    tipo_hospitalizacion,
    nombre_especialidad,
    COUNT(*) as total_hospitalizaciones
FROM vista_hospitalizacion_completa
GROUP BY tipo_hospitalizacion, nombre_especialidad
ORDER BY  nombre_especialidad DESC;
--
-- Consulta 2
--
-- Fecha más reciente y más antigua de hospitalización por ciudad
SELECT  
    nombre_ciudad,
    COUNT(*) as total_hospitalizaciones,
    MAX(fecha_hospitalizacion) as ultima_hospitalizacion,
    MIN(fecha_hospitalizacion) as primera_hospitalizacion,
    MAX(fecha_hospitalizacion) - MIN(fecha_hospitalizacion) as rango_dias
FROM vista_hospitalizacion_completa
GROUP BY nombre_ciudad
ORDER BY total_hospitalizaciones DESC;
--
-- Consulta 3
--
-- Estadísticas de edad por EPS
SELECT 
    nombre_eps,
    codigo_eps,
    COUNT(DISTINCT id_paciente) as total_pacientes_unicos,
    COUNT(*) as total_hospitalizaciones,
    ROUND(AVG(edad_paciente), 2) as edad_promedio,
    MIN(edad_paciente) as edad_minima,
    MAX(edad_paciente) as edad_maxima,
    SUM(CASE WHEN edad_paciente >= 65 THEN 1 ELSE 0 END) as pacientes_tercera_edad
FROM vista_hospitalizacion_completa
GROUP BY nombre_eps, codigo_eps
ORDER BY total_hospitalizaciones DESC;
--
-- Consulta 4
--
-- Ranking de médicos con más hospitalizaciones por hospital
SELECT 
    nombre_hospital,
    nombre_medico,
     codigo_medico,
    nombre_especialidad,
    sexo_medico,
    COUNT(*) as total_hospitalizaciones_atendidas
FROM vista_hospitalizacion_completa
WHERE nombre_hospital IS NOT NULL
GROUP BY nombre_hospital, nombre_medico, codigo_medico, nombre_especialidad, sexo_medico
HAVING COUNT(*) >= 2
ORDER BY nombre_hospital ASC, total_hospitalizaciones_atendidas DESC;
--
-- Consulta 5
--
-- Análisis demográfico de hospitalizaciones
SELECT 
    CASE 
        WHEN edad_paciente BETWEEN 0 AND 10 THEN '0-10 años'
        WHEN edad_paciente BETWEEN 11 AND 20 THEN '11-20 años'
        WHEN edad_paciente BETWEEN 21 AND 40 THEN '21-40 años'
        WHEN edad_paciente BETWEEN 41 AND 60 THEN '41-60 años'
        ELSE '61+ años'
    END AS rango_edad, 
    tipo_hospitalizacion,
    COUNT(*) as total_casos,
    COUNT(DISTINCT id_paciente) as pacientes_diferentes,
    ROUND(AVG(edad_paciente), 1) as edad_promedio_grupo
FROM vista_hospitalizacion_completa
GROUP BY 
    CASE 
        WHEN edad_paciente BETWEEN 0 AND 10 THEN '0-10 años'
        WHEN edad_paciente BETWEEN 11 AND 20 THEN '11-20 años'
        WHEN edad_paciente BETWEEN 21 AND 40 THEN '21-40 años'
        WHEN edad_paciente BETWEEN 41 AND 60 THEN '41-60 años'
        ELSE '61+ años'
    END,      
    tipo_hospitalizacion
ORDER BY rango_edad ASC,  tipo_hospitalizacion DESC;

 