SELECT 'CREATE DATABASE social_network;'
WHERE NOT EXISTS (SELECT FROM pg_database WHERE datname = 'social_network')\gexec

\c social_network;

CREATE TABLE IF NOT EXISTS users (
    id SERIAL PRIMARY KEY,
    username VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL,
    password VARCHAR(255) NOT NULL
);

CREATE TABLE IF NOT EXISTS posts (
    id SERIAL PRIMARY KEY,
    title VARCHAR(255) NOT NULL,
    content TEXT NOT NULL,
    user_id INT NOT NULL,
    FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE IF NOT EXISTS comments (
    id SERIAL PRIMARY KEY,
    content TEXT NOT NULL,
    author_id INT NOT NULL,
    post_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (author_id) REFERENCES users(id),
    FOREIGN KEY (post_id) REFERENCES posts(id)
);

INSERT INTO users (username, email, password) VALUES
('diana_voit', 'diana2004@gmail.com', 'abracadabra'),
('maria_mock', 'maria.mock@ukr.net', 'qwerty!'),
('spfit', 'spfit@knu.ua', 'alena_pryanik');

INSERT INTO posts (title, content, user_id) VALUES
('Чекаємо на новий альбом Taylor Swift', 'Як думаєте, коли буде реліз?', 1),
('Новий сингл', 'Lady Gaga - Abracadabra. Як вам?', 2),
('Тиждень добігає кінця', 'Вже випили каву з корицею? ;)', 3);

INSERT INTO comments (content, author_id, post_id) VALUES
('Taylor Swift ікона!', 2, 1),
('Кліп - це щось 🔥', 3, 2),
('І навіть понямали в буфеті', 1, 3);

SELECT * FROM posts;

SELECT c.content, u.username, p.title FROM comments c
    JOIN users u ON c.author_id = u.id
    JOIN posts p ON c.post_id = p.id;

UPDATE posts SET content = 'Update: Реліз заплановано на березень!' WHERE id = 1;

DELETE FROM comments WHERE post_id = 2;
