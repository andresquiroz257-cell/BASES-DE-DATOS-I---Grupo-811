--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE CONSULTAS AVANZADAS (SELECT con JOIN)
--
-- Miembros del grupo
-- Andres Santiago Quiroz Gomez 
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa

--
-- CONSULTAS AVANZADAS
--

--
-- Consulta 1
--
-- Cantidad de pacientes por ciudad
SELECT  ciu.ciudad_id,
    ciu.nombre_ciudad,
    ciu.nombre_pais,
	COUNT(pac.id_paciente) as total_pacientes
FROM paciente pac
INNER JOIN ciudad_pais ciu ON pac.ciudad_id = ciu.ciudad_id
GROUP BY ciu.nombre_ciudad, ciu.nombre_pais, ciu.ciudad_id 
ORDER BY total_pacientes DESC;
--
-- Consulta 2
--
-- Listado de enfermeras y su hospital asignado
SELECT 
    enf.enfermera_id,
    enf.codigo_profesional,
    enf.nombre,
    enf.sexo,
    hos.nombre_hospital,
    enf.telefono
FROM enfermera enf
INNER JOIN hospital hos ON enf.hospital_id = hos.hospital_id
WHERE enf.estado = TRUE
ORDER BY hos.nombre_hospital ASC, enf.nombre ASC;
--
-- Consulta 3
--
-- Última fecha de registro de médicos por especialidad
SELECT 
    esp.nombre_especialidad,
    COUNT(med.medico_id) as total_medicos,
    MAX(med.medico_id) as ultimo_medico_registrado
FROM medico med
INNER JOIN especialidad esp ON med.especialidad_id = esp.especialidad_id
WHERE med.estado = TRUE
GROUP BY esp.nombre_especialidad
ORDER BY total_medicos DESC;
--
-- Consulta 4
--
-- Edad promedio de pacientes por EPS y ciudad
SELECT 
    eps.nombre_eps,
    ciu.nombre_ciudad,
    COUNT(pac.id_paciente) as total_pacientes,
    ROUND(AVG(EXTRACT(YEAR FROM AGE(CURRENT_DATE, pac.fecha_nacimiento))), 2) as edad_promedio
FROM paciente pac
INNER JOIN eps eps ON pac.eps_id = eps.eps_id
INNER JOIN ciudad_pais ciu ON pac.ciudad_id = ciu.ciudad_id
GROUP BY eps.nombre_eps, ciu.nombre_ciudad
ORDER BY eps.nombre_eps DESC, edad_promedio DESC;
--
-- Consulta 5
--
-- Listado de hospitalizaciones con médico tratante y paciente
SELECT 
    hos.hospitalizacion_id,
    hos.fecha_hora,
    hos.tipo,
    pac.nombre || ' ' || pac.primer_apellido || ' ' || pac.segundo_apellido as paciente,
    med.nombre as medico_tratante
FROM hospitalizaciones hos
INNER JOIN medico_paciente mp ON hos.medico_paciente_id = mp.medico_paciente_id
INNER JOIN paciente pac ON mp.paciente_id = pac.id_paciente
INNER JOIN medico med ON mp.medico_id = med.medico_id
WHERE hos.fecha_hora >= CURRENT_DATE - INTERVAL '80 days'
ORDER BY hos.fecha_hora DESC;
--
-- Consulta 6
--
-- Primera asignación de cuarto por hospital
SELECT 
    hos.nombre_hospital,
    pl.piso,
    COUNT(asg.asig_id) as total_asignaciones,
    MIN(asg.asig_id) as primera_asignacion
FROM asignacion asg
INNER JOIN cuarto cua ON asg.cuarto_id = cua.cuarto_id
INNER JOIN planta pl ON cua.planta_id = pl.planta_id
INNER JOIN hospital hos ON pl.hospital_id = hos.hospital_id
GROUP BY hos.nombre_hospital, pl.piso
ORDER BY hos.nombre_hospital ASC, pl.piso ASC;
--
-- Consulta 7
--
-- Diagnósticos aplicados con información completa
SELECT pac.id_paciente,
    pac.nombre || ' ' || pac.primer_apellido as paciente,
    dia.codigo_diag,
    dia.descripcion as diagnostico,
    med.nombre as medico_diagnosticador,
    dm.rol,
    dp.descripcion as notas_clinicas
FROM diagnostico_medico dm
INNER JOIN diagnostico_paciente dp ON dm.diag_paciente_id = dp.diag_paciente_id
INNER JOIN diagnostico dia ON dp.diag_id = dia.diag_id
INNER JOIN medico med ON dm.medico_id = med.medico_id
INNER JOIN hospitalizaciones hos ON dp.hospitalizacion_id = hos.hospitalizacion_id
INNER JOIN medico_paciente mp ON hos.medico_paciente_id = mp.medico_paciente_id
INNER JOIN paciente pac ON mp.paciente_id = pac.id_paciente
WHERE dm.rol = 'diagnosticador'
ORDER BY pac.primer_apellido ASC, dia.codigo_diag ASC;
--
-- Consulta 8
--
-- medicamentos por paciente
SELECT 
    pac.id_paciente,
    pac.nombre AS paciente,
    SUM(1) AS total_medicamentos
FROM paciente pac
JOIN tratamiento_paciente tpa ON pac.id_paciente = tpa.paciente_id
JOIN tratamiento_medicamento tme ON tpa.paciente_trat_id = tme.paciente_trat_id
JOIN medicamento med ON tme.medicina_id = med.medicina_id
GROUP BY pac.id_paciente, pac.nombre 
ORDER BY total_medicamentos DESC;
--
-- Consulta 9
-- Tratamientos completos con medicamentos aplicados
SELECT 
    pac.nombre || ' ' || pac.primer_apellido as paciente,
    tra.nombre_trat as tratamiento,
    tp.fecha_inicio,
    tp.fecha_fin,
    mdi.nombre_med as medicamento,
    tm.desc_dosis,
    dia.codigo_diag,
    dia.descripcion as diagnostico
FROM tratamiento_paciente tp
INNER JOIN paciente pac ON tp.paciente_id = pac.id_paciente
INNER JOIN tratamiento tra ON tp.trat_id = tra.trat_id
INNER JOIN tratamiento_medicamento tm ON tp.paciente_trat_id = tm.paciente_trat_id
INNER JOIN medicamento mdi ON tm.medicina_id = mdi.medicina_id
INNER JOIN diagnostico_medico dm ON tp.diag_medico = dm.diag_medico
INNER JOIN diagnostico_paciente dp ON dm.diag_paciente_id = dp.diag_paciente_id
INNER JOIN diagnostico dia ON dp.diag_id = dia.diag_id
WHERE tp.fecha_inicio >= CURRENT_DATE - INTERVAL '90 days'
ORDER BY tp.fecha_inicio DESC, pac.primer_apellido ASC;
--
-- Consulta 10
--
-- Reporte integral de hospitalización con paciente, médico, enfermera, hospital y diagnóstico
SELECT 
    hoz.hospitalizacion_id,
    hoz.fecha_hora,
    hoz.tipo,
    pac.nombre || ' ' || pac.primer_apellido as paciente,
    pac.sexo as sexo_paciente,
    EXTRACT(YEAR FROM AGE(CURRENT_DATE, pac.fecha_nacimiento)) as edad_paciente,
    m.nombre as medico_tratante,
    esp.nombre_especialidad,
    enf.nombre as enfermera_asignada,
    hosp.nombre_hospital,
    d.codigo_diag,
    d.descripcion as diagnostico_principal
FROM hospitalizaciones hoz
INNER JOIN medico_paciente mp ON hoz.medico_paciente_id = mp.medico_paciente_id
INNER JOIN paciente pac ON mp.paciente_id = pac.id_paciente
INNER JOIN medico m ON mp.medico_id = m.medico_id
INNER JOIN especialidad esp ON m.especialidad_id = esp.especialidad_id
LEFT JOIN enfermera_paciente ep ON pac.id_paciente = ep.paciente_id
LEFT JOIN enfermera enf ON ep.enfermera_id = enf.enfermera_id
LEFT JOIN hospital hosp ON pac.hospital_id = hosp.hospital_id
LEFT JOIN diagnostico_paciente dp ON hoz.hospitalizacion_id = dp.hospitalizacion_id
LEFT JOIN diagnostico d ON dp.diag_id = d.diag_id
WHERE hoz.fecha_hora >= CURRENT_DATE - INTERVAL '365 days'
ORDER BY hoz.fecha_hora DESC, pac.primer_apellido ASC;
