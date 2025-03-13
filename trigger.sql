CREATE TABLE orders_log (
    log_id SERIAL PRIMARY KEY,
    order_id INT,
    operation VARCHAR(10),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE OR REPLACE FUNCTION log_order_changes() RETURNS TRIGGER AS $$
BEGIN
    INSERT INTO orders_log (order_id, operation)
    VALUES (NEW.order_id, TG_OP);
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER track_order_changes
AFTER INSERT OR UPDATE OR DELETE ON orders
FOR EACH ROW
EXECUTE FUNCTION log_order_changes();
