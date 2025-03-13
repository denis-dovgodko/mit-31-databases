
# ЛАБОРАТОРНА 4 З ДИСЦИПЛІНИ БАЗИ ДАНИХ ТА ІНФОРМАЦІЙНІ СИСТЕМИ

# Варіант 8. Система управління замовленнями у кафе.

Створимо бекап бази даних з попередньої роботи, з якого створимо нову базу даних для виконання цієї лабораторної роботи:

```pg_dump -U postgres cafe > cafe_dump.sql```
```psql -U postgres -c 'CREATE DATABASE cafe_restored;'```
```psql -U postgres -d cafe_restored < cafe_dump.sql```

## Користувацькі типи даних
Створення і заміна status атрибуту замість VARCHAR на ENUM описана в скрипті custom_enums.sql

## Функція
Використання функцій продемонстровано на прикладі можливостей мови PL/PSQL, а саме EXCEPTIONS - обробка виключень
Код написано в скрипті function.sql, що дозволяє уникати помилки ділення на 0 при виконанні запиту до бази даних

## Тригер
Створення таблиці для логування дій INSERT, UPDATE, DELETE відносно таблиці orders описано в файлі custom_enums.sql, для цього створюється функція, тригер, та таблиця логів дій з таблицею orders

## ER-діаграма
[Посилання на діаграму](https://drive.google.com/file/d/1vKByaP7sk5P4aiWTVBLU7hMy3MJhpahc/view?usp=sharing)


## Звіт
[Посилання на звіт](https://drive.google.com/file/d/1tKf5_RqssIqQx8MT5mO3ugxnevIplFYj/view?usp=sharing)


