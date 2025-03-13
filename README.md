
# ЛАБОРАТОРНА 4 З ДИСЦИПЛІНИ БАЗИ ДАНИХ ТА ІНФОРМАЦІЙНІ СИСТЕМИ

# Варіант 8. Система управління замовленнями у кафе.

Створимо бекап бази даних з попередньої роботи, з якого створимо нову базу даних для виконання цієї:

```pg_dump -U postgres cafe > cafe_dump.sql```
```psql -U postgres -c 'CREATE DATABASE cafe_restored;'```
```psql -U postgres -d cafe_restored < cafe_dump.sql```

- `SELECT 'CREATE DATABASE cafe;' WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'cafe')\gexec` - перевіряє наявність бази даних перед створенням
- `CREATE TABLE IF NOT EXISTS` - створює таблиці, лише якщо вони ще не існують

Це запобігає помилкам при повторному виконанні скрипта та гарантує коректність структури даних.

## Схема бази даних

### Таблиця столиків tables
- `table_id`: Первинний ключ
- `seats`: Кількість місць за столиком
- `status`: Статус столика ('Available' - вільний, 'Taken' - зайнятий)

### Таблиця бронювань reservations
- `reservation_id`: Первинний ключ
- `table_id`: Зовнішній ключ, що посилається на столик
- `customer_name`: Ім'я клієнта
- `phone_number`: Номер телефону
- `reservation_time`: Час бронювання
- `created_at`: Час створення бронювання

### Таблиця пунктів меню menu_items
- `item_id`: Первинний ключ
- `name`: Назва страви
- `description`: Опис страви
- `price`: Ціна
- `is_available`: Чи доступна страва (true/false)

### Таблиця замовлень orders
- `order_id`: Первинний ключ
- `table_id`: Зовнішній ключ, що посилається на столик
- `item_id`: Зовнішній ключ, що посилається на страву
- `quantity`: Кількість
- `status`: Статус замовлення ('New' - нове, 'Pending' - в обробці, 'Ready' - готове, 'Done' - виконане)
- `created_at`: Час створення замовлення

### Таблиця рахунків bills
- `bill_id`: Первинний ключ
- `table_id`: Зовнішній ключ, що посилається на столик
- `total_amount`: Загальна сума
- `status`: Статус оплати ('Pending' - очікує оплати, 'Paid' - оплачено)
- `created_at`: Час створення рахунку

### Таблиця виконаних замовлень completed_orders
- `completed_order_id`: Первинний ключ
- `bill_id`: Зовнішній ключ, що посилається на рахунок
- `item_id`: Зовнішній ключ, що посилається на страву
- `quantity`: Кількість
- `price_at_time`: Ціна на момент замовлення
- `completed_at`: Час виконання замовлення

## Тестові дані
Згенеровані сервісом Mockaroo + виправлені деякі некоректні значення за допомогою AI

## ER-діаграма
[Посилання на діаграму](https://drive.google.com/file/d/1D_fgr33azq9ZL9aT0hdg_gQkd3pYvCZn/view?usp=sharing)


## Звіт
[Посилання на звіт](https://drive.google.com/file/d/1inNXgWu-SeZZO1XZWyJ0zirEwU5JHKrJ/view?usp=sharing)


