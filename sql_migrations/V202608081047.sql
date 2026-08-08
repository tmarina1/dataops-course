-- Migration 002: Add warranty_expiry column to work_orders
-- Tracks the date until which the completed repair is under warranty

ALTER TABLE work_orders
    ADD COLUMN warranty_expiry DATE NULL;

-- Rollback
-- ALTER TABLE work_orders DROP COLUMN warranty_expiry;