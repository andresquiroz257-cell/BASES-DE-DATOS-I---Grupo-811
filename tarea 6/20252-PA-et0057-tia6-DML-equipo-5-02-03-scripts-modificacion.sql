--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE MODIFICACIÓN DE LA BASE DE DATOS (UPDATE, DELETES)
--
-- Miembros del grupo
-- Andres Santiago Quiroz Gomez 
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa

--
-- INSTRUCCIONES DE MODIFICACIÓN SOLICITADAS
--
--
-- Instrucciones UPDATE 
--
update paciente
set tel1 = '3194034458'
where id_paciente = 5;
--el paciente cambio de operador y cambió su línea telefónica. Es necesario actualizar su número de contacto

update paciente 
set email = 'levyatto@gmail.com'
where id_paciente = 10
--El paciente reportó que el email registrado era de su antiguo trabajo.Solicitó actualizar a su email personal

UPDATE paciente
SET ciudad_id = (SELECT ciudad_id FROM ciudad_pais WHERE nombre_ciudad = 'Envigado')
WHERE id_paciente = 23;
--La paciente se mudó de Medellín a Envigado por motivos laborales.

UPDATE paciente
SET eps_id = (SELECT eps_id FROM eps WHERE nombre_eps = 'Sura')
WHERE id_paciente = 35
--El paciente cambió de empleador y su nueva empresa tiene convenio con otra EPS. 

UPDATE paciente
SET hospital_id = (SELECT hospital_id FROM hospital WHERE nombre_hospital = 'Hospital Pablo Tobón Uribe')
WHERE id_paciente = 60;
--La solicitó ser atendida en el Hospital Pablo Tobón Uribe porque su médico especialista trabaja allí.
----
----medicos
UPDATE medico
SET telefono = '3201234567'
WHERE medico_id = 3;
--El Doctor cambió su número de contacto profesional. 

UPDATE medico
SET especialidad_id = (SELECT especialidad_id FROM especialidad WHERE nombre_especialidad = 'Cardiología')
WHERE medico_id = 8;
--La doctora  completó su especialización en Cardiología después de 4 años de estudios adicionales. 

UPDATE medico
SET estado = FALSE
WHERE medico_id = 15;
--el doctor solicitó una licencia de maternidad/paternidad por 3 meses. Se desactiva temporalmente 

UPDATE medico
SET codigo_profesional = 'MED2024-9999'
WHERE medico_id = 22;
-- el doctor renovó su tarjeta profesional médica con un nuevo número de registro

UPDATE medico
SET sexo = 'F'
WHERE medico_id = 29;
--Se detectó que en el registro inicial del doctor se ingresó el sexo como 'M' por error de digitación.Se corrige este dato 
---
----especialidades
UPDATE especialidad
SET nombre_especialidad = 'Otorrinolaringología'
WHERE especialidad_id = 7 AND nombre_especialidad = 'Oftalmología';
--Se detectó que la especialidad registrada como "Oftalmología" debía ser "Otorrinolaringología" (oído, nariz y garganta).

UPDATE especialidad
SET nombre_especialidad = 'Medicina Interna'
WHERE especialidad_id = 2 AND nombre_especialidad = 'Pediatría';
--El MinSalud actualizó la nomenclatura oficial de las especialidades médicas. Se debe cambiar de "Pediatría" a "Medicina Interna - Pediatría"

UPDATE especialidad
SET nombre_especialidad = 'Cardiología Intervencionista'
WHERE especialidad_id = 1 AND nombre_especialidad = 'Cardiología';
--Se identificó que existían dos registros de "Cardiología" en el sistema. Para diferenciarlos, se actualiza uno de ellos a "Cardiología Intervencionista"

UPDATE especialidad
SET nombre_especialidad = 'Ginecología y Obstetricia'
WHERE especialidad_id = 4 AND nombre_especialidad = 'Ginecología';
--La especialidad de "Ginecología" incluye también "Obstetricia" como parte integral de la formación médica. 

UPDATE especialidad
SET nombre_especialidad = 'Anestesiología y Reanimación'
WHERE especialidad_id = 9 AND nombre_especialidad = 'Oncología';
--Durante una auditoría del sistema se descubrió que el registro con ID 9 correspondía originalmente a "Anestesiología" pero fue ingresado erróneamente como "Oncología".
--
---enfermeras
UPDATE enfermera
SET telefono = '3159876543'
WHERE enfermera_id = 2;
--la enfermera cambió su número telefónico personal. Es fundamental actualizar este dato

UPDATE enfermera
SET hospital_id = (SELECT hospital_id FROM hospital WHERE nombre_hospital = 'Clínica Las Américas')
WHERE enfermera_id = 5;
--la enfermera solicitó traslado a la Clínica Las Américas por cercanía a su nuevo domicilio. 

UPDATE enfermera
SET estado = FALSE
WHERE enfermera_id = 7;
-- presentó incapacidad médica por 2 meses debido a una cirugía programada.

UPDATE enfermera
SET codigo_profesional = 'ENF2025-1234'
WHERE enfermera_id = 9;
--renovó su tarjeta profesional de enfermería ante el Consejo Técnico Nacional de Enfermería.

UPDATE enfermera
SET sexo = 'M'
WHERE enfermera_id = 10;
-- Se detectó que el registro del enfermero fue ingresado con sexo 'F' por error de digitación 
---
---hospitales
UPDATE hospital
SET nombre_hospital = 'Hospital Universitario San Vicente Fundación - Sede Rionegro'
WHERE hospital_id = 1;
--El hospital abrió una nueva sede en Rionegro y cambió su nombre oficial para diferenciarse de la sede principal.

UPDATE hospital
SET direccion = 'Carrera 51D # 62-29, El Poblado, Medellín'
WHERE hospital_id = 3;
--La Clínica Las Américas actualizó su nomenclatura vial oficial según el nuevo POT

UPDATE hospital
SET codigo_hospital = 'HABMED-2025-005'
WHERE hospital_id = 5;
--El Ministerio de Salud implementó un nuevo sistema de códigos de habilitación hospitalaria. 

UPDATE hospital
SET ciudad_id = (SELECT ciudad_id FROM ciudad_pais WHERE nombre_ciudad = 'Itagüí')
WHERE hospital_id = 10;
--Se detectó que el Hospital San Rafael de Itagüí estaba registrado incorrectamente en la ciudad de Medellín. 

UPDATE hospital
SET nombre_hospital = 'Clínica CES - Universidad CES'
WHERE hospital_id = 11;
--La Clínica CES se fusionó oficialmente con el sistema hospitalario de la Universidad CES
---
---hospitalizaciones
UPDATE hospitalizaciones
SET tipo = 'urgencia'
WHERE hospitalizacion_id = 15 AND tipo = 'hospitalización';
--El paciente atendido en el registro 15 inicialmente fue clasificado como "hospitalización" programada 
--pero durante su estancia presentó complicaciones graves que requirieron manejo urgente. Se reclasifica a "urgencia"

UPDATE hospitalizaciones
SET fecha_hora = '2024-11-15 14:30:00'
WHERE hospitalizacion_id = 23;
--se detectó que la fecha de ingreso del paciente fue registrada incorrectamente debido a un error en el sistema durante la admisión

UPDATE hospitalizaciones
SET medico_paciente_id = 42
WHERE hospitalizacion_id = 8;
--El médico tratante original entró en licencia médica durante la hospitalización del paciente. El paciente fue reasignado a otro doctor 

UPDATE hospitalizaciones
SET tipo = 'hospitalización'
WHERE hospitalizacion_id = 31 AND tipo = 'internación';
--Después de evaluación del comité médico, se determinó que el caso registrado como "internación" 
--cumple los criterios clínicos para ser clasificado como "hospitalización"

UPDATE hospitalizaciones
SET fecha_hora = fecha_hora + INTERVAL '1 hour'
WHERE hospitalizacion_id = 50 
  AND fecha_hora BETWEEN '2024-03-10 00:00:00' AND '2024-03-11 23:59:59';
-- Durante el fin de semana del cambio de horario de verano, el sistema no ajustó automáticamente la hora. 
--El paciente ingresó a las 02:30 AM pero fue registrado como 01:30 AM. Se ajusta

--
-- INSTRUCCIONES DELETE 
-- 
----
---

-----
---- ELIMINAR PACIENTES----

DELETE FROM visita 
WHERE paciente_id IN (30, 40, 50, 60, 61);

DELETE FROM visitante 
WHERE paciente_id IN (30, 40, 50, 60, 61);

DELETE FROM asignacion 
WHERE paciente_id IN (30, 40, 50, 60, 61);

DELETE FROM tarjeta_visita 
WHERE paciente_id IN (30, 40, 50, 60, 61);

DELETE FROM diagnostico_paciente 
WHERE hospitalizacion_id IN (
    SELECT h.hospitalizacion_id 
    FROM hospitalizaciones h
    JOIN medico_paciente mp ON h.medico_paciente_id = mp.medico_paciente_id
    WHERE mp.paciente_id IN (30, 40, 50, 60, 61)
);

DELETE FROM diagnostico_medico 
WHERE diag_paciente_id IN (
    SELECT dp.diag_paciente_id 
    FROM diagnostico_paciente dp
    JOIN hospitalizaciones h ON dp.hospitalizacion_id = h.hospitalizacion_id
    JOIN medico_paciente mp ON h.medico_paciente_id = mp.medico_paciente_id
    WHERE mp.paciente_id IN (30, 40, 50, 60, 61)
);

DELETE FROM tratamiento_medicamento 
WHERE paciente_trat_id IN (
    SELECT tp.paciente_trat_id 
    FROM tratamiento_paciente tp
    WHERE tp.paciente_id IN (30, 40, 50, 60, 61)
);

DELETE FROM tratamiento_paciente 
WHERE paciente_id IN (30, 40, 50, 60, 61);

DELETE FROM hospitalizaciones 
WHERE medico_paciente_id IN (
    SELECT medico_paciente_id 
    FROM medico_paciente 
    WHERE paciente_id IN (30, 40, 50, 60, 61)
);

DELETE FROM enfermera_paciente 
WHERE paciente_id IN (30, 40, 50, 60, 61);

DELETE FROM medico_paciente 
WHERE paciente_id IN (30, 40, 50, 60, 61);

DELETE FROM paciente 
WHERE id_paciente IN (30, 40, 50, 60, 61);


--ELIMINAR MÉDICOS 

DELETE FROM diagnostico_medico 
WHERE medico_id IN (3, 6, 7, 8, 20);

DELETE FROM medico_especialidad 
WHERE medico_id IN (3, 6, 7, 8, 20);

DELETE FROM medico_paciente 
WHERE medico_id IN (3, 6, 7, 8, 20);

DELETE FROM hospitalizaciones 
WHERE medico_paciente_id IN (
    SELECT medico_paciente_id 
    FROM medico_paciente 
    WHERE medico_id IN (3, 6, 7, 8, 20)
);

DELETE FROM medico 
WHERE medico_id IN (3, 6, 7, 8, 20);


-- ELIMINAR ESPECIALIDADES

DELETE FROM medico_especialidad 
WHERE especialidad_id IN (4, 7);

delete from medico
where especialidad_id in (4,7)

DELETE FROM especialidad 
WHERE especialidad_id IN (4, 7);


--ELIMINAR 5 PACIENTES (30, 40, 50, 60, 61)
----

-- 1. Eliminar visitas
DELETE FROM visita
WHERE paciente_id IN (30,40,50,60,61);

-- 2. Eliminar visitantes
DELETE FROM visitante
WHERE paciente_id IN (30,40,50,60,61);

-- 3. Eliminar asignaciones
DELETE FROM asignacion
WHERE paciente_id IN (30,40,50,60,61);

-- 4. Eliminar tarjetas de visita
DELETE FROM tarjeta_visita
WHERE paciente_id IN (30,40,50,60,61);

-- 5. Eliminar diagnósticos del médico
DELETE FROM diagnostico_medico
WHERE diag_paciente_id IN (
    SELECT dp.diag_paciente_id
    FROM diagnostico_paciente dp
    JOIN hospitalizaciones h ON h.hospitalizacion_id = dp.hospitalizacion_id
    JOIN medico_paciente mp ON mp.medico_paciente_id = h.medico_paciente_id
    WHERE mp.paciente_id IN (30,40,50,60,61)
);

-- 6. Eliminar diagnósticos del paciente
DELETE FROM diagnostico_paciente
WHERE hospitalizacion_id IN (
    SELECT h.hospitalizacion_id
    FROM hospitalizaciones h
    JOIN medico_paciente mp ON mp.medico_paciente_id = h.medico_paciente_id
    WHERE mp.paciente_id IN (30,40,50,60,61)
);

-- 7. Eliminar medicamentos del tratamiento
DELETE FROM tratamiento_medicamento
WHERE paciente_trat_id IN (
    SELECT tp.paciente_trat_id
    FROM tratamiento_paciente tp
    WHERE tp.paciente_id IN (30,40,50,60,61)
);

-- 8. Eliminar tratamientos
DELETE FROM tratamiento_paciente
WHERE paciente_id IN (30,40,50,60,61);

-- 9. Eliminar hospitalizaciones
DELETE FROM hospitalizaciones
WHERE medico_paciente_id IN (
    SELECT medico_paciente_id
    FROM medico_paciente
    WHERE paciente_id IN (30,40,50,60,61)
);

-- 10. Eliminar relación enfermera-paciente
DELETE FROM enfermera_paciente
WHERE paciente_id IN (30,40,50,60,61);

-- 11. Eliminar relación médico-paciente
DELETE FROM medico_paciente
WHERE paciente_id IN (30,40,50,60,61);

-- 12. Finalmente eliminar pacientes
DELETE FROM paciente
WHERE id_paciente IN (30,40,50,60,61);

----
--ELIMINAR 5 MÉDICOS (3, 6, 7, 8, 20)
----

-- 1. Eliminar relación médico-especialidad
DELETE FROM medico_especialidad
WHERE medico_id IN (3,6,7,8,20);

-- 2. Eliminar hospitalizaciones de estos médicos
DELETE FROM hospitalizaciones
WHERE medico_paciente_id IN (
    SELECT medico_paciente_id
    FROM medico_paciente
    WHERE medico_id IN (3,6,7,8,20)
);

-- 3. Eliminar relación médico-paciente
DELETE FROM medico_paciente
WHERE medico_id IN (3,6,7,8,20);

-- 4. Finalmente eliminar médicos
DELETE FROM medico
WHERE medico_id IN (3,6,7,8,20);

----
--ELIMINAR 2 ESPECIALIDADES (8, 9)
----

-- 1. Eliminar relación médico-especialidad
DELETE FROM medico_especialidad
WHERE especialidad_id IN (8,9);

-- 2. Actualizar médicos que tengan esas especialidades (opcional)
-- O eliminarlos si no hay otra opción
UPDATE medico
SET especialidad_id = NULL
WHERE especialidad_id IN (8,9);

-- 3. Finalmente eliminar especialidades
DELETE FROM especialidad
WHERE especialidad_id IN (8,9);

----
--ELIMINAR 2 ENFERMERAS (8, 9)
----

-- 1. Eliminar relación enfermera-paciente
DELETE FROM enfermera_paciente 
WHERE enfermera_id IN (8,9);

-- 2. Eliminar enfermeras
DELETE FROM enfermera 
WHERE enfermera_id IN (8,9);

----
--ELIMINAR 5 HOSPITALIZACIONES (1, 23, 36, 45, 88)
----

-- 1. Eliminar diagnósticos médicos
DELETE FROM diagnostico_medico
WHERE diag_paciente_id IN (
    SELECT dp.diag_paciente_id
    FROM diagnostico_paciente dp
    WHERE dp.hospitalizacion_id IN (1, 23, 36, 45, 88)
);

-- 2. Eliminar diagnósticos de paciente
DELETE FROM diagnostico_paciente 
WHERE hospitalizacion_id IN (1, 23, 36, 45, 88);

-- 3. Eliminar hospitalizaciones
DELETE FROM hospitalizaciones 
WHERE hospitalizacion_id IN (1, 23, 36, 45, 88);

----
--ELIMINAR 2 HOSPITALES (1, 2)
----

-- 1. Eliminar visitas de pacientes de estos hospitales
DELETE FROM visita 
WHERE paciente_id IN (
    SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
);

-- 2. Eliminar visitantes
DELETE FROM visitante 
WHERE paciente_id IN (
    SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
);

-- 3. Eliminar asignaciones
DELETE FROM asignacion 
WHERE paciente_id IN (
    SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
);

-- 4. Eliminar tarjetas de visita
DELETE FROM tarjeta_visita 
WHERE paciente_id IN (
    SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
);

-- 5. Eliminar medicamentos de tratamiento
DELETE FROM tratamiento_medicamento 
WHERE paciente_trat_id IN (
    SELECT paciente_trat_id
    FROM tratamiento_paciente
    WHERE paciente_id IN (
        SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
    )
);

-- 6. Eliminar tratamientos
DELETE FROM tratamiento_paciente 
WHERE paciente_id IN (
    SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
);

-- 7. Eliminar diagnósticos médicos
DELETE FROM diagnostico_medico 
WHERE diag_paciente_id IN (
    SELECT dp.diag_paciente_id
    FROM diagnostico_paciente dp
    JOIN hospitalizaciones h ON h.hospitalizacion_id = dp.hospitalizacion_id
    JOIN medico_paciente mp ON mp.medico_paciente_id = h.medico_paciente_id
    WHERE mp.paciente_id IN (
        SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
    )
);

-- 8. Eliminar diagnósticos paciente
DELETE FROM diagnostico_paciente 
WHERE hospitalizacion_id IN (
    SELECT h.hospitalizacion_id
    FROM hospitalizaciones h
    JOIN medico_paciente mp ON mp.medico_paciente_id = h.medico_paciente_id
    WHERE mp.paciente_id IN (
        SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
    )
);

-- 9. Eliminar hospitalizaciones
DELETE FROM hospitalizaciones 
WHERE medico_paciente_id IN (
    SELECT medico_paciente_id
    FROM medico_paciente
    WHERE paciente_id IN (
        SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
    )
);

-- 10. Eliminar relación enfermera-paciente
DELETE FROM enfermera_paciente
WHERE paciente_id IN (
    SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
);

-- 11. Eliminar relación médico-paciente
DELETE FROM medico_paciente
WHERE paciente_id IN (
    SELECT id_paciente FROM paciente WHERE hospital_id IN (1, 2)
);

-- 12. Eliminar pacientes del hospital
DELETE FROM paciente 
WHERE hospital_id IN (1, 2);

-- 13. Eliminar cuartos
DELETE FROM cuarto 
WHERE planta_id IN (
    SELECT planta_id FROM planta WHERE hospital_id IN (1, 2)
);

-- 14. Eliminar plantas
DELETE FROM planta 
WHERE hospital_id IN (1, 2);

-- 15. Eliminar enfermeras del hospital
DELETE FROM enfermera
WHERE hospital_id IN (1, 2);

-- 16. Finalmente eliminar hospitales
DELETE FROM hospital 
WHERE hospital_id IN (1, 2);
--------