import psycopg2
from faker import Faker
import random
from datetime import datetime, timedelta

# =============================================
# CONFIGURACIÓN DE CONEXIÓN A POSTGRESQL
# =============================================
DB_CONFIG = {
    'host': 'localhost',
    'port': 5432,
    'database': 'TU-BASE-DE-DATOS',  # EDITAR AQUÍ
    'user': 'postgres',  # EDITAR AQUÍ
    'password': 'TU-CONTRASEÑA'  # EDITAR AQUÍ
}

# Inicializar Faker en español de Colombia
fake = Faker('es_CO')
Faker.seed(0)  # Para reproducibilidad opcional

# Función para generar teléfonos colombianos
def generar_telefono_colombiano():
    """Genera un teléfono colombiano realista (solo números, 10 dígitos)"""
    # Celulares empiezan con 3 (300-359)
    if random.random() > 0.3:
        tel = f"3{random.randint(0, 5)}{random.randint(0, 9)}{random.randint(1000000, 9999999)}"
    # Fijos de Medellín empiezan con 604 o 605
    else:
        tel = f"60{random.choice([4, 5])}{random.randint(1000000, 9999999)}"
    
    # Asegurar que solo tenga números
    tel = ''.join(filter(str.isdigit, tel))
    return tel

# =============================================
# FUNCIÓN PARA CONECTAR A LA BASE DE DATOS
# =============================================
def conectar_db():
    try:
        conn = psycopg2.connect(**DB_CONFIG)
        print("✅ Conexión exitosa a PostgreSQL")
        return conn
    except Exception as e:
        print(f"❌ Error al conectar: {e}")
        return None

# =============================================
# FUNCIÓN PARA GENERAR FECHA ALEATORIA
# =============================================
def fecha_aleatoria(inicio, fin):
    """Genera una fecha aleatoria entre inicio y fin"""
    delta = fin - inicio
    dias_random = random.randint(0, delta.days)
    return inicio + timedelta(days=dias_random)

# =============================================
# POBLAR TABLA: ciudad_pais
# =============================================
def poblar_ciudad_pais(cursor, cantidad=15):
    print(f"\n📍 Poblando ciudad_pais ({cantidad} registros - Antioquia, Colombia)...")
    ciudades_paises = [
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
        ('Marinilla', 'Colombia')
    ]
   
    for ciudad, pais in ciudades_paises[:cantidad]:
        cursor.execute("""
            INSERT INTO ciudad_pais (nombre_ciudad, nombre_pais)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
        """, (ciudad, pais))
    
    print(f"✅ {cantidad} ciudades insertadas")

# =============================================
# POBLAR TABLA: eps
# =============================================
def poblar_eps(cursor, cantidad=10):
    print(f"\n🏥 Poblando eps ({cantidad} registros)...")
    eps_lista = ['Sura', 'Sanitas', 'Compensar', 'Nueva EPS', 'Salud Total', 
                 'Coomeva', 'Famisanar', 'SOS', 'Medimás', 'Capital Salud']
    
    for i, nombre in enumerate(eps_lista[:cantidad], 1):
        codigo = f"EPS{i:03d}"
        cursor.execute("""
            INSERT INTO eps (codigo_eps, nombre_eps)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
        """, (codigo, nombre))
    
    print(f"✅ {cantidad} EPS insertadas")

# =============================================
# POBLAR TABLA: especialidad
# =============================================
def poblar_especialidad(cursor, cantidad=15):
    print(f"\n👨‍⚕️ Poblando especialidad ({cantidad} registros)...")
    especialidades = [
        'Cardiología', 'Pediatría', 'Neurología', 'Ginecología',
        'Traumatología', 'Dermatología', 'Oftalmología', 'Psiquiatría',
        'Oncología', 'Urología', 'Endocrinología', 'Gastroenterología',
        'Neumología', 'Nefrología', 'Hematología'
    ]
    
    for esp in especialidades[:cantidad]:
        cursor.execute("""
            INSERT INTO especialidad (nombre_especialidad)
            VALUES (%s)
            ON CONFLICT DO NOTHING
        """, (esp,))
    
    print(f"✅ {cantidad} especialidades insertadas")

# =============================================
# POBLAR TABLA: diagnostico
# =============================================
def poblar_diagnostico(cursor, cantidad=25):
    print(f"\n🔬 Poblando diagnostico ({cantidad} registros)...")
    diagnosticos = [
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
        ('R10.4', 'Dolor abdominal')
    ]
    
    for codigo, desc in diagnosticos[:cantidad]:
        cursor.execute("""
            INSERT INTO diagnostico (codigo_diag, descripcion)
            VALUES (%s, %s)
            ON CONFLICT DO NOTHING
        """, (codigo, desc))
    
    print(f"✅ {cantidad} diagnósticos insertados")

# =============================================
# POBLAR TABLA: tratamiento
# =============================================
def poblar_tratamiento(cursor, cantidad=20):
    print(f"\n💊 Poblando tratamiento ({cantidad} registros)...")
    tratamientos = [
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
        ('T020', 'Terapia antiinflamatoria', 'Control de inflamación')
    ]
    
    for codigo, nombre, desc in tratamientos[:cantidad]:
        cursor.execute("""
            INSERT INTO tratamiento (codigo_trat, nombre_trat, descripcion)
            VALUES (%s, %s, %s)
            ON CONFLICT DO NOTHING
        """, (codigo, nombre, desc))
    
    print(f"✅ {cantidad} tratamientos insertados")

# =============================================
# POBLAR TABLA: medicamento
# =============================================
def poblar_medicamento(cursor, cantidad=25):
    print(f"\n💉 Poblando medicamento ({cantidad} registros)...")
    medicamentos = [
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
        ('MED025', 'Glibenclamida', '5mg cada 12 horas')
    ]
    
    for codigo, nombre, dosis in medicamentos[:cantidad]:
        cursor.execute("""
            INSERT INTO medicamento (codigo_med, nombre_med, dosis_estandar)
            VALUES (%s, %s, %s)
            ON CONFLICT DO NOTHING
        """, (codigo, nombre, dosis))
    
    print(f"✅ {cantidad} medicamentos insertados")

# =============================================
# POBLAR TABLA: hospital
# =============================================
def poblar_hospital(cursor, cantidad=15):
    print(f"\n🏥 Poblando hospital ({cantidad} registros - Hospitales de Antioquia)...")
    
    # Obtener IDs de ciudades
    cursor.execute("SELECT ciudad_id FROM ciudad_pais LIMIT %s", (cantidad,))
    ciudades_ids = [row[0] for row in cursor.fetchall()]
    
    hospitales = [
        'Hospital Universitario San Vicente Fundación',
        'Hospital Pablo Tobón Uribe',
        'Clínica Las Américas',
        'Clínica Medellín',
        'Hospital General de Medellín',
        'Clínica Cardiovascular Santa María',
        'Clínica El Rosario',
        'Hospital Manuel Uribe Ángel',
        'Clínica Soma',
        'Hospital San Rafael de Itagüí',
        'Clínica CES',
        'Hospital San Vicente de Paúl de Caldas',
        'Clínica León XIII',
        'Hospital La María',
        'Clínica Universitaria Bolivariana'
    ]
    
    for i, nombre in enumerate(hospitales[:cantidad], 1):
        codigo = f"H{i:03d}"
        ciudad_id = ciudades_ids[i % len(ciudades_ids)]
        direccion = fake.address()
        
        cursor.execute("""
            INSERT INTO hospital (codigo_hospital, nombre_hospital, ciudad_id, direccion)
            VALUES (%s, %s, %s, %s)
        """, (codigo, nombre, ciudad_id, direccion))
    
    print(f"✅ {cantidad} hospitales insertados")

# =============================================
# POBLAR TABLA: paciente
# =============================================
def poblar_paciente(cursor):
    print(f"\n👤 Poblando paciente (100 registros distribuidos por edad y sexo)...")
    
    # Obtener IDs necesarios
    cursor.execute("SELECT ciudad_id FROM ciudad_pais")
    ciudades_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT eps_id FROM eps")
    eps_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT hospital_id FROM hospital")
    hospital_ids = [row[0] for row in cursor.fetchall()]
    
    # Definir grupos etarios con cantidad de registros
    grupos_etarios = [
        {'min_edad': 1, 'max_edad': 10, 'hombres': 5, 'mujeres': 5},      # 10 registros
        {'min_edad': 11, 'max_edad': 20, 'hombres': 7, 'mujeres': 8},     # 15 registros
        {'min_edad': 21, 'max_edad': 40, 'hombres': 10, 'mujeres': 10},   # 20 registros
        {'min_edad': 41, 'max_edad': 60, 'hombres': 13, 'mujeres': 12},   # 25 registros
        {'min_edad': 61, 'max_edad': 90, 'hombres': 15, 'mujeres': 15},   # 30 registros
    ]
    # Total: 50 hombres + 50 mujeres = 100 pacientes
    
    total_insertados = 0
    hoy = datetime.now()
    
    for grupo in grupos_etarios:
        min_edad = grupo['min_edad']
        max_edad = grupo['max_edad']
        hombres = grupo['hombres']
        mujeres = grupo['mujeres']
        cantidad = hombres + mujeres
        
        print(f"  📊 Grupo {min_edad}-{max_edad} años: {hombres}H + {mujeres}M = {cantidad} registros")
        
        # Generar hombres
        for _ in range(hombres):
            sexo = 'M'
            nombre = fake.first_name_male()
            primer_apellido = fake.last_name()
            segundo_apellido = fake.last_name()
            cedula = str(fake.random_number(digits=10, fix_len=True))
            
            # Calcular fecha de nacimiento según edad
            edad = random.randint(min_edad, max_edad)
            fecha_nac = hoy - timedelta(days=edad*365 + random.randint(0, 364))
            
            ciudad_id = random.choice(ciudades_ids)
            eps_id = random.choice(eps_ids)
            hospital_id = random.choice(hospital_ids)
            email = fake.email()
            tel1 = generar_telefono_colombiano()
            tel2 = generar_telefono_colombiano() if random.random() > 0.5 else None
            
            cursor.execute("""
                INSERT INTO paciente 
                (nombre, primer_apellido, segundo_apellido, cedula, fecha_nacimiento, 
                 ciudad_id, eps_id, hospital_id, email, tel1, tel2, sexo)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT DO NOTHING
            """, (nombre, primer_apellido, segundo_apellido, cedula, fecha_nac,
                  ciudad_id, eps_id, hospital_id, email, tel1, tel2, sexo))
            total_insertados += 1
        
        # Generar mujeres
        for _ in range(mujeres):
            sexo = 'F'
            nombre = fake.first_name_female()
            primer_apellido = fake.last_name()
            segundo_apellido = fake.last_name()
            cedula = str(fake.random_number(digits=10, fix_len=True))
            
            # Calcular fecha de nacimiento según edad
            edad = random.randint(min_edad, max_edad)
            fecha_nac = hoy - timedelta(days=edad*365 + random.randint(0, 364))
            
            ciudad_id = random.choice(ciudades_ids)
            eps_id = random.choice(eps_ids)
            hospital_id = random.choice(hospital_ids)
            email = fake.email()
            tel1 = generar_telefono_colombiano()
            tel2 = generar_telefono_colombiano() if random.random() > 0.5 else None
            
            cursor.execute("""
                INSERT INTO paciente 
                (nombre, primer_apellido, segundo_apellido, cedula, fecha_nacimiento, 
                 ciudad_id, eps_id, hospital_id, email, tel1, tel2, sexo)
                VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s, %s)
                ON CONFLICT DO NOTHING
            """, (nombre, primer_apellido, segundo_apellido, cedula, fecha_nac,
                  ciudad_id, eps_id, hospital_id, email, tel1, tel2, sexo))
            total_insertados += 1
    
    print(f"✅ {total_insertados} pacientes insertados (50 hombres + 50 mujeres)")

# =============================================
# POBLAR TABLA: medico
# =============================================
def poblar_medico(cursor):
    print(f"\n👨‍⚕️ Poblando medico (30 registros: 16 hombres, 14 mujeres)...")
    
    cursor.execute("SELECT especialidad_id FROM especialidad")
    especialidad_ids = [row[0] for row in cursor.fetchall()]
    
    if len(especialidad_ids) < 10:
        print(f"⚠️ ADVERTENCIA: Solo hay {len(especialidad_ids)} especialidades, se requieren mínimo 10")
    
    # Asegurar que al menos 10 especialidades estén representadas
    # Primero asignar 1 médico a cada una de las primeras 10 especialidades
    especialidades_asignadas = []
    
    # Generar 16 hombres
    print("  👨 Generando 16 médicos hombres...")
    for i in range(16):
        codigo = f"MED{i+1:04d}"
        sexo = 'M'
        nombre = fake.name_male()
        
        # Los primeros 5 hombres tienen cada uno una especialidad diferente (de las 10)
        if i < 5 and i < len(especialidad_ids):
            especialidad_id = especialidad_ids[i]
            especialidades_asignadas.append(especialidad_ids[i])
        else:
            especialidad_id = random.choice(especialidad_ids)
        
        telefono = fake.phone_number()
        estado = random.choice([True, True, True, False])  # 75% activos
        
        cursor.execute("""
            INSERT INTO medico (codigo_profesional, nombre, especialidad_id, telefono, estado, sexo)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (codigo, nombre, especialidad_id, telefono, estado, sexo))
    
    # Generar 14 mujeres
    print("  👩 Generando 14 médicas mujeres...")
    for i in range(14):
        codigo = f"MED{i+17:04d}"
        sexo = 'F'
        nombre = fake.name_female()
        
        # Las primeras 5 mujeres tienen cada una una especialidad diferente (de las 10 restantes)
        if i < 5 and (i+5) < len(especialidad_ids):
            especialidad_id = especialidad_ids[i+5]
            especialidades_asignadas.append(especialidad_ids[i+5])
        else:
            especialidad_id = random.choice(especialidad_ids)
        
        telefono = fake.phone_number()
        estado = random.choice([True, True, True, False])  # 75% activos
        
        cursor.execute("""
            INSERT INTO medico (codigo_profesional, nombre, especialidad_id, telefono, estado, sexo)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (codigo, nombre, especialidad_id, telefono, estado, sexo))
    
    # Verificar que tenemos al menos 10 especialidades diferentes
    cursor.execute("""
        SELECT COUNT(DISTINCT especialidad_id) as total_especialidades
        FROM medico
    """)
    total_esp = cursor.fetchone()[0]
    
    print(f"✅ 30 médicos insertados (16 hombres + 14 mujeres)")
    print(f"   📚 {total_esp} especialidades diferentes representadas")
    
    # Mostrar distribución por especialidad y sexo
    cursor.execute("""
        SELECT e.nombre_especialidad, 
               SUM(CASE WHEN m.sexo = 'M' THEN 1 ELSE 0 END) as hombres,
               SUM(CASE WHEN m.sexo = 'F' THEN 1 ELSE 0 END) as mujeres,
               COUNT(*) as total
        FROM medico m
        JOIN especialidad e ON m.especialidad_id = e.especialidad_id
        GROUP BY e.nombre_especialidad
        ORDER BY total DESC, e.nombre_especialidad
    """)
    
    print("\n   📊 Distribución por especialidad:")
    for row in cursor.fetchall():
        esp, h, m, total = row
        print(f"      • {esp}: {h}H + {m}M = {total}")
    print()

# =============================================
# POBLAR TABLA: planta
# =============================================
def poblar_planta(cursor):
    print(f"\n🏢 Poblando planta...")
    
    cursor.execute("SELECT hospital_id FROM hospital")
    hospital_ids = [row[0] for row in cursor.fetchall()]
    
    contador = 0
    for hospital_id in hospital_ids:
        # Cada hospital tiene entre 3 y 8 pisos
        num_pisos = random.randint(3, 8)
        for piso in range(1, num_pisos + 1):
            cursor.execute("""
                INSERT INTO planta (hospital_id, piso)
                VALUES (%s, %s)
            """, (hospital_id, piso))
            contador += 1
    
    print(f"✅ {contador} plantas insertadas")

# =============================================
# POBLAR TABLA: cuarto
# =============================================
def poblar_cuarto(cursor, cuartos_por_planta=10):
    print(f"\n🚪 Poblando cuarto ({cuartos_por_planta} por planta)...")
    
    cursor.execute("SELECT planta_id FROM planta")
    planta_ids = [row[0] for row in cursor.fetchall()]
    
    contador = 0
    for planta_id in planta_ids:
        # Cada planta tiene N cuartos
        for num in range(1, cuartos_por_planta + 1):
            numero = f"{num:03d}"  # 001, 002, 003...
            
            cursor.execute("""
                INSERT INTO cuarto (planta_id, numero_cuarto)
                VALUES (%s, %s)
            """, (planta_id, numero))
            contador += 1
    
    print(f"✅ {contador} cuartos insertados")

# =============================================
# POBLAR TABLA: medico_especialidad
# =============================================
def poblar_medico_especialidad(cursor):
    print(f"\n🔗 Poblando medico_especialidad...")
    
    cursor.execute("SELECT medico_id FROM medico")
    medico_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT especialidad_id FROM especialidad")
    especialidad_ids = [row[0] for row in cursor.fetchall()]
    
    contador = 0
    for medico_id in medico_ids:
        # Cada médico tiene entre 1 y 3 especialidades
        num_especialidades = random.randint(1, 3)
        especialidades_medico = random.sample(especialidad_ids, min(num_especialidades, len(especialidad_ids)))
        
        for especialidad_id in especialidades_medico:
            cursor.execute("""
                INSERT INTO medico_especialidad (medico_id, especialidad_id)
                VALUES (%s, %s)
                ON CONFLICT DO NOTHING
            """, (medico_id, especialidad_id))
            contador += 1
    
    print(f"✅ {contador} relaciones médico-especialidad insertadas")

# =============================================
# POBLAR TABLA: medico_paciente
# =============================================
def poblar_medico_paciente(cursor, asignaciones=100):
    print(f"\n👨‍⚕️👤 Poblando medico_paciente ({asignaciones} asignaciones)...")
    
    cursor.execute("SELECT medico_id FROM medico WHERE estado = TRUE")
    medico_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT id_paciente FROM paciente")
    paciente_ids = [row[0] for row in cursor.fetchall()]
    
    roles = ['médico tratante', 'médico especialista', 'médico de cabecera', 'consultor']
    
    # Crear asignaciones únicas médico-paciente
    asignaciones_hechas = set()
    contador = 0
    
    for _ in range(asignaciones):
        medico_id = random.choice(medico_ids)
        paciente_id = random.choice(paciente_ids)
        
        # Evitar duplicados
        if (medico_id, paciente_id) in asignaciones_hechas:
            continue
        
        asignaciones_hechas.add((medico_id, paciente_id))
        rol = random.choice(roles)
        
        cursor.execute("""
            INSERT INTO medico_paciente (paciente_id, medico_id, rol)
            VALUES (%s, %s, %s)
        """, (paciente_id, medico_id, rol))
        contador += 1
    
    print(f"✅ {contador} asignaciones médico-paciente insertadas")

# =============================================
# POBLAR TABLA: tarjeta_visita
# =============================================
def poblar_tarjeta_visita(cursor, tarjetas_por_paciente=4):
    print(f"\n🎫 Poblando tarjeta_visita ({tarjetas_por_paciente} por paciente)...")
    
    cursor.execute("SELECT id_paciente FROM paciente")
    paciente_ids = [row[0] for row in cursor.fetchall()]
    
    contador = 0
    for paciente_id in paciente_ids:
        # Cada paciente tiene N tarjetas
        for num_tarj in range(1, tarjetas_por_paciente + 1):
            estado = random.choice([True, True, True, False])  # 75% disponibles
            fecha_emision = fecha_aleatoria(datetime(2023, 1, 1), datetime.now())
            
            cursor.execute("""
                INSERT INTO tarjeta_visita (paciente_id, numero_tarj, estado, fecha_emision)
                VALUES (%s, %s, %s, %s)
            """, (paciente_id, num_tarj, estado, fecha_emision))
            contador += 1
    
    print(f"✅ {contador} tarjetas de visita insertadas")

# =============================================
# POBLAR TABLA: visitante
# =============================================
def poblar_visitante(cursor, visitantes_por_paciente=3):
    print(f"\n👥 Poblando visitante ({visitantes_por_paciente} por paciente)...")
    
    cursor.execute("SELECT id_paciente FROM paciente")
    paciente_ids = [row[0] for row in cursor.fetchall()]
    
    contador = 0
    for paciente_id in paciente_ids:
        # Cada paciente tiene N visitantes autorizados
        for num_visitante in range(1, visitantes_por_paciente + 1):
            nombre_completo = fake.name()
            telefono = generar_telefono_colombiano() if random.random() > 0.3 else None
            
            cursor.execute("""
                INSERT INTO visitante (paciente_id, numero_visitante, nombre_completo, telefono)
                VALUES (%s, %s, %s, %s)
            """, (paciente_id, num_visitante, nombre_completo, telefono))
            contador += 1
    
    print(f"✅ {contador} visitantes insertados")

# =============================================
# POBLAR TABLA: asignacion
# =============================================
def poblar_asignacion(cursor, cantidad=40):
    print(f"\n🛏️ Poblando asignacion ({cantidad} asignaciones)...")
    
    cursor.execute("SELECT id_paciente FROM paciente")
    paciente_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT cuarto_id FROM cuarto")
    cuarto_ids = [row[0] for row in cursor.fetchall()]
    
    motivos = [
        'Hospitalización por cirugía',
        'Observación médica',
        'Tratamiento intensivo',
        'Recuperación post-operatoria',
        'Control de enfermedad crónica',
        'Urgencia médica'
    ]
    
    for _ in range(min(cantidad, len(paciente_ids))):
        paciente_id = random.choice(paciente_ids)
        cuarto_id = random.choice(cuarto_ids)
        motivo = random.choice(motivos)
        
        cursor.execute("""
            INSERT INTO asignacion (paciente_id, cuarto_id, motivo_asignacion)
            VALUES (%s, %s, %s)
        """, (paciente_id, cuarto_id, motivo))
    
    print(f"✅ {cantidad} asignaciones de cuarto insertadas")

# =============================================
# POBLAR TABLA: visita
# =============================================
def poblar_visita(cursor, cantidad=60):
    print(f"\n🚶 Poblando visita ({cantidad} visitas)...")
    
    cursor.execute("""
        SELECT v.paciente_id, v.numero_visitante, t.tarjeta_id 
        FROM visitante v
        JOIN tarjeta_visita t ON v.paciente_id = t.paciente_id
        WHERE t.estado = TRUE
    """)
    visitas_posibles = cursor.fetchall()
    
    if not visitas_posibles:
        print("⚠️ No hay visitantes o tarjetas disponibles")
        return
    
    for _ in range(min(cantidad, len(visitas_posibles) * 3)):
        paciente_id, numero_visitante, tarjeta_id = random.choice(visitas_posibles)
        
        # Fecha y hora de visita aleatoria (últimos 6 meses)
        fecha_hora = fecha_aleatoria(
            datetime.now() - timedelta(days=180), 
            datetime.now()
        )
        
        # Agregar hora aleatoria
        fecha_hora = fecha_hora.replace(
            hour=random.randint(8, 20),
            minute=random.randint(0, 59)
        )
        
        observaciones = None
        if random.random() > 0.7:  # 30% tienen observaciones
            observaciones = random.choice([
                'Visita familiar regular',
                'Visitante trajo artículos personales',
                'Visita breve por restricciones',
                'Acompañamiento en recuperación',
                'Visita de familiar cercano'
            ])
        
        cursor.execute("""
            INSERT INTO visita (paciente_id, numero_visitante, tarjeta_id, fecha_hora, observaciones)
            VALUES (%s, %s, %s, %s, %s)
        """, (paciente_id, numero_visitante, tarjeta_id, fecha_hora, observaciones))
    
    cursor.execute("SELECT COUNT(*) FROM visita")
    total = cursor.fetchone()[0]
    print(f"✅ {total} visitas insertadas")

    # =============================================
# POBLAR TABLA: enfermera
# =============================================
def poblar_enfermera(cursor):
    print(f"\n👩‍⚕️ Poblando enfermera (10 registros: 8 mujeres, 2 hombres)...")
    
    cursor.execute("SELECT hospital_id FROM hospital")
    hospital_ids = [row[0] for row in cursor.fetchall()]
    
    if not hospital_ids:
        print("⚠️ No hay hospitales disponibles")
        return
    
    # Generar 8 enfermeras mujeres
    print("  👩 Generando 8 enfermeras mujeres...")
    for i in range(8):
        codigo = f"ENF{i+1:04d}"
        sexo = 'F'
        nombre = fake.name_female()
        telefono = generar_telefono_colombiano()
        hospital_id = random.choice(hospital_ids)
        estado = random.choice([True, True, True, False])  # 75% activas
        
        cursor.execute("""
            INSERT INTO enfermera (codigo_profesional, nombre, telefono, hospital_id, sexo, estado)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (codigo, nombre, telefono, hospital_id, sexo, estado))
    
    # Generar 2 enfermeros hombres
    print("  👨 Generando 2 enfermeros hombres...")
    for i in range(2):
        codigo = f"ENF{i+9:04d}"
        sexo = 'M'
        nombre = fake.name_male()
        telefono = generar_telefono_colombiano()
        hospital_id = random.choice(hospital_ids)
        estado = random.choice([True, True, True, False])  # 75% activos
        
        cursor.execute("""
            INSERT INTO enfermera (codigo_profesional, nombre, telefono, hospital_id, sexo, estado)
            VALUES (%s, %s, %s, %s, %s, %s)
        """, (codigo, nombre, telefono, hospital_id, sexo, estado))
    
    print(f"✅ 10 enfermeras insertadas (8 mujeres + 2 hombres)")


    # =============================================
# POBLAR TABLA: enfermera_paciente
# =============================================
def poblar_enfermera_paciente(cursor):
    print(f"\n💉 Poblando enfermera_paciente (todos los 100 pacientes)...")
    
    cursor.execute("SELECT enfermera_id FROM enfermera WHERE estado = TRUE")
    enfermera_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT id_paciente FROM paciente ORDER BY id_paciente")
    paciente_ids = [row[0] for row in cursor.fetchall()]
    
    if not enfermera_ids or not paciente_ids:
        print("⚠️ No hay enfermeras o pacientes disponibles")
        return
    
    print(f"   ✓ {len(enfermera_ids)} enfermeras activas para {len(paciente_ids)} pacientes")
    
    turnos = ['mañana', 'tarde', 'noche']
    contador = 0
    
    # PASO 1: Asignar UNA enfermera a CADA paciente (100 asignaciones obligatorias)
    print(f"   📋 Asignando 1 enfermera a cada paciente...")
    for paciente_id in paciente_ids:
        enfermera_id = random.choice(enfermera_ids)
        turno = random.choice(turnos)
        
        # Fecha de asignación aleatoria (últimos 6 meses)
        fecha_asignacion = fecha_aleatoria(
            datetime.now() - timedelta(days=180),
            datetime.now()
        )
        
        cursor.execute("""
            INSERT INTO enfermera_paciente (enfermera_id, paciente_id, fecha_asignacion, turno)
            VALUES (%s, %s, %s, %s)
        """, (enfermera_id, paciente_id, fecha_asignacion, turno))
        contador += 1
    
    print(f"   ✓ {contador} asignaciones base completadas (1 por paciente)")
    
    # PASO 2: Asignar enfermeras ADICIONALES a algunos pacientes (pacientes con múltiples turnos)
    print(f"   📋 Asignando enfermeras adicionales a pacientes críticos...")
    
    # 20% de pacientes tienen 2 enfermeras (diferentes turnos)
    pacientes_con_doble = random.sample(paciente_ids, k=20)
    adicionales = 0
    
    for paciente_id in pacientes_con_doble:
        # Seleccionar una enfermera diferente para turno distinto
        enfermera_id = random.choice(enfermera_ids)
        
        # Buscar qué turnos ya tiene este paciente
        cursor.execute("""
            SELECT turno FROM enfermera_paciente 
            WHERE paciente_id = %s
        """, (paciente_id,))
        turnos_asignados = [row[0] for row in cursor.fetchall()]
        turnos_disponibles = [t for t in turnos if t not in turnos_asignados]
        
        if turnos_disponibles:
            turno = random.choice(turnos_disponibles)
            fecha_asignacion = fecha_aleatoria(
                datetime.now() - timedelta(days=180),
                datetime.now()
            )
            
            cursor.execute("""
                INSERT INTO enfermera_paciente (enfermera_id, paciente_id, fecha_asignacion, turno)
                VALUES (%s, %s, %s, %s)
                ON CONFLICT DO NOTHING
            """, (enfermera_id, paciente_id, fecha_asignacion, turno))
            adicionales += 1
    
    print(f"✅ {contador + adicionales} asignaciones enfermera-paciente insertadas")
    print(f"   📊 100 pacientes con al menos 1 enfermera + {adicionales} asignaciones adicionales")

# =============================================
# POBLAR TABLA: hospitalizaciones
# =============================================
def poblar_hospitalizaciones(cursor):
    print(f"\n🏥 Poblando hospitalizaciones (103 hospitalizaciones distribuidas)...")
    
    # Obtener todos los pacientes con su sexo
    cursor.execute("""
        SELECT p.id_paciente, p.sexo
        FROM paciente p
        ORDER BY p.id_paciente
    """)
    pacientes = cursor.fetchall()
    
    if len(pacientes) < 80:
        print(f"⚠️ Se necesitan al menos 80 pacientes, solo hay {len(pacientes)}")
        return
    
    # Separar por sexo
    pacientes_h = [p for p in pacientes if p[1] == 'M']
    pacientes_m = [p for p in pacientes if p[1] == 'F']
    
    print(f"   👥 Pacientes disponibles: {len(pacientes_h)} hombres, {len(pacientes_m)} mujeres")
    
    # Definir distribución de hospitalizaciones
    distribuciones = []
    
    # 64 pacientes con 1 hospitalización (32H + 32M)
    for paciente_id, _ in pacientes_h[:32]:
        distribuciones.append({'paciente_id': paciente_id, 'num_atenciones': 1, 'sexo': 'M'})
    for paciente_id, _ in pacientes_m[:32]:
        distribuciones.append({'paciente_id': paciente_id, 'num_atenciones': 1, 'sexo': 'F'})
    
    # 10 pacientes con 2 hospitalizaciones (5H + 5M) = 20 registros
    for paciente_id, _ in pacientes_h[32:37]:
        distribuciones.append({'paciente_id': paciente_id, 'num_atenciones': 2, 'sexo': 'M'})
    for paciente_id, _ in pacientes_m[32:37]:
        distribuciones.append({'paciente_id': paciente_id, 'num_atenciones': 2, 'sexo': 'F'})
    
    # 5 pacientes con 3 hospitalizaciones (3H + 2M) = 15 registros
    for paciente_id, _ in pacientes_h[37:40]:
        distribuciones.append({'paciente_id': paciente_id, 'num_atenciones': 3, 'sexo': 'M'})
    for paciente_id, _ in pacientes_m[37:39]:
        distribuciones.append({'paciente_id': paciente_id, 'num_atenciones': 3, 'sexo': 'F'})
    
    # 1 paciente con 4 hospitalizaciones (1M) = 4 registros
    if len(pacientes_m) > 39:
        distribuciones.append({'paciente_id': pacientes_m[39][0], 'num_atenciones': 4, 'sexo': 'F'})
    
    print(f"   📋 Distribución planificada:")
    print(f"      • 64 pacientes × 1 atención = 64 registros")
    print(f"      • 10 pacientes × 2 atenciones = 20 registros (5H + 5M)")
    print(f"      • 5 pacientes × 3 atenciones = 15 registros (3H + 2M)")
    print(f"      • 1 paciente × 4 atenciones = 4 registros (1M)")
    print(f"      • TOTAL: 80 pacientes = 103 registros de atención")
    
    # Obtener relaciones medico_paciente
    cursor.execute("""
        SELECT mp.medico_paciente_id, mp.paciente_id
        FROM medico_paciente mp
    """)
    medico_paciente_dict = {}
    for mp_id, pac_id in cursor.fetchall():
        if pac_id not in medico_paciente_dict:
            medico_paciente_dict[pac_id] = []
        medico_paciente_dict[pac_id].append(mp_id)
    
    # Tipos de atención (mix realista para hospitalizaciones)
    tipos_hospitalizacion = ['hospitalización', 'urgencia', 'internación']
    
    contador = 0
    contador_por_tipo = {}
    
    # Generar atenciones según la distribución
    for dist in distribuciones:
        paciente_id = dist['paciente_id']
        num_atenciones = dist['num_atenciones']
        
        # Verificar si hay medico_paciente para este paciente
        if paciente_id not in medico_paciente_dict:
            # Crear relación médico-paciente si no existe
            cursor.execute("SELECT medico_id FROM medico WHERE estado = TRUE LIMIT 1")
            medico_result = cursor.fetchone()
            if medico_result:
                cursor.execute("""
                    INSERT INTO medico_paciente (paciente_id, medico_id, rol)
                    VALUES (%s, %s, %s)
                    RETURNING medico_paciente_id
                """, (paciente_id, medico_result[0], 'médico tratante'))
                mp_id = cursor.fetchone()[0]
                medico_paciente_dict[paciente_id] = [mp_id]
            else:
                continue
        
        # Generar las N atenciones para este paciente
        for i in range(num_atenciones):
            medico_paciente_id = random.choice(medico_paciente_dict[paciente_id])
            
            # Fecha y hora de atención (últimos 12 meses)
            fecha_hora = fecha_aleatoria(
                datetime.now() - timedelta(days=365),
                datetime.now()
            )
            fecha_hora = fecha_hora.replace(
                hour=random.randint(0, 23),
                minute=random.choice([0, 15, 30, 45])
            )
            
            # Tipo de atención (mix realista)
            tipo = random.choice(tipos_hospitalizacion)
            
            cursor.execute("""
                INSERT INTO hospitalizaciones (medico_paciente_id, fecha_hora, tipo)
                VALUES (%s, %s, %s)
            """, (medico_paciente_id, fecha_hora, tipo))
            
            contador += 1
            contador_por_tipo[tipo] = contador_por_tipo.get(tipo, 0) + 1
    
    print(f"\n✅ {contador} hospitalizaciones insertadas")
    print(f"   📊 Distribución por tipo:")
    for tipo, cantidad in sorted(contador_por_tipo.items()):
        print(f"      • {tipo}: {cantidad} hospitalizaciones")

# =============================================
# POBLAR TABLA: diagnostico_paciente
# =============================================
def poblar_diagnostico_paciente(cursor):
    print(f"\n🔬 Poblando diagnostico_paciente...")
    
    cursor.execute("SELECT hospitalizacion_id FROM hospitalizaciones")
    hospitalizacion_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT diag_id FROM diagnostico")
    diagnostico_ids = [row[0] for row in cursor.fetchall()]
    
    if not hospitalizacion_ids or not diagnostico_ids:
        print("⚠️ No hay hospitalizaciones o diagnósticos disponibles")
        return
    
    descripciones = [
        'Paciente presenta síntomas leves',
        'Cuadro clínico compatible con diagnóstico',
        'Requiere seguimiento médico',
        'Paciente estable, continuar tratamiento',
        'Se recomienda exámenes complementarios',
        None  # Algunas no tienen descripción
    ]
    
    contador = 0
    for hospitalizacion_id in hospitalizacion_ids:
        # Cada hospitalización tiene entre 1 y 2 diagnósticos
        num_diagnosticos = random.randint(1, 2)
        diagnosticos_hospitalizacion = random.sample(diagnostico_ids, min(num_diagnosticos, len(diagnostico_ids)))
        
        for diag_id in diagnosticos_hospitalizacion:
            descripcion = random.choice(descripciones)
            
            cursor.execute("""
                INSERT INTO diagnostico_paciente (hospitalizacion_id, diag_id, descripcion)
                VALUES (%s, %s, %s)
            """, (hospitalizacion_id, diag_id, descripcion))
            contador += 1
    
    print(f"✅ {contador} diagnósticos de paciente insertados")

# =============================================
# POBLAR TABLA: diagnostico_medico
# =============================================
def poblar_diagnostico_medico(cursor):
    print(f"\n👨‍⚕️🔬 Poblando diagnostico_medico...")
    
    cursor.execute("SELECT diag_paciente_id FROM diagnostico_paciente")
    diag_paciente_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT medico_id FROM medico WHERE estado = TRUE")
    medico_ids = [row[0] for row in cursor.fetchall()]
    
    if not diag_paciente_ids or not medico_ids:
        print("⚠️ No hay diagnósticos de paciente o médicos disponibles")
        return
    
    roles = ['diagnosticador', 'confirmador', 'consultor', 'revisor']
    
    contador = 0
    for diag_paciente_id in diag_paciente_ids:
        # Cada diagnóstico tiene 1-2 médicos responsables
        num_medicos = random.randint(1, 2)
        medicos_diag = random.sample(medico_ids, min(num_medicos, len(medico_ids)))
        
        for i, medico_id in enumerate(medicos_diag):
            rol = roles[i] if i < len(roles) else random.choice(roles)
            
            cursor.execute("""
                INSERT INTO diagnostico_medico (diag_paciente_id, medico_id, rol)
                VALUES (%s, %s, %s)
            """, (diag_paciente_id, medico_id, rol))
            contador += 1
    
    print(f"✅ {contador} relaciones diagnóstico-médico insertadas")

# =============================================
# POBLAR TABLA: tratamiento_paciente
# =============================================
def poblar_tratamiento_paciente(cursor):
    print(f"\n💊 Poblando tratamiento_paciente...")
    
    cursor.execute("""
        SELECT dp.diag_paciente_id, h.medico_paciente_id
        FROM diagnostico_paciente dp
        JOIN hospitalizaciones h ON dp.hospitalizacion_id = h.hospitalizacion_id
    """)
    diagnosticos_con_paciente = cursor.fetchall()
    
    cursor.execute("SELECT trat_id FROM tratamiento")
    tratamiento_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT diag_medico FROM diagnostico_medico")
    diag_medico_ids = [row[0] for row in cursor.fetchall()]
    
    if not diagnosticos_con_paciente or not tratamiento_ids or not diag_medico_ids:
        print("⚠️ Faltan datos necesarios para tratamiento_paciente")
        return
    
    descripciones = [
        'Tratamiento ambulatorio',
        'Requiere hospitalización',
        'Tratamiento domiciliario con seguimiento',
        'Terapia intensiva por 7 días',
        'Seguimiento quincenal',
        None
    ]
    
    contador = 0
    for diag_paciente_id, medico_paciente_id in diagnosticos_con_paciente:
        # 70% de diagnósticos tienen tratamiento
        if random.random() > 0.3:
            # Obtener paciente_id del medico_paciente_id
            cursor.execute("SELECT paciente_id FROM medico_paciente WHERE medico_paciente_id = %s", (medico_paciente_id,))
            result = cursor.fetchone()
            if not result:
                continue
            paciente_id = result[0]
            
            trat_id = random.choice(tratamiento_ids)
            diag_medico = random.choice(diag_medico_ids)
            
            fecha_inicio = fecha_aleatoria(
                datetime.now() - timedelta(days=180),
                datetime.now()
            )
            
            # 60% tienen fecha_fin
            fecha_fin = None
            if random.random() > 0.4:
                fecha_fin = fecha_inicio + timedelta(days=random.randint(7, 90))
            
            descripcion = random.choice(descripciones)
            
            cursor.execute("""
                INSERT INTO tratamiento_paciente 
                (paciente_id, trat_id, diag_medico, fecha_inicio, fecha_fin, descripcion)
                VALUES (%s, %s, %s, %s, %s, %s)
            """, (paciente_id, trat_id, diag_medico, fecha_inicio, fecha_fin, descripcion))
            contador += 1
    
    print(f"✅ {contador} tratamientos de paciente insertados")

# =============================================
# POBLAR TABLA: tratamiento_medicamento
# =============================================
def poblar_tratamiento_medicamento(cursor):
    print(f"\n💉 Poblando tratamiento_medicamento...")
    
    cursor.execute("SELECT paciente_trat_id FROM tratamiento_paciente")
    tratamiento_paciente_ids = [row[0] for row in cursor.fetchall()]
    
    cursor.execute("SELECT medicina_id, dosis_estandar FROM medicamento")
    medicamentos = cursor.fetchall()
    
    if not tratamiento_paciente_ids or not medicamentos:
        print("⚠️ No hay tratamientos de paciente o medicamentos disponibles")
        return
    
    dosis_personalizadas = [
        '500mg cada 8 horas por 7 días',
        '1 tableta cada 12 horas',
        '20mg diarios en ayunas',
        '2 puff cada 6 horas si hay síntomas',
        '850mg cada 12 horas con las comidas',
        '1 ampolla intramuscular cada 24 horas',
    ]
    
    contador = 0
    for paciente_trat_id in tratamiento_paciente_ids:
        # Cada tratamiento tiene entre 1 y 4 medicamentos
        num_medicamentos = random.randint(1, 4)
        medicamentos_tratamiento = random.sample(medicamentos, min(num_medicamentos, len(medicamentos)))
        
        for medicina_id, dosis_estandar in medicamentos_tratamiento:
            # 70% usa dosis estándar, 30% personalizada
            if random.random() > 0.3 and dosis_estandar:
                desc_dosis = dosis_estandar
            else:
                desc_dosis = random.choice(dosis_personalizadas)
            
            cursor.execute("""
                INSERT INTO tratamiento_medicamento (paciente_trat_id, medicina_id, desc_dosis)
                VALUES (%s, %s, %s)
            """, (paciente_trat_id, medicina_id, desc_dosis))
            contador += 1
    
    print(f"✅ {contador} medicamentos por tratamiento insertados")

# =============================================
# FUNCIÓN PRINCIPAL
# =============================================
def main():
    print("=" * 50)
    print("🚀 INICIANDO POBLACIÓN DE BASE DE DATOS")
    print("=" * 50)
    
    conn = conectar_db()
    if not conn:
        return
    
    try:
        cursor = conn.cursor()
        
        # POBLAR EN ORDEN (puedes editar las cantidades)
        poblar_ciudad_pais(cursor, cantidad=15)
        poblar_eps(cursor, cantidad=10)
        poblar_especialidad(cursor, cantidad=15)
        poblar_diagnostico(cursor, cantidad=25)
        poblar_tratamiento(cursor, cantidad=20)
        poblar_medicamento(cursor, cantidad=25)
        
        poblar_hospital(cursor, cantidad=15)
        poblar_paciente(cursor)
        poblar_medico(cursor)  # Ahora sin parámetro cantidad
        
        poblar_planta(cursor)
        poblar_cuarto(cursor, cuartos_por_planta=10)
        poblar_medico_especialidad(cursor)
        poblar_medico_paciente(cursor, asignaciones=100)
        poblar_tarjeta_visita(cursor, tarjetas_por_paciente=4)
        poblar_visitante(cursor, visitantes_por_paciente=3)
        poblar_asignacion(cursor, cantidad=50)
        poblar_visita(cursor, cantidad=80)
        poblar_enfermera(cursor)
        poblar_enfermera_paciente(cursor)
        poblar_hospitalizaciones(cursor)  # Ahora sin parámetro cantidad
        poblar_diagnostico_paciente(cursor)
        poblar_diagnostico_medico(cursor)
        poblar_tratamiento_paciente(cursor)
        poblar_tratamiento_medicamento(cursor)
        
        # AGREGAR MÁS FUNCIONES AQUÍ...
        
        # Confirmar cambios
        conn.commit()
        print("\n" + "=" * 50)
        print("✅ BASE DE DATOS POBLADA EXITOSAMENTE")
        print("=" * 50)
        
    except Exception as e:
        conn.rollback()
        print(f"\n❌ Error durante la población: {e}")
    
    finally:
        cursor.close()
        conn.close()
        print("\n🔌 Conexión cerrada")

# =============================================
# EJECUTAR SCRIPT
# =============================================
if __name__ == "__main__":
    main()