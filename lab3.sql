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

-- Об'єднання оплачених рахунків, виконаних замовлень, позицій в меню., 
SELECT b.bill_id, t.table_id, co.item_id, mi.name as item_name,
       co.quantity, co.price_at_time, b.total_amount
FROM bills b
JOIN tables t ON b.table_id = t.table_id
JOIN completed_orders co ON b.bill_id = co.bill_id
JOIN menu_items mi ON co.item_id = mi.item_id
WHERE b.status = 'Paid'
ORDER BY b.created_at DESC;

-- Столи по рейтингу прибутковості чеків(в порядку спадання)
SELECT t.table_id, t.seats, 
       COUNT(DISTINCT b.bill_id) as total_bills,
       SUM(b.total_amount) as total_sales
FROM tables t
INNER JOIN bills b ON t.table_id = b.table_id
GROUP BY t.table_id, t.seats
ORDER BY total_sales DESC;


-- Всі замовлення страв в яких статус новий або в процессі очікування, об'єднуючи зі столами та пунктами меню
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

-- Всі столики та їхні бронювання (включно з тими, що не мають бронювань)
SELECT t.table_id, t.seats, r.reservation_id, r.customer_name, r.reservation_time
FROM reservations r
RIGHT JOIN tables t ON r.table_id = t.table_id
ORDER BY t.table_id;

-- Всі страви та замовлення (включно з тими стравами, що не замовлялись)
SELECT mi.item_id, mi.name, o.order_id, o.quantity, o.status
FROM menu_items mi
FULL JOIN orders o ON mi.item_id = o.item_id
ORDER BY mi.item_id, o.order_id;

-- Всі можливі комбінації столиків та страв меню
SELECT t.table_id, t.seats, mi.item_id, mi.name, mi.price
FROM tables t
CROSS JOIN menu_items mi
WHERE mi.is_available = true
ORDER BY t.table_id, mi.item_id;

-- Пари столиків з однаковою кількістю місць
SELECT t1.table_id as table1_id, 
       t2.table_id as table2_id, 
       t1.seats as seats_count
FROM tables t1
JOIN tables t2 ON t1.seats = t2.seats AND t1.table_id < t2.table_id
ORDER BY t1.seats;

-- Середня кількість бронювань на столик
SELECT AVG(reservation_count) AS average_reservations
FROM (
    SELECT COUNT(reservation_id) AS reservation_count
    FROM reservations
    GROUP BY table_id
) AS sub;

-- Столики, які мають більше бронювань ніж середня кількість
SELECT t.table_id, COUNT(r.reservation_id) as reservations_count
FROM tables t
LEFT JOIN reservations r ON t.table_id = r.table_id
GROUP BY t.table_id
HAVING COUNT(r.reservation_id) > (
    SELECT AVG(reservation_count)
    FROM (
        SELECT COUNT(reservation_id) as reservation_count
        FROM reservations
        GROUP BY table_id
    ) as avg_reservations
);

-- Страви, які були замовлені більше 5 разів
SELECT name, price 
FROM menu_items
WHERE item_id IN (
    SELECT item_id
    FROM orders
    GROUP BY item_id
    HAVING COUNT(*) > 5
);

-- Столики, які ніколи не мали замовлень
SELECT table_id, seats
FROM tables t
WHERE NOT EXISTS (
    SELECT 1 
    FROM orders o
    WHERE o.table_id = t.table_id
);

-- Об'єднуємо бронювання та активні замовлення для столика
SELECT table_id, 'Reservation' as type, created_at
FROM reservations
WHERE reservation_time > CURRENT_TIMESTAMP
UNION
SELECT table_id, 'Order' as type, created_at
FROM orders
WHERE status IN ('New', 'Pending')
ORDER BY created_at;

-- Рейтинг столиків за сумою рахунків
SELECT 
    t.table_id,
    t.seats,
    SUM(b.total_amount) as total_revenue,
    RANK() OVER (ORDER BY SUM(b.total_amount) DESC) as revenue_rank,
    PERCENT_RANK() OVER (ORDER BY SUM(b.total_amount)) as revenue_percentile
FROM tables t
LEFT JOIN bills b ON t.table_id = b.table_id
GROUP BY t.table_id, t.seats;

-- Знайти столики, які мають і бронювання, і замовлення сьогодні
SELECT table_id
FROM reservations
WHERE DATE(reservation_time) = CURRENT_DATE
INTERSECT
SELECT table_id
FROM orders
WHERE DATE(created_at) = CURRENT_DATE;

-- Вподобання в замовленнях по місяцях - топові страви
WITH MonthlyOrders AS (
    SELECT 
        DATE_TRUNC('month', created_at) as month,
        COUNT(*) as order_count,
        SUM(total_amount) as total_revenue
    FROM bills
    GROUP BY DATE_TRUNC('month', created_at)
)
SELECT 
    month,
    order_count,
    total_revenue,
    ROW_NUMBER() OVER (ORDER BY total_revenue DESC) as revenue_rank
FROM MonthlyOrders
ORDER BY month;

-- Популярність страв за часом доби
WITH DishPopularity AS (
    SELECT 
        mi.name,
        EXTRACT(HOUR FROM o.created_at) as hour_of_day,
        COUNT(*) as orders_count
    FROM menu_items mi
    JOIN orders o ON mi.item_id = o.item_id
    GROUP BY mi.name, EXTRACT(HOUR FROM o.created_at)
)
SELECT 
    *,
    RANK() OVER (PARTITION BY hour_of_day ORDER BY orders_count DESC) as popularity_rank
FROM DishPopularity
ORDER BY hour_of_day, orders_count DESC;

-- Статистика столиків
WITH TableStats AS (
    SELECT 
        t.table_id,
        t.seats,
        COUNT(DISTINCT o.order_id) as total_orders,
        COUNT(DISTINCT r.reservation_id) as total_reservations
    FROM tables t
    LEFT JOIN orders o ON t.table_id = o.table_id
    LEFT JOIN reservations r ON t.table_id = r.table_id
    GROUP BY t.table_id, t.seats
)
SELECT 
    *,
    DENSE_RANK() OVER (ORDER BY total_orders DESC) as order_rank,
    DENSE_RANK() OVER (ORDER BY total_reservations DESC) as reservation_rank
FROM TableStats;

-- Топ-5 самих дорогих страв
SELECT name, price 
FROM menu_items 
ORDER BY price DESC 
LIMIT 5;

-- Середній чек по дням тижн
SELECT 
    EXTRACT(DOW FROM created_at) as day_of_week,
    ROUND(AVG(total_amount), 2) as avg_bill
FROM bills
GROUP BY day_of_week
ORDER BY avg_bill DESC;

-- Найпопулярніші страви для великих компаній
SELECT mi.name, COUNT(*) as order_count
FROM orders o
JOIN tables t ON o.table_id = t.table_id
JOIN menu_items mi ON o.item_id = mi.item_id
WHERE t.seats >= 6
GROUP BY mi.name
ORDER BY order_count DESC
LIMIT 5;
