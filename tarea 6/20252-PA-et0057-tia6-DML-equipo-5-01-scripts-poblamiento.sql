--
-- Tarea 6 - Parte #2 del Proyecto de Aula
-- SCRIPTS DE POBLAMIENTO DE LA BASE DE DATOS (INSERTS)
--
-- Miembros del grupo
-- Andres Santiago Quiroz Gomez 
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa 

 
-- =============================================
-- SCRIPT DE POBLAMIENTO DE BASE DE DATOS
-- Subsistema de Hospitalización
-- =============================================

BEGIN;

-- =============================================
-- 1. POBLAR CIUDAD_PAIS (15 registros - Solo Antioquia)
-- =============================================
INSERT INTO ciudad_pais (nombre_ciudad, nombre_pais) VALUES
('Medellín', 'Colombia'),
('Envigado', 'Colombia'),
('Bello', 'Colombia'),
('Itagüí', 'Colombia'),
('Sabaneta', 'Colombia'),
('La Estrella', 'Colombia'),
('Caldas', 'Colombia'),
('Copacabana', 'Colombia'),
('Girardota', 'Colombia'),
('Barbosa', 'Colombia'),
('Rionegro', 'Colombia'),
('Guarne', 'Colombia'),
('El Retiro', 'Colombia'),
('Carmen de Viboral', 'Colombia'), 
('Marinilla', 'Colombia');  
-- =============================================
-- 2. POBLAR EPS (10 registros)
-- =============================================
INSERT INTO eps (codigo_eps, nombre_eps) VALUES
('EPS001', 'Sura'),
('EPS002', 'Sanitas'),
('EPS003', 'Compensar'),
('EPS004', 'Nueva EPS'),
('EPS005', 'Salud Total'),
('EPS006', 'Coomeva'),
('EPS007', 'Famisanar'),
('EPS008', 'SOS'),
('EPS009', 'Medimás'),
('EPS010', 'Capital Salud');

-- =============================================
-- 3. POBLAR ESPECIALIDAD (15 registros)
-- =============================================
INSERT INTO especialidad (nombre_especialidad) VALUES
('Cardiología'),
('Pediatría'),
('Neurología'),
('Ginecología'),
('Traumatología'),
('Dermatología'),
('Oftalmología'),
('Psiquiatría'),
('Oncología'),
('Urología'),
('Endocrinología'),
('Gastroenterología'),
('Neumología'),
('Nefrología'),
('Hematología');

-- =============================================
-- 4. POBLAR DIAGNOSTICO (25 registros)
-- =============================================
INSERT INTO diagnostico (codigo_diag, descripcion) VALUES
('J18.9', 'Neumonía no especificada'),
('I10', 'Hipertensión arterial'),
('E11.9', 'Diabetes mellitus tipo 2'),
('J45.9', 'Asma'),
('K29.7', 'Gastritis'),
('M54.5', 'Dolor lumbar'),
('R50.9', 'Fiebre no especificada'),
('A09', 'Diarrea y gastroenteritis'),
('J06.9', 'Infección respiratoria aguda'),
('B34.9', 'Infección viral'),
('I25.1', 'Enfermedad aterosclerótica del corazón'),
('N18.9', 'Enfermedad renal crónica'),
('E78.5', 'Hiperlipidemia'),
('M79.3', 'Fibromialgia'),
('G43.9', 'Migraña'),
('F41.9', 'Trastorno de ansiedad'),
('K21.9', 'Reflujo gastroesofágico'),
('M25.5', 'Dolor articular'),
('R51', 'Cefalea'),
('N39.0', 'Infección urinaria'),
('J20.9', 'Bronquitis aguda'),
('L30.9', 'Dermatitis'),
('H10.9', 'Conjuntivitis'),
('K52.9', 'Gastroenteritis no infecciosa'),
('R10.4', 'Dolor abdominal');

-- =============================================
-- 5. POBLAR TRATAMIENTO (20 registros)
-- =============================================
INSERT INTO tratamiento (codigo_trat, nombre_trat, descripcion) VALUES
('T001', 'Terapia antibiótica', 'Administración de antibióticos'),
('T002', 'Terapia analgésica', 'Control del dolor'),
('T003', 'Terapia antihipertensiva', 'Control de presión arterial'),
('T004', 'Terapia respiratoria', 'Mejora función respiratoria'),
('T005', 'Fisioterapia', 'Rehabilitación física'),
('T006', 'Terapia psicológica', 'Apoyo psicológico'),
('T007', 'Quimioterapia', 'Tratamiento oncológico'),
('T008', 'Terapia hormonal', 'Regulación hormonal'),
('T009', 'Terapia anticoagulante', 'Prevención de trombos'),
('T010', 'Terapia antidiabética', 'Control de glucemia'),
('T011', 'Diálisis', 'Depuración renal'),
('T012', 'Oxigenoterapia', 'Suministro de oxígeno'),
('T013', 'Terapia nutricional', 'Soporte alimenticio'),
('T014', 'Rehabilitación cardíaca', 'Recuperación cardiovascular'),
('T015', 'Terapia ocupacional', 'Recuperación funcional'),
('T016', 'Terapia del lenguaje', 'Rehabilitación comunicativa'),
('T017', 'Inmunoterapia', 'Fortalecimiento inmunológico'),
('T018', 'Radioterapia', 'Tratamiento con radiación'),
('T019', 'Cirugía', 'Procedimiento quirúrgico'),
('T020', 'Terapia antiinflamatoria', 'Control de inflamación');

-- =============================================
-- 6. POBLAR MEDICAMENTO (25 registros)
-- =============================================
INSERT INTO medicamento (codigo_med, nombre_med, dosis_estandar) VALUES
('MED001', 'Acetaminofén', '500mg cada 8 horas'),
('MED002', 'Ibuprofeno', '400mg cada 6 horas'),
('MED003', 'Amoxicilina', '500mg cada 8 horas'),
('MED004', 'Losartán', '50mg cada 24 horas'),
('MED005', 'Metformina', '850mg cada 12 horas'),
('MED006', 'Omeprazol', '20mg cada 24 horas'),
('MED007', 'Salbutamol', '2 puff cada 6 horas'),
('MED008', 'Loratadina', '10mg cada 24 horas'),
('MED009', 'Atorvastatina', '20mg cada 24 horas'),
('MED010', 'Enalapril', '10mg cada 12 horas'),
('MED011', 'Diclofenaco', '75mg cada 12 horas'),
('MED012', 'Ranitidina', '150mg cada 12 horas'),
('MED013', 'Ciprofloxacino', '500mg cada 12 horas'),
('MED014', 'Prednisona', '5mg cada 24 horas'),
('MED015', 'Warfarina', '5mg cada 24 horas'),
('MED016', 'Insulina glargina', '10 UI subcutánea'),
('MED017', 'Furosemida', '40mg cada 24 horas'),
('MED018', 'Carvedilol', '25mg cada 12 horas'),
('MED019', 'Tramadol', '50mg cada 8 horas'),
('MED020', 'Levotiroxina', '100mcg cada 24 horas'),
('MED021', 'Aspirina', '100mg cada 24 horas'),
('MED022', 'Clonazepam', '0.5mg cada 12 horas'),
('MED023', 'Captopril', '25mg cada 8 horas'),
('MED024', 'Digoxina', '0.25mg cada 24 horas'),
('MED025', 'Glibenclamida', '5mg cada 12 horas');

-- =============================================
-- 7. POBLAR HOSPITAL (15 registros - Solo Antioquia)
-- =============================================
INSERT INTO hospital (codigo_hospital, nombre_hospital, ciudad_id, direccion) VALUES
('H001', 'Hospital Universitario San Vicente Fundación', 1, 'Calle 64 #51D-154, Medellín'),
('H002', 'Hospital Pablo Tobón Uribe', 1, 'Calle 78B #69-240, Medellín'),
('H003', 'Clínica Las Américas', 1, 'Diagonal 75B #2A-80, Medellín'),
('H004', 'Clínica Medellín', 1, 'Carrera 46 #19-27, Medellín'),
('H005', 'Hospital General de Medellín', 1, 'Carrera 48 #32-102, Medellín'),
('H006', 'Clínica Cardiovascular Santa María', 1, 'Calle 78B #75-21, Medellín'),
('H007', 'Clínica El Rosario', 1, 'Calle 32 #57-30, Medellín'),
('H008', 'Hospital Manuel Uribe Ángel', 2, 'Cra 39A #1A Sur-100, Envigado'),
('H009', 'Clínica Soma', 2, 'Carrera 48 #32B Sur-95, Envigado'),
('H010', 'Hospital San Rafael de Itagüí', 4, 'Calle 52 #48-20, Itagüí'),
('H011', 'Clínica CES', 3, 'Calle 62 #48A-32, Bello'),
('H012', 'Hospital San Vicente de Paúl de Caldas', 7, 'Carrera 50 #70-50, Caldas'),
('H013', 'Clínica León XIII', 1, 'Carrera 63C #51-51, Medellín'),
('H014', 'Hospital La María', 1, 'Carrera 98 #25AA-06, Medellín'),
('H015', 'Clínica Universitaria Bolivariana', 1, 'Calle 78B #72A-109, Medellín');

-- NOTA: Los INSERT de PACIENTE y MEDICO y demas se deben generar con el script Python
-- ya que requieren datos aleatorios (nombres, fechas de nacimiento, teléfonos, etc.)
-- y resulto mas facil ejecutar TODO el poblamiento con el codigo de python, con solo comandos de postgresql resulta con
-- imprecisiones y no genera datos con nombres reales, asi que decidimos generarlo todo con python

COMMIT;