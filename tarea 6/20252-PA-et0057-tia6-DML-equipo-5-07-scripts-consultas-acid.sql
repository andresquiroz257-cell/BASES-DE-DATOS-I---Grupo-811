--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- VALIDACIÓN DE PROPIEDADES ACID
--
-- Miembros del grupo
-- Andres Santiago Quiroz Gomez 
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa 
 
--
-- OPERACIONES DE VALIDACIONES ACID
--


--
-- 3 INSERTS
--
-- INSERT #1: Agregar un nuevo paciente
BEGIN;

INSERT INTO paciente (
    nombre, primer_apellido, segundo_apellido, cedula, 
    fecha_nacimiento, ciudad_id, eps_id, hospital_id, 
    email, tel1, sexo
) VALUES (
    'Carlos', 'Ramírez', 'Gómez', '1234567890',
    '1995-06-15', 1, 1, 3,
    'carlos.ramirez@email.com', '3001234567', 'M'
);
COMMIT;
--Atomicidad:
--CUMPLE: Si la inserción falla por cualquier razón (violación de UNIQUE en cédula, FK inexistente, CHECK constraint)
--Consistencia:
--La BD valida: cedula debe ser único (UNIQUE constraint) - ciudad_id, eps_id, hospital_id deben existir (FK constraints)
--Aislamiento:
--Si otro usuario intenta insertar el mismo paciente simultáneamente:
--PostgreSQL bloquea la fila hasta que se complete el COMMIT
--Durabilidad:
--Después del COMMIT:Los datos se escriben en el disco - Sobreviven a caídas del sistema o apagones


--INSERT #2: Registrar una hospitalización con diagnóstico
BEGIN;
-- Insertar hospitalización
INSERT INTO hospitalizaciones (medico_paciente_id, fecha_hora, tipo)
VALUES (5, '2024-11-20 10:30:00', 'urgencia')
RETURNING hospitalizacion_id;  -- Supongamos que retorna ID 104

SELECT 
	MAX(hospitalizacion_id) --ultima id generada
	from hospitalizaciones;

-- Insertar diagnóstico asociado
INSERT INTO diagnostico_paciente (hospitalizacion_id, diag_id, descripcion)
VALUES (104, 3, 'Paciente presenta dolor abdominal agudo');--no funciona si la fk hospitalizacion_id no es la misma de arriba
COMMIT;
 --Atomicidad:
--Las dos inserciones son una sola unidad atómica:
--Si la primera INSERT falla → nada se inserta - Si la segunda INSERT falla → se deshace la primera (ROLLBACK)
--Todo o nada: No puede haber hospitalización sin diagnóstico ni viceversa
--Consistencia:
--medico_paciente_id debe existir (FK constraint) - diag_id debe existir en tabla diagnostico (FK constraint) -hospitalizacion_id 150 debe existir para insertar diagnóstico
--Aislamiento:
--Otra transacción no puede leer hospitalizacion_id=150 hasta el COMMIT- Evita que otro proceso intente usar un ID no confirmado
--Durabilidad:
--Ambas inserciones persisten juntas después del COMMIT- La relación hospitalización-diagnóstico es permanente


--INSERT #3: Asignar enfermera a paciente con validación
BEGIN;
-- Verificar que la enfermera está activa
DO $$
DECLARE
    v_enfermera_activa BOOLEAN;
BEGIN
    SELECT estado INTO v_enfermera_activa
    FROM enfermera
    WHERE enfermera_id = 3;
    
    IF v_enfermera_activa = FALSE THEN
        RAISE EXCEPTION 'La enfermera no está activa';
    END IF;
END $$;

-- Insertar asignación
INSERT INTO enfermera_paciente (enfermera_id, paciente_id, fecha_asignacion, turno)
VALUES (5, 11, CURRENT_TIMESTAMP, 'mañana');
COMMIT;
--Atomicidad:
--Si la validación falla (enfermera inactiva), se lanza excepción- El RAISE EXCEPTION provoca ROLLBACK automático - No se inserta ningún dato si la validación falla
--Consistencia:
--Valida reglas de negocio (enfermera activa) antes de insertar- FK constraints validan existencia de enfermera y paciente
--UNIQUE constraint (enfermera_id, paciente_id) previene duplicados - Estado consistente: solo enfermeras activas asignadas
--Aislamiento:
--La validación y la inserción son atómicas - Otra transacción no puede desactivar la enfermera entre la validación y la inserción
--Durabilidad:
--Una vez confirmada, la asignación es permanente - La relación enfermera-paciente persiste en el sistema

--
-- 3 UPDATES
--

--UPDATE #1: Cambiar hospital de un paciente
DO $$
DECLARE
    v_filas_afectadas INTEGER;
BEGIN
    UPDATE paciente
    SET hospital_id = 5
    WHERE id_paciente = 24;

    GET DIAGNOSTICS v_filas_afectadas = ROW_COUNT;

    IF v_filas_afectadas = 0 THEN
        RAISE NOTICE 'ADVERTENCIA: No se encontró el paciente con ID 22.';
    ELSIF v_filas_afectadas = 1 THEN
        RAISE NOTICE 'ÉXITO: Se actualizó 1 paciente correctamente';
    ELSE
        RAISE EXCEPTION 'ERROR: Se actualizaron % pacientes (se esperaba solo 1).', v_filas_afectadas;
    END IF;
END $$;

SELECT id_paciente, hospital_id FROM  paciente
where id_paciente = '24';
--Atomicidad:
--El UPDATE y la validación son una operación atómica- Si la validación falla (0 o múltiples filas), se revierte el UPDATE
--Garantiza que solo se actualice exactamente 1 paciente
--Consistencia:
--hospital_id=5 debe existir (FK constraint)- Si el hospital no existe, PostgreSQL rechaza el UPDATE- Valida que solo 1 fila sea afectada (lógica de negocio)
--Aislamiento:
--Durante el UPDATE, la fila del paciente queda bloqueada (row-level lock)- Otra transacción no puede modificar el mismo paciente hasta el COMMIT
 --Durabilidad:
--El nuevo hospital_id=5 persiste después del COMMIT


--UPDATE #2: Actualizar múltiples teléfonos con rollback condicional
DO $$
DECLARE
    v_actualizados INTEGER;
BEGIN
-- Actualizar teléfonos de pacientes de una ciudad
UPDATE paciente
SET tel1 = '604' || SUBSTRING(tel1, 4)
WHERE ciudad_id = 3
  AND tel1 LIKE '3%';  -- Solo celulares

-- Verificar cuántos se actualizaron

    GET DIAGNOSTICS v_actualizados = ROW_COUNT;
    
    -- Si se actualizaron más de 20, revertir (posible error)
    IF v_actualizados > 20 THEN
        RAISE EXCEPTION 'Demasiados registros afectados (%), posible error', v_actualizados;
    END IF;
    
    RAISE NOTICE 'Se actualizaron % teléfonos correctamente', v_actualizados;
END $$;
COMMIT;
--Atomicidad:
--Todos los teléfonos se actualizan o ninguno- Si la validación falla (más de 20), se deshacen TODOS los cambios
--No hay estado intermedio con algunos teléfonos actualizados
--Consistencia:
--CHECK constraint valida formato de teléfono (solo números)- La lógica de negocio limita actualizaciones masivas
--Aislamiento:
--Las filas actualizadas quedan bloqueadas durante la transacción- Otra sesión no puede leer los teléfonos a medio actualizar
--Durabilidad:
--Los nuevos teléfonos persisten después del COMMIT


---UPDATE #3: Cambiar estado de hospitalización con auditoría

DO $$
DECLARE 
    v_filas INT;
 BEGIN
-- Actualizar tipo de hospitalización
UPDATE hospitalizaciones
SET tipo = 'internación'
WHERE hospitalizacion_id = 72
  AND tipo = 'hospitalización';
  
-- Validar si se modificó exactamente 1 fila 
    GET DIAGNOSTICS v_filas = ROW_COUNT;
    IF v_filas = 0 THEN
        RAISE NOTICE 'Advertencia: no se encontró la hospitalización con ID 25 o ya tenía tipo distinto.';
    ELSIF v_filas = 1 THEN
        RAISE NOTICE 'Éxito: se actualizó el tipo correctamente.';
    ELSE
        RAISE EXCEPTION 'Error: se actualizaron % filas (solo debía actualizarse 1)', v_filas;
    END IF;
END $$;
COMMIT;

SELECT hospitalizacion_id, tipo
FROM hospitalizaciones
WHERE hospitalizacion_id = 72;
--Atomicidad:
--UPDATE de hospitalización una sola operación - Si la auditoría falla, el UPDATE se revierte
--Consistencia:
--CHECK constraint valida que tipo sea valor permitido
--Aislamiento:
--La hospitalización queda bloqueada durante el UPDATE- Otra transacción no puede modificar el mismo registro
--Durabilidad:
--El historial de cambios es permanente

--
-- 3 DELETES
--
--DELETE #1: Eliminar paciente con validación de dependencias

BEGIN;
-- Verificar que no tenga hospitalizaciones activas
DO $$
DECLARE
    v_hospitalizaciones_activas INTEGER;
BEGIN
    SELECT COUNT(*) INTO v_hospitalizaciones_activas
    FROM hospitalizaciones h
    JOIN medico_paciente mp ON h.medico_paciente_id = mp.medico_paciente_id
    WHERE mp.paciente_id = 11
      AND h.fecha_hora >= CURRENT_DATE - INTERVAL '7 days';
    
    IF v_hospitalizaciones_activas > 0 THEN
        RAISE EXCEPTION 'No se puede eliminar: paciente tiene % hospitalizaciones activas', v_hospitalizaciones_activas;
    END IF;
END $$;

-- Eliminar paciente (CASCADE eliminará relaciones)
DELETE FROM paciente
	WHERE id_paciente = 11;
COMMIT;

	SELECT id_paciente  FROM paciente where id_paciente = 11;
--Atomicidad:
--Validación + DELETE son una operación indivisible- Si la validación falla, no se elimina nada- El CASCADE elimina todas las dependencias atómicamente
--Todo se elimina o nada se elimina
--Consistencia:
--Valida regla de negocio: no eliminar pacientes con hospitalizaciones recientes- CASCADE mantiene integridad referencial eliminando registros huérfanos
--No quedan referencias a un paciente eliminado
--Aislamiento:
--Durante la validación y DELETE, todas las filas relacionadas quedan bloqueadas- Otra transacción no puede insertar nuevas relaciones mientras se elimina
--Durabilidad:
--La eliminación es permanente después del COMMIT- Todos los registros relacionados eliminados por CASCADE son irrecuperables


--DELETE #2: Eliminar hospitalizaciones antiguas con límite
DO $$
DECLARE
    v_eliminados INTEGER;
BEGIN
-- Eliminar hospitalizaciones de más de 2 años
WITH hospitalizaciones_antiguas AS (
    SELECT hospitalizacion_id
    FROM hospitalizaciones
    WHERE fecha_hora < CURRENT_DATE - INTERVAL '350 days'
    LIMIT 50  -- Límite de seguridad
)
DELETE FROM hospitalizaciones
WHERE hospitalizacion_id IN (SELECT hospitalizacion_id FROM hospitalizaciones_antiguas);

-- Verificar eliminaciones

    GET DIAGNOSTICS v_eliminados = ROW_COUNT;
    
    IF v_eliminados = 0 THEN
        RAISE NOTICE 'No hay hospitalizaciones antiguas para eliminar';
    ELSE
        RAISE NOTICE 'Se eliminaron % hospitalizaciones antiguas', v_eliminados;
    END IF;
 END $$;
COMMIT;
--Atomicidad:
--Todas las hospitalizaciones (hasta 50) se eliminan juntas- Si alguna falla (FK constraints), se revierten todas- LIMIT evita eliminaciones masivas accidentales
--Consistencia:
--CASCADE elimina diagnósticos asociados automáticamente- No quedan registros huérfanos en diagnostico_paciente- Estado consistente: integridad referencial mantenida
-- Aislamiento:
--Las filas a eliminar quedan bloqueadas durante la transacción- Otra sesión no puede modificar esas hospitalizaciones- El LIMIT previene bloqueos masivos
--Durabilidad:
--Las eliminaciones son permanentes después del COMMIT


--DELETE #3: Eliminación condicional múltiple con punto de guardado

DO $$
DECLARE
    v_eliminadas INTEGER;
BEGIN
 
-- Intentar eliminar enfermeras inactivas
DELETE FROM enfermera_paciente
WHERE enfermera_id IN (
    SELECT enfermera_id FROM enfermera WHERE estado = FALSE
);

DELETE FROM enfermera
WHERE estado = FALSE;

-- Verificar eliminaciones
 
    GET DIAGNOSTICS v_eliminadas = ROW_COUNT;
    
    -- Si se eliminaron más de 5, revertir al savepoint
    IF v_eliminadas > 10 THEN
        RAISE NOTICE 'Demasiadas enfermeras eliminadas (%), revirtiendo...', v_eliminadas;
 
        RAISE EXCEPTION 'Operación cancelada: verificar datos';
    ELSE
        RAISE NOTICE 'Se eliminaron % enfermeras inactivas correctamente', v_eliminadas;
    END IF;
 END $$;
COMMIT; 

select * from enfermera;
--Atomicidad:
--Si la validación falla, se revierte solo hasta el savepoint- Eliminación de relaciones + enfermeras es atómica
--Consistencia:
--Solo elimina enfermeras inactivas (regla de negocio)- Elimina primero las relaciones (FK dependencies)
--Aislamiento:
--Durante los DELETE, las filas quedan bloqueadas -Otra transacción no ve cambios hasta el COMMIT final
--Durabilidad:
--Si se confirma, las eliminaciones son permanentes - Después del COMMIT, los cambios persisten
