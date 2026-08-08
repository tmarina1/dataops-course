-- Migration 003: Add index on work_orders.status
-- Speeds up filtering/reporting on order status (e.g. dashboards showing "Open" or "In Progress" orders)

CREATE INDEX idx_work_orders_status
    ON work_orders (status);

-- Rollback
-- DROP INDEX idx_work_orders_status ON work_orders;
