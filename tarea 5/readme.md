## Base de Datos I | Desarrollo de Software | ET-0057 | Grupo 811 | TIA 05 | Grupo 05

### Institución Universitaria Pascual Bravo
------
### Arquitectura de una base de datos para el servicio de Hospitalización del Sistema de Salud del Departamento de Antioquia, Colombia
------
###  **Contexto:**

La Secretaría de Salud de la Gobernación de Antioquia proyecta una licitación para optimizar los servicios de hospitalización dentro de la Red de Atención en Salud del departamento. Para ello, se requiere inicialmente un sistema de información web que gestione la atención e información básica del servicio de hospitalización y que, a futuro, se integre con un Sistema de Historia Clínica Electrónica más amplio. Este proceso exige la construcción de una base de datos que cumpla con los requerimientos técnicos, funcionales y normativos de la Secretaría.
Además, esta base de datos debe cumplir con las propiedades ACID (Atomicidad, Consistencia, Aislamiento y Durabilidad), fundamentales para garantizar integridad, fiabilidad y robustez transaccional dentro de cualquier Sistema de Gestión de Base de Datos (SGBD).

------
### **Objetivo**

Diseñar, construir, poblar, consultar y validar una base de datos robusta, flexible y segura para almacenar y monitorear la información de hospitalización de la Red de Salud del Departamento de Antioquia, integrada a un sistema de Historia Clínica Electrónica departamental.

----
### **Fases del Proyecto**

**TIA 5 – Implementación Base de Datos: Modelo Físico (DDL)**  

● Antes de construir el Diccionario de Datos Físico, se deben:  
● Corregir el Diagrama de Entidad-Relación (Chen).  
● Revisar el proceso de Normalización.  
● Asegurar que las tablas resultantes de la normalización estén reflejadas en el Modelo Físico.  

**Construcción del Modelo Físico:**   

Incluye:  
  
*● Inventario de tablas definitivo.  
● Elaboración del Diccionario de Datos Físico. Las tablas deben conservar exactamente los nombres derivados del modelo conceptual-lógico.  
● Scripts DDL con:   
● Claves primarias y foráneas   
● Índices    
● Restricciones (NOT NULL, PK, FK, UK, CHECK)  
● Orden correcto de creación:  
● Primero las tablas independientes.  
● Luego las tablas dependientes.   
● Scripts de modificación de tablas (ALTER TABLE).*   
 
## **Requerimientos**  
1. Requerimiento General   
● *Crear el Diccionario de Datos Físico de la base de datos del servicio de Hospitalización integrada a la Historia Clínica Electrónica del departamento.*    
● *El modelo conceptual y lógico ya ha sido elaborado; ahora se debe implementar la base de datos física en un SGBD PostgreSQL.*     
  
      ###   Nombrbe de base de datos "hce_antioquia"   

---
**2. Requerimientos Específicos**   
  
● Corrección del Diagrama ER de Chen.  
● Revisión del proceso de Normalización y coherencia con el modelo final.  
● Construcción del Diccionario de Datos Físico incluyendo: PK, FK, UK, CHECK e índices.   
● Construcción de los Scripts DDL en el orden correcto (tablas independientes → dependientes).   
● Subir todos los productos al repositorio GIT con la estructura exigida.   
● Incluir conclusiones individuales (mínimo 300 palabras por estudiante).   
● Elaboración del video de sustentación mostrando ejecución del código.   
  
----
**3. Requerimientos de Datos**
- La Secretaría entrega 32 datos obligatorios.   
- El equipo debe investigar y agregar 8 datos adicionales.  

**4. Requerimientos de Diseño**
Arquitectura Conceptual. 
Diccionario de Datos Genérico.  

**5. Herramientas Obligatorias**
Draw.io,
Excel,
PostgreSQL 15+,
pgAdmin 4,
Python (opcional).  

-----
**6. Productos a Entregar (Repositorio GIT)**

● Diccionario de Datos Físico.  

● Creación de la base de datos hce_antioquia (scripts DDL).  

● Implementación de reglas y restricciones.  
