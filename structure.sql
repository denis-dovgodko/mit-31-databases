SELECT 'CREATE DATABASE cafe;'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'cafe')\gexec

\c cafe;

DROP ROLE IF EXISTS admin, waiter, manager, kitchen, cashier;

CREATE ROLE admin WITH LOGIN PASSWORD 'admin_passwd';
CREATE ROLE waiter WITH LOGIN PASSWORD 'waiter_passwd';
CREATE ROLE manager WITH LOGIN PASSWORD 'manager_passwd';
CREATE ROLE kitchen WITH LOGIN PASSWORD 'kitchen_passwd';
CREATE ROLE cashier WITH LOGIN PASSWORD 'cashier_passwd';

CREATE TABLE IF NOT EXISTS tables(
    table_id SERIAL PRIMARY KEY,
    seats INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Available', 'Taken')) DEFAULT 'Available'
);

CREATE TABLE IF NOT EXISTS reservations(
    reservation_id SERIAL PRIMARY KEY,
    table_id INT REFERENCES tables(table_id),
    customer_name VARCHAR(100) NOT NULL,
    phone_number VARCHAR(20),
    reservation_time TIMESTAMP NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS menu_items(
    item_id SERIAL PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description TEXT,
    price DECIMAL(5,2) NOT NULL,
    is_available BOOLEAN DEFAULT true
);

CREATE TABLE IF NOT EXISTS orders(
    order_id SERIAL PRIMARY KEY,
    table_id INT REFERENCES tables(table_id),
    item_id INT REFERENCES menu_items(item_id),
    quantity INT NOT NULL,
    status VARCHAR(20) CHECK (status IN ('New', 'Pending', 'Ready', 'Done')) DEFAULT 'New',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS bills(
    bill_id SERIAL PRIMARY KEY,
    table_id INT REFERENCES tables(table_id),
    total_amount DECIMAL(10,2) NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Paid')) DEFAULT 'Pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS completed_orders(
    completed_order_id SERIAL PRIMARY KEY,
    bill_id INT REFERENCES bills(bill_id),
    item_id INT REFERENCES menu_items(item_id),
    quantity INT NOT NULL,
    price_at_time DECIMAL(5,2) NOT NULL,
    completed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);


GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO admin;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO admin;

GRANT SELECT, UPDATE ON tables TO waiter;
GRANT SELECT, INSERT ON orders TO waiter;
GRANT SELECT ON menu_items, reservations, bills TO waiter;

GRANT SELECT, INSERT, UPDATE ON tables TO manager;
GRANT ALL PRIVILEGES ON reservations TO manager;
GRANT SELECT ON menu_items, orders, bills, completed_orders TO manager;

GRANT SELECT ON orders, menu_items TO kitchen;
GRANT UPDATE ON orders TO kitchen; 

GRANT SELECT ON orders, tables, menu_items TO cashier;
GRANT SELECT, INSERT, UPDATE ON bills TO cashier;
GRANT SELECT, INSERT ON completed_orders TO cashier;

GRANT USAGE ON ALL SEQUENCES IN SCHEMA public TO waiter, manager, kitchen, cashier;
