USE WAREHOUSE WH_DATAOPS;
USE DATABASE DATAOPS_COURSE;
USE SCHEMA PROVIDERS;


GRANT EXECUTE TASK ON ACCOUNT TO ROLE DATAOPS_LOADER;


CREATE OR REPLACE TASK TASK_INGEST_S3
    WAREHOUSE = WH_DATAOPS
    SCHEDULE = 'USING CRON 0 * * * * America/Bogota'
AS
    COPY INTO RAW_PROVIDERS (raw_data, _stg_file_name, _stg_loaded_at)
    FROM (
        SELECT $1, METADATA$FILENAME, CURRENT_TIMESTAMP()
        FROM @stg_providers_s3
    )
    FILE_FORMAT = (FORMAT_NAME = ff_providers_json);


CREATE OR REPLACE TASK TASK_FLATTEN_PROVIDERS
    WAREHOUSE= WH_DATAOPS
    AFTER TASK_INGEST_S3
AS
    INSERT OVERWRITE INTO STG_PROVIDERS_FLATTENED (
        provider_id, provider_name, part_id, name_part, category_part, cost_part,
        inventory, total_quantity, minimun_stock, warranty_months, lead_time_days,
        contact_name, contact_role, email, phone
    )
    SELECT
        raw_data:provider_id::STRING,
        raw_data:provider_name::STRING,
        raw_data:part_id::STRING,
        raw_data:name_part::STRING,
        raw_data:category_part::STRING,
        raw_data:cost_part::FLOAT,
        c.value:inventory::STRING,
        c.value:total_quantity::INTEGER,
        c.value:minimun_stock::INTEGER,
        c.value:warranty_months::INTEGER,
        c.value:lead_time_days::INTEGER,
        c.value:contact_name::STRING,
        c.value:contact_role::STRING,
        c.value:email::STRING,
        c.value:phone::STRING,
    FROM RAW_PROVIDERS,
         LATERAL FLATTEN(input => raw_data:providers_contacts) c;


SHOW TASKS

-- ALTER TASK TASK_INGEST_S3 RESUME
-- ALTER TASK TASK_FLATTEN_PROVIDERS RESUME
