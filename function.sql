-- Реалізовуємо за допомогою функції обробки помилки NULL EXCEPTION за запитом:

-- Середня кількість замовлень на столик
SELECT t.table_id, t.seats,
       COUNT(o.order_id) as total_orders,
       ROUND(COUNT(o.order_id)::decimal / 
             (SELECT COUNT(DISTINCT DATE(created_at)) FROM orders WHERE table_id = t.table_id), 2) 
       as avg_orders_per_day
FROM tables t
LEFT JOIN orders o ON t.table_id = o.table_id
GROUP BY t.table_id, t.seats
ORDER BY avg_orders_per_day DESC;

CREATE OR REPLACE FUNCTION get_table_stats()
RETURNS TABLE (
    table_id INT,
    seats INT,
    total_orders BIGINT,
    avg_orders_per_day NUMERIC
) AS $$
BEGIN
    RETURN QUERY
    SELECT
        t.table_id,
        t.seats,
        COUNT(o.order_id) AS total_orders,
        ROUND(
            COUNT(o.order_id)::NUMERIC /
            (SELECT COUNT(DISTINCT DATE(created_at)) FROM orders WHERE orders.table_id = t.table_id), 2
        ) AS avg_orders_per_day
    FROM
        tables t
    LEFT JOIN
        orders o ON t.table_id = o.table_id
    GROUP BY
        t.table_id, t.seats
    ORDER BY
        avg_orders_per_day DESC;
EXCEPTION
    WHEN division_by_zero THEN
        RETURN QUERY
        SELECT
            t.table_id,
            t.seats,
            COUNT(o.order_id) AS total_orders,
            0::NUMERIC AS avg_orders_per_day
        FROM
            tables t
        LEFT JOIN
            orders o ON t.table_id = o.table_id
        GROUP BY
            t.table_id, t.seats
        ORDER BY
            avg_orders_per_day DESC;
END;
$$ LANGUAGE plpgsql;


SELECT * FROM get_table_stats();