
CREATE TYPE order_status AS ENUM ('New', 'Pending', 'Ready', 'Done');
CREATE TYPE table_status AS ENUM ('Available', 'Taken');
CREATE TYPE bill_status AS ENUM ('Pending', 'Paid');

ALTER TABLE orders ADD COLUMN new_status order_status DEFAULT 'New';
ALTER TABLE tables ADD COLUMN new_status table_status DEFAULT 'Available';
ALTER TABLE bills ADD COLUMN new_status bill_status DEFAULT 'Pending';

UPDATE orders SET new_status = status::order_status;
UPDATE tables SET new_status = status::table_status;
UPDATE bills SET new_status = status::bill_status;

ALTER TABLE orders DROP COLUMN status;
ALTER TABLE tables DROP COLUMN status;
ALTER TABLE bills DROP COLUMN status;

ALTER TABLE orders RENAME COLUMN new_status TO status;
ALTER TABLE tables RENAME COLUMN new_status TO status;
ALTER TABLE bills RENAME COLUMN new_status TO status;