# Documento de decisiones

## 1. Fuente semi-estructurada seleccionada

Para el desarrollo del pipeline de datos se seleccionó como fuente semi-estructurada un conjunto de archivos en formato JSON provenientes de proveedores de repuestos para vehículos. La información contiene datos relacionados con el proveedor, los repuestos ofrecidos, el inventario disponible, la compatibilidad con vehículos y los contactos asociados a cada proveedor.

## 2. Estrategia de roles y acceso

# Estrategia de roles y protección de datos

Para garantizar un acceso seguro a la información se diseñó una estrategia basada en roles, donde cada perfil recibe únicamente los permisos necesarios para realizar sus funciones. El objetivo principal fue aplicar el principio de mínimo privilegio y proteger los datos sensibles de contacto.

Se definieron tres roles principales:

* **ROLE_MECHANICAL_ENGINEER:** corresponde al ingeniero mecánico o responsable técnico encargado de analizar proveedores, repuestos, inventarios, compatibilidad con vehículos, garantías y tiempos de entrega. Este perfil necesita acceso completo a la información técnica y operativa, pero no requiere conocer los datos personales de contacto, por lo que los números telefónicos se presentan completamente ocultos.

* **ROLE_DATA_ANALYST:** corresponde al analista de datos encargado de generar indicadores, reportes y análisis sobre proveedores e inventario. Este rol puede acceder a la información general y visualizar los teléfonos parcialmente enmascarados, permitiendo identificar registros sin exponer completamente los datos sensibles.

* **ROLE_BUSINESS_MANAGER:** corresponde al responsable de compras o relaciones comerciales, cuya función principal es contactar proveedores y gestionar negociaciones. Debido a esta responsabilidad, este rol puede visualizar los números telefónicos completos.

Todos los roles cuentan con permisos de uso sobre el warehouse `WH_DATAOPS`, la base de datos `DATAOPS_COURSE`, el esquema `PROVIDERS` y permisos de lectura sobre la tabla `STG_PROVIDERS_FLATTENED`.

## Política de enmascaramiento

Para proteger la información sensible se implementó una **Masking Policy** en Snowflake sobre la columna `phone`.

La política utiliza la función `CURRENT_ROLE()` para determinar el nivel de acceso:

* **ROLE_BUSINESS_MANAGER:** visualiza el teléfono completo.
* **ROLE_DATA_ANALYST:** visualiza el teléfono parcialmente enmascarado.
* **ROLE_MECHANICAL_ENGINEER:** visualiza el teléfono completamente oculto.

Esta solución permite utilizar una única tabla para diferentes perfiles sin necesidad de duplicar información. El dato permanece almacenado una sola vez, pero su visualización cambia dinámicamente según el rol del usuario que realiza la consulta.

La implementación demuestra cómo Snowflake permite combinar procesamiento de datos semi-estructurados con mecanismos de gobierno y seguridad, garantizando que cada usuario acceda únicamente a la información necesaria para desempeñar sus funciones.
