# Dominio de negocio

El dominio de negocio corresponde a un taller de reparación y mantenimiento de vehículos, encargado de gestionar la información de sus clientes, vehículos, empleados, servicios y repuestos. El sistema permite mantener un registro de los vehículos asociados a cada cliente y administrar el catálogo de servicios y las piezas disponibles en inventario, facilitando el control de las actividades realizadas por el taller.

El proceso principal se centra en las órdenes de trabajo, mediante las cuales se registra la atención realizada a un vehículo. Cada orden puede ser asignada a un empleado y contiene los diferentes servicios y repuestos utilizados, junto con sus cantidades y precios. De esta manera, el modelo permite realizar un seguimiento de cada reparación desde su apertura hasta su cierre, incluyendo el estado de la orden y el costo total de los trabajos realizados.

# Diagrama de dominio

```mermaid
erDiagram
    CUSTOMERS ||--o{ VEHICLES : owns
    VEHICLES ||--o{ WORK_ORDERS : has
    EMPLOYEES ||--o{ WORK_ORDERS : assigned_to
    WORK_ORDERS ||--o{ WORK_ORDER_ITEMS : contains
    SERVICES ||--o{ WORK_ORDER_ITEMS : includes
    PARTS ||--o{ WORK_ORDER_ITEMS : uses

    CUSTOMERS {
        INT customer_id PK
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR phone
        VARCHAR email
        VARCHAR address
        TIMESTAMP created_at
    }

    VEHICLES {
        INT vehicle_id PK
        INT customer_id FK
        VARCHAR vin UK
        VARCHAR make
        VARCHAR model
        SMALLINT year
        VARCHAR license_plate
        INT mileage
    }

    EMPLOYEES {
        INT employee_id PK
        VARCHAR first_name
        VARCHAR last_name
        VARCHAR role
        VARCHAR phone
        DATE hire_date
        DECIMAL hourly_rate
    }

    SERVICES {
        INT service_id PK
        VARCHAR service_name
        TEXT description
        DECIMAL standard_price
        DECIMAL estimated_hours
    }

    PARTS {
        INT part_id PK
        VARCHAR part_name
        VARCHAR part_number UK
        DECIMAL unit_price
        INT quantity_in_stock
        VARCHAR supplier
    }

    WORK_ORDERS {
        INT work_order_id PK
        INT vehicle_id FK
        INT employee_id FK
        VARCHAR status
        TIMESTAMP date_opened
        TIMESTAMP date_closed
        DECIMAL total_cost
        TEXT notes
    }

    WORK_ORDER_ITEMS {
        INT item_id PK
        INT work_order_id FK
        INT service_id FK
        INT part_id FK
        INT quantity
        DECIMAL unit_price
        DECIMAL line_total
    }