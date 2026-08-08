-- Migration 004: Create function to calculate a work order's total cost
-- Sums line_total (quantity * unit_price) across all items for a given work order

CREATE OR REPLACE FUNCTION calculate_work_order_total(p_work_order_id INT)
RETURNS DECIMAL(10,2)
LANGUAGE sql
AS $$
    SELECT COALESCE(SUM(line_total), 0)::DECIMAL(10,2)
    FROM work_order_items
    WHERE work_order_id = p_work_order_id;
$$;

-- Usage example:
-- SELECT calculate_work_order_total(1);
--
-- Optionally keep work_orders.total_cost in sync:
-- UPDATE work_orders
-- SET total_cost = calculate_work_order_total(work_order_id)
-- WHERE work_order_id = 1;

-- Rollback
-- DROP FUNCTION calculate_work_order_total;