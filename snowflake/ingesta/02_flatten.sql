USE WAREHOUSE WH_DATAOPS;

USE DATABASE DATAOPS_COURSE;

USE SCHEMA PROVIDERS;


-- ============================================================
-- 1. CONSULTAR INFORMACIÓN PRINCIPAL DEL PROVEEDOR Y REPUESTO
-- ============================================================

SELECT
    raw_data:provider_id::STRING          AS provider_id,
    raw_data:provider_name::STRING        AS provider_name,
    raw_data:part_id::STRING              AS part_id,
    raw_data:name_part::STRING            AS name_part,
    raw_data:category_part::STRING        AS category_part,
    raw_data:cost_part::FLOAT             AS cost_part,
    raw_data:inventory::STRING            AS inventory,
    raw_data:total_quantity::INTEGER      AS total_quantity,
    raw_data:minimum_stock::INTEGER       AS minimum_stock,
    raw_data:warranty_months::INTEGER     AS warranty_months,
    raw_data:lead_time_days::INTEGER      AS lead_time_days
FROM RAW_PROVIDERS;


-- ============================================================
-- 2. CONSULTAR LOS CONTACTOS DEL PROVEEDOR
-- ============================================================

SELECT
    raw_data:provider_id::STRING              AS provider_id,
    raw_data:provider_name::STRING            AS provider_name,
    raw_data:part_id::STRING                  AS part_id,
    c.value:contact_name::STRING              AS contact_name,
    c.value:contact_role::STRING              AS contact_role,
    c.value:email::STRING                     AS email,
    c.value:phone::STRING                     AS phone
FROM RAW_PROVIDERS,
     LATERAL FLATTEN(input => raw_data:providers_contacts) c
ORDER BY provider_id;


-- ============================================================
-- 3. CREAR TABLA STAGING CON LA INFORMACIÓN APLANADA
-- ============================================================

CREATE TABLE IF NOT EXISTS STG_PROVIDERS_FLATTENED (

    provider_id               STRING,
    provider_name             STRING,
    part_id                   STRING,
    name_part                 STRING,
    category_part             STRING,
    cost_part                 FLOAT,
    inventory                 STRING,
    total_quantity            INTEGER,
    minimum_stock             INTEGER,
    warranty_months           INTEGER,
    lead_time_days            INTEGER,
    contact_name              STRING,
    contact_role              STRING,
    email                     STRING,
    phone                     STRING,
    _flattened_at             TIMESTAMP_NTZ DEFAULT CURRENT_TIMESTAMP()

);


-- ============================================================
-- 4. LIMPIAR LA TABLA STAGING
-- ============================================================

TRUNCATE TABLE STG_PROVIDERS_FLATTENED;


-- ============================================================
-- 5. INSERTAR DATOS DEL JSON APLANADOS
-- ============================================================

INSERT INTO STG_PROVIDERS_FLATTENED (
    provider_id,
    provider_name,
    part_id,
    name_part,
    category_part,
    cost_part,
    inventory,
    total_quantity,
    minimum_stock,
    warranty_months,
    lead_time_days,
    contact_name,
    contact_role,
    email,
    phone
)

SELECT
    raw_data:provider_id::STRING,
    raw_data:provider_name::STRING,
    raw_data:part_id::STRING,
    raw_data:name_part::STRING,
    raw_data:category_part::STRING,
    raw_data:cost_part::FLOAT,
    raw_data:inventory::STRING,
    raw_data:total_quantity::INTEGER,
    raw_data:minimum_stock::INTEGER,
    raw_data:warranty_months::INTEGER,
    raw_data:lead_time_days::INTEGER,

    c.value:contact_name::STRING,
    c.value:contact_role::STRING,
    c.value:email::STRING,
    c.value:phone::STRING

FROM RAW_PROVIDERS,
     LATERAL FLATTEN(input => raw_data:providers_contacts) c;


-- ============================================================
-- 6. CONSULTAR LA TABLA FINAL
-- ============================================================

SELECT *
FROM STG_PROVIDERS_FLATTENED;