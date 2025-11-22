# Base de Datos I | Desarrollo de Software | ET-0057 | Grupo 811 | TIA 05 | Grupo 05

## Institución Universitaria Pascual Bravo
------
### Arquitectura de una base de datos para el servicio de Hospitalización del Sistema de Salud del Departamento de Antioquia, Colombia
------
###  **Proyecto General:**     
Arquitectura de una Base de Datos para el Servicio de Hospitalización del Sistema de Salud del Departamento de Antioquia, Colombia   

-----
#### Objetivo General del Proyecto  

Los estudiantes deben diseñar, construir, poblar, consultar y validar una base de datos robusta, flexible y segura que gestione la información del servicio de hospitalización, garantizando su integración con una Historia Clínica Electrónica departamental.   

### **Para ello, se deben completar las siguientes fases académicas:**

● TIA 3: Modelo Lógico   
● TIA 5: Modelo Físico (DDL)   
● TIA 6: Manipulación de Datos (DML)   
● Fase 5: Poblar la base de datos (INSERT)   
● Fase 6: Sistema de consultas (SELECT)   
● Fase 7: Validación de propiedades ACID   

----
## 🧩 Contexto del Proyecto   

La Secretaría de Salud de Antioquia requiere el desarrollo de un sistema que integre la información de hospitalización a un futuro Sistema de Historia Clínica Electrónica.   

**Para esto, la base de datos debe asegurar:*     

● Integridad  
● Seguridad   
● Rendimiento   
● Escalabilidad   
● Cumplimiento de normas técnicas  

---
## 🔐 Propiedades ACID   

-El sistema debe asegurar las siguientes características:   

**Atomicidad (A)**   

● Una transacción se ejecuta completamente o no se ejecuta.   

**Consistencia (C)**   

● La base de datos siempre debe pasar de un estado válido a otro estado válido.   

**Aislamiento (I)**   

● Las transacciones no deben interferir entre sí.    

**Durabilidad (D)**     

● Una vez aplicado un commit, los cambios persisten incluso si hay fallas. 

----
 ## 📌 Requerimiento General    

**Manipulación de la base de datos hce_antioquia mediante comandos DML para poblar, modificar y consultar los datos del sistema hospitalario.*  

-----
 ### 🎯 Requerimientos Específicos        
 
**1. Poblamiento (INSERT)**   

   ● Insertar datos simulados en todas las tablas 👉📂 [Con Python](Poblamiento%20de%datos%con%20Python)    
   ● Mantener coherencia entre FK, PK y restricciones.     
   ● Garantizar integridad referencial.     

**2. Modificación (UPDATE) y eliminación (DELETE)**      

● Actualizar registros específicos.    
● Eliminar información manteniendo las reglas del modelo físico.   

**3. Sistema de Consultas (SELECT)**        

*Debe incluir:*       
 
● Consultas simples  
● Consultas con JOIN  

Uso de:   

● GROUP BY   
● ORDER BY   
● HAVING  
● MAX, MIN, SUM, COUNT, AVG   

**4. Creación de Vistas (VIEW)**  

● Construcción de vistas útiles y coherentes con el modelo.   

**5. Validación ACID**      

*Se debe mostrar:*    

● Transacciones completas   
● Rollback   
● Aislamiento   
● Persistencia   

-----
### 🗂️ Requerimientos de Datos  

● Usar el Diccionario de Datos Físico.   
● Insertar datos simulados coherentes, en todas las tablas.  

🛠️ Herramientas usadas   

●  PostgreSQL 15+,
pgAdmin 4,
Python (opcional),

----
### 📦 Requerimientos de Entrega (Repositorio GIT)     

*El repositorio debe tener:*   

● INSERT de todas las tablas   
● UPDATE y DELETE   
● Consultas SELECT básicas y avanzadas   
● Vistas (VIEW)  
● Validación ACID   
● Código debidamente organizado por TIA o fase   
● Video de sustentación mostrando la ejecución   
