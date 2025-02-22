-- Вільні столи з 4+ місцями
SELECT *
FROM tables 
WHERE seats > 4 AND status = 'Available'
ORDER BY seats;

-- Поєднуємо резерування, що заплановані пізніше поточного часу, з столами + сортуємо починаючи з найближчого резерву
SELECT r.reservation_id, r.customer_name, r.phone_number, 
       r.reservation_time, t.table_id, t.seats, t.status
FROM reservations r
JOIN tables t ON r.table_id = t.table_id
WHERE r.reservation_time > CURRENT_TIMESTAMP
ORDER BY r.reservation_time;

-- Виводимо всі столи поєднуючи з поточними замовленнями
SELECT t.table_id, t.seats, o.status, COUNT(*) as orders_count
FROM tables t
LEFT JOIN orders o ON t.table_id = o.table_id
GROUP BY t.table_id, t.seats, o.status
ORDER BY t.table_id;

-- Середній чек по кількості місць за столом.
SELECT t.seats, ROUND(AVG(b.total_amount), 2) as avg_bill_amount
FROM tables t
JOIN bills b ON t.table_id = b.table_id
GROUP BY t.seats
HAVING AVG(b.total_amount) > 50
ORDER BY avg_bill_amount DESC;

-- Виводимо об'єднання оплачених рахунків, виконаних замовлень, позицій в меню., 
SELECT b.bill_id, t.table_id, co.item_id, mi.name as item_name,
       co.quantity, co.price_at_time, b.total_amount
FROM bills b
JOIN tables t ON b.table_id = t.table_id
JOIN completed_orders co ON b.bill_id = co.bill_id
JOIN menu_items mi ON co.item_id = mi.item_id
WHERE b.status = 'Paid'
ORDER BY b.created_at DESC;

-- Виводимо столи по рейтингу прибутковості чеків(в порядку спадання)
SELECT t.table_id, t.seats, 
       COUNT(DISTINCT b.bill_id) as total_bills,
       SUM(b.total_amount) as total_sales
FROM tables t
INNER JOIN bills b ON t.table_id = b.table_id
GROUP BY t.table_id, t.seats
ORDER BY total_sales DESC;


-- Виводимо всі замовлення страв в яких статус новий або в процессі очікування, об'єднуючи зі столами та пунктами меню
SELECT o.order_id, t.table_id, mi.name as item_name,
       o.quantity, o.status, o.created_at
FROM orders o
JOIN tables t ON o.table_id = t.table_id
JOIN menu_items mi ON o.item_id = mi.item_id
WHERE o.status IN ('New', 'Pending')
ORDER BY o.created_at;

-- Максимальна та мінімальна кількість місць за столиком
SELECT MIN(seats) as min_seats, MAX(seats) as max_seats FROM tables;

-- Максимальна та мінімальна сума рахунку
SELECT MIN(total_amount) as min_bill, MAX(total_amount) as max_bill FROM bills;

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

-- Кількість замовлень у кожному статусі
SELECT status, COUNT(*) as orders_count 
FROM orders 
GROUP BY status;

-- Кількість бронювань на майбутні дати
SELECT COUNT(*) as future_reservations 
FROM reservations 
WHERE reservation_time > CURRENT_TIMESTAMP;

-- Загальна сума всіх оплачених рахунків
SELECT SUM(total_amount) as total_revenue 
FROM bills 
WHERE status = 'Paid';

-- Загальна сума продажів по місяцях
SELECT DATE_TRUNC('month', created_at) as month,
       SUM(total_amount) as monthly_revenue
FROM bills
WHERE status = 'Paid'
GROUP BY DATE_TRUNC('month', created_at)
ORDER BY month;
