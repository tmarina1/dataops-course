-- Migration 006 (PostgreSQL): Create procedure to insert a new customer

CREATE OR REPLACE PROCEDURE sp_insert_customer (
    p_first_name  VARCHAR(50),
    p_last_name   VARCHAR(50),
    p_phone       VARCHAR(20),
    p_email       VARCHAR(100),
    p_address     VARCHAR(255),
    p_type_client VARCHAR(20),
    INOUT p_customer_id INT DEFAULT NULL
)
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO customers (first_name, last_name, phone, email, address, type_client, created_at)
    VALUES (p_first_name, p_last_name, p_phone, p_email, p_address, p_type_client, NOW())
    RETURNING customer_id INTO p_customer_id;
END;
$$;

-- Usage example:
-- CALL sp_insert_customer('Jane', 'Doe', '555-123-4567', 'jane@example.com', '123 Main St', NULL);

-- Rollback
-- DROP PROCEDURE sp_insert_customer;