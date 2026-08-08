-- Migration 001: Create appointments table
-- Tracks scheduled service appointments before a work order is opened

CREATE TABLE appointments (
    appointment_id  INT PRIMARY KEY AUTO_INCREMENT,
    customer_id     INT NOT NULL,
    vehicle_id      INT NOT NULL,
    employee_id     INT,                     -- assigned advisor/mechanic, optional
    scheduled_at    DATETIME NOT NULL,
    reason          VARCHAR(255),
    status          VARCHAR(20) DEFAULT 'Scheduled',  -- Scheduled, Confirmed, Cancelled, Completed
    created_at      DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
        ON DELETE CASCADE,
    FOREIGN KEY (vehicle_id) REFERENCES vehicles(vehicle_id)
        ON DELETE CASCADE,
    FOREIGN KEY (employee_id) REFERENCES employees(employee_id)
        ON DELETE SET NULL
);

-- Rollback
-- DROP TABLE appointments;