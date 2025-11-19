-- Tarea 5 - Parte #1 del Proyecto de Aula
-- SCRIPTS DE CREACIÓN DE LA BASE DE DATOS
--
-- Andres Santiago Quiroz Gomez
-- Sebastian Sepulveda Quintero
-- Emanuel Ceballos Mesa
--
--eliminar si ya existe una base de datos-----
DROP DATABASE IF EXISTS hce_antioquia;

-----crear la base de datos-----------
CREATE DATABASE hce_antioquia;

---------tablas independientes---------
--------------------------------------
-- 3: ciudad_pais
CREATE TABLE ciudad_pais (
    ciudad_id SERIAL PRIMARY KEY,
    nombre_ciudad VARCHAR(100) UNIQUE NOT NULL,
    pais VARCHAR(100) NOT NULL
);

-- 2: eps 
CREATE TABLE eps (
    eps_id SERIAL PRIMARY KEY,
    codigo_eps VARCHAR(50) UNIQUE NOT NULL,
    nombre_eps VARCHAR(150) NOT NULL
);

-- 4: hospital
CREATE TABLE hospital (
    hospital_id SERIAL PRIMARY KEY,
    codigo_hospital VARCHAR(50) UNIQUE NOT NULL,
    nombre_hospital VARCHAR(200) NOT NULL,
	ciudad_id integer,
  
    CONSTRAINT fk_ciudad FOREIGN KEY (ciudad_id) 
        REFERENCES ciudad_pais(ciudad_id) ON DELETE SET NULL	
);

CREATE INDEX idx_hospital_ciudad ON hospital(ciudad_id); 

-- 12 especialidad 
CREATE TABLE especialidad (
    especialidad_id SERIAL PRIMARY KEY,
    nombre_especialidad VARCHAR(100) UNIQUE NOT NULL
);

 -- 16 diagnostico
 CREATE TABLE diagnostico (
    diag_id SERIAL PRIMARY KEY,
    codigo_diag VARCHAR(20) UNIQUE NOT NULL CHECK (trim(codigo_diag) <> ''),
    descripcion TEXT
);

--21 tratamiento
CREATE TABLE tratamiento (
    trat_id SERIAL PRIMARY KEY,
    codigo_trat VARCHAR(20) UNIQUE NOT NULL CHECK (trim(codigo_trat) <> ''),
    nombre_trat VARCHAR(150) NOT NULL,
    descripcion TEXT
);

--20 medicamento
CREATE TABLE medicamento (
    medicina_id SERIAL PRIMARY KEY,
    codigo_med VARCHAR(20) UNIQUE NOT NULL,
    nombre_med VARCHAR(150) NOT NULL,
    dosis_estandar VARCHAR(50)
);
---------------tablas dependientes---------------
--------------------------------------------------
-- 1. tabla paciente
create table paciente (
	id_paciente serial primary key,
	nombre varchar(100) not null,
	primer_apellido varchar (100) not null,
	segundo_apellido varchar (100),
	cedula varchar (20) unique not null,
	fecha_nacimiento date not null, 
	sexo varchar (10) not null,
	ciudad_id integer,
	eps_id integer,
	hospital_id integer,
		constraint fk_ciudad_pais foreign key (ciudad_id) 
	references ciudad_pais(ciudad_id),
	
		constraint fk_eps foreign key (eps_id) 
	references eps(eps_id),
	
		constraint fk_hospital foreign key (hospital_id) 
	references hospital(hospital_id),
	tarjetas_disponibles integer default 4 check (tarjetas_disponibles <= 4),
	tarjetas_utilizadas integer default 0 check (tarjetas_utilizadas >= 0),
	fecha_alta timestamp default current_timestamp,
	tel1 varchar(20),
	tel2 varchar(20),
CONSTRAINT chk_tel1 CHECK (tel1 IS NULL OR tel1 ~ '^[0-9]+$'),
CONSTRAINT chk_tel2 CHECK (tel2 IS NULL OR tel2 ~ '^[0-9]+$')
);

CREATE INDEX idx_paciente_ciudad ON paciente(ciudad_id);
CREATE INDEX idx_paciente_eps ON paciente(eps_id);
CREATE INDEX idx_paciente_hospital ON paciente(hospital_id);

-- 11 medico
CREATE TABLE medico (
    medico_id SERIAL PRIMARY KEY,
    codigo VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
	sexo varchar (10) NOT NULL,
    especialidad_id INTEGER NOT NULL,
    telefono VARCHAR(30),
	CONSTRAINT chk_tel CHECK (telefono IS NULL OR telefono ~ '^[0-9 +()-]+$'),
    CONSTRAINT fk_especialidad FOREIGN KEY (especialidad_id) 
        REFERENCES especialidad(especialidad_id) ON DELETE RESTRICT
);
CREATE INDEX idx_medico_especialidad ON medico(especialidad_id);

--5 planta 
CREATE TABLE planta (
    planta_id SERIAL PRIMARY KEY,
    hospital_id INTEGER NOT NULL,	
    CONSTRAINT fk_hospital FOREIGN KEY (hospital_id) 
        REFERENCES hospital(hospital_id) ON DELETE CASCADE,
	numero_planta INTEGER NOT NULL	
);
CREATE INDEX idx_planta_hospital ON planta(hospital_id);

-- 6 cuarto
CREATE TABLE cuarto (
    cuarto_id SERIAL PRIMARY KEY,
    planta_id INTEGER NOT NULL,
    numero_cuarto VARCHAR(20) NOT NULL,
    
    CONSTRAINT fk_cuarto_planta FOREIGN KEY (planta_id) 
        REFERENCES planta(planta_id) ON DELETE CASCADE
);
CREATE INDEX idx_cuarto_planta ON cuarto(planta_id);

 --7 asignación 
CREATE TABLE asignacion (
    asig_id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    cuarto_id INTEGER NOT NULL,
    motivo TEXT,
    
    CONSTRAINT fk_asignacion_paciente FOREIGN KEY (paciente_id) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    CONSTRAINT fk_asignacion_cuarto FOREIGN KEY (cuarto_id) 
        REFERENCES cuarto(cuarto_id) ON DELETE CASCADE
);
CREATE INDEX idx_asignacion_paciente ON asignacion(paciente_id);
CREATE INDEX idx_asignacion_cuarto ON asignacion(cuarto_id);

 --8 tarjeta_visita
CREATE TABLE tarjeta_visita (
    tarjeta_id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    numero_tarj INTEGER NOT NULL,
    estado BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT fk_tarjeta_paciente FOREIGN KEY (paciente_id) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE
);
CREATE INDEX idx_tarjeta_paciente ON tarjeta_visita(paciente_id);

--9 visitante 
CREATE TABLE visitante (
    paciente_id INTEGER NOT NULL,
    numero_visitante INTEGER NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(50),
 
    PRIMARY KEY (paciente_id, numero_visitante),
    CONSTRAINT chk_tel CHECK (telefono ~ '^[0-9]+$'),
	
    CONSTRAINT fk_visitante_paciente FOREIGN KEY (paciente_id) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE
);
CREATE INDEX idx_visitante_paciente ON visitante(paciente_id);

-- 10 visita
CREATE TABLE visita (
    visita_id SERIAL PRIMARY KEY,
    numero_visitante INTEGER NOT NULL,
    paciente_id INTEGER NOT NULL,
	FOREIGN KEY (paciente_id, numero_visitante) 
          REFERENCES visitante(paciente_id, numero_visitante) ON DELETE CASCADE,
    tarjeta_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    
    CONSTRAINT fk_visita_paciente FOREIGN KEY (paciente_id) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    CONSTRAINT fk_visita_tarjeta FOREIGN KEY (tarjeta_id) 
        REFERENCES tarjeta_visita(tarjeta_id) ON DELETE CASCADE

);
CREATE INDEX idx_visita_visitante ON visita(paciente_id, numero_visitante);
CREATE INDEX idx_visita_paciente ON visita(paciente_id);
CREATE INDEX idx_visita_tarjeta ON visita(tarjeta_id);

-- 17 enfermera
CREATE TABLE enfermera (
    enfermera_id SERIAL PRIMARY KEY,
    codigo_profesional VARCHAR(20) UNIQUE NOT NULL,
    nombre VARCHAR(150) NOT NULL,
    telefono VARCHAR(20),
    hospital_id INTEGER NOT NULL,
    sexo CHAR(1) NOT NULL CHECK (sexo IN ('F', 'M')),
    estado BOOLEAN DEFAULT TRUE,
    
    CONSTRAINT fk_enfermera_hospital FOREIGN KEY (hospital_id) 
        REFERENCES hospital(hospital_id) ON DELETE RESTRICT
);

-- 18  enfermera_paciente
CREATE TABLE enfermera_paciente (
    enfermera_paciente_id SERIAL PRIMARY KEY,
    enfermera_id INTEGER NOT NULL,
    paciente_id INTEGER NOT NULL,
    fecha_asignacion TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    turno VARCHAR(20) CHECK (turno IN ('mañana', 'tarde', 'noche')),
    
    CONSTRAINT fk_enfermera_paciente_enfermera FOREIGN KEY (enfermera_id) 
        REFERENCES enfermera(enfermera_id) ON DELETE CASCADE,
    CONSTRAINT fk_enfermera_paciente_paciente FOREIGN KEY (paciente_id) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    CONSTRAINT uk_enfermera_paciente UNIQUE (enfermera_id, paciente_id)
);

CREATE INDEX idx_enfermera_hospital ON enfermera(hospital_id);
CREATE INDEX idx_enfermera_paciente_enfermera ON enfermera_paciente(enfermera_id);
CREATE INDEX idx_enfermera_paciente_paciente ON enfermera_paciente(paciente_id);


--13  medico_especialidad 
CREATE TABLE medico_especialidad (
    medico_id INTEGER NOT NULL,
    especialidad_id INTEGER NOT NULL,
     
    PRIMARY KEY (medico_id, especialidad_id),
     
    CONSTRAINT fk_medico_especialidad_medico FOREIGN KEY (medico_id) 
        REFERENCES medico(medico_id) ON DELETE CASCADE,
    CONSTRAINT fk_medico_especialidad_especialidad FOREIGN KEY (especialidad_id) 
        REFERENCES especialidad(especialidad_id) ON DELETE CASCADE 
);
CREATE INDEX idx_medico_especialidad_especialidad ON medico_especialidad(especialidad_id);

-- 14 medico_paciente 
CREATE TABLE medico_paciente (
    medico_paciente_id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    rol VARCHAR(50),
    
    CONSTRAINT fk_medico_paciente_paciente FOREIGN KEY (paciente_id) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    CONSTRAINT fk_medico_paciente_medico FOREIGN KEY (medico_id) 
        REFERENCES medico(medico_id) ON DELETE CASCADE
);
CREATE INDEX idx_medico_paciente_medico ON medico_paciente(medico_id); 

-- 15 hospitalizaciones 
CREATE TABLE hospitalizaciones (
    hospitalizacion_id SERIAL PRIMARY KEY,
    medico_paciente_id INTEGER NOT NULL,
    fecha_hora TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    tipo VARCHAR(80),
    
    CONSTRAINT fk_hospitalizaciones_medico_paciente FOREIGN KEY (medico_paciente_id) 
        REFERENCES medico_paciente(medico_paciente_id) ON DELETE CASCADE
);
CREATE INDEX idx_hospitalizaciones_medico_paciente ON hospitalizaciones(medico_paciente_id);
CREATE INDEX idx_hospitalizaciones_fecha_hora ON hospitalizaciones(fecha_hora);

--19  diagnostico_paciente 
CREATE TABLE diagnostico_paciente (
    diag_paciente_id SERIAL PRIMARY KEY,
    hospitalizacion_id INTEGER NOT NULL,
    diag_id INTEGER NOT NULL,
    descripcion TEXT,
     
    CONSTRAINT fk_diagnostico_paciente_hospitalizaciones FOREIGN KEY (hospitalizacion_id) 
        REFERENCES hospitalizaciones(hospitalizacion_id) ON DELETE CASCADE,
    CONSTRAINT fk_diagnostico_paciente_diagnostico FOREIGN KEY (diag_id) 
        REFERENCES diagnostico(diag_id) ON DELETE RESTRICT

);
CREATE INDEX idx_diagnostico_paciente_hospitalizaciones ON diagnostico_paciente(hospitalizacion_id);

--20  diagnostico_medico 
CREATE TABLE diagnostico_medico (
    diag_medico SERIAL PRIMARY KEY,
    diag_paciente_id INTEGER NOT NULL,
    medico_id INTEGER NOT NULL,
    rol VARCHAR(50),
     
    CONSTRAINT fk_diagnostico_medico_diagnostico_paciente FOREIGN KEY (diag_paciente_id) 
        REFERENCES diagnostico_paciente(diag_paciente_id) ON DELETE CASCADE,
    CONSTRAINT fk_diagnostico_medico_medico FOREIGN KEY (medico_id) 
        REFERENCES medico(medico_id) ON DELETE CASCADE
);
CREATE INDEX idx_diagnostico_medico_diagnostico_paciente ON diagnostico_medico(diag_paciente_id);
CREATE INDEX idx_diagnostico_medico_medico ON diagnostico_medico(medico_id);

--23  tratamiento_paciente 
CREATE TABLE tratamiento_paciente (
    paciente_trat_id SERIAL PRIMARY KEY,
    paciente_id INTEGER NOT NULL,
    trat_id INTEGER NOT NULL,
    diag_medico INTEGER NOT NULL,
    fecha_inicio DATE NOT NULL CHECK (fecha_inicio <= CURRENT_DATE),
    fecha_fin DATE,
    descripcion TEXT,
    
    CONSTRAINT fk_tratamiento_paciente_paciente FOREIGN KEY (paciente_id) 
        REFERENCES paciente(id_paciente) ON DELETE CASCADE,
    CONSTRAINT fk_tratamiento_paciente_tratamiento FOREIGN KEY (trat_id) 
        REFERENCES tratamiento(trat_id) ON DELETE RESTRICT,
    CONSTRAINT fk_tratamiento_paciente_diagnostico_medico FOREIGN KEY (diag_medico) 
        REFERENCES diagnostico_medico(diag_medico) ON DELETE CASCADE

);
CREATE INDEX idx_tratamiento_paciente_paciente ON tratamiento_paciente(paciente_id);
CREATE INDEX idx_tratamiento_paciente_tratamiento ON tratamiento_paciente(trat_id);
CREATE INDEX idx_tratamiento_paciente_diagnostico_medico ON tratamiento_paciente(diag_medico);

--24  tratamiento_medicamento 
CREATE TABLE tratamiento_medicamento (
    trat_medicamento_id SERIAL PRIMARY KEY,
    paciente_trat_id INTEGER NOT NULL,
    medicina_id INTEGER NOT NULL,
    desc_dosis VARCHAR(80),
    
    CONSTRAINT fk_tratamiento_medicamento_paciente_trat FOREIGN KEY (paciente_trat_id) 
        REFERENCES tratamiento_paciente(paciente_trat_id) ON DELETE CASCADE,
    CONSTRAINT fk_tratamiento_medicamento_medicamento FOREIGN KEY (medicina_id) 
        REFERENCES medicamento(medicina_id) ON DELETE RESTRICT
);
CREATE INDEX idx_tratamiento_medicamento_paciente_trat ON tratamiento_medicamento(paciente_trat_id);
