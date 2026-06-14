CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    email VARCHAR(150) NOT NULL UNIQUE,
    username VARCHAR(50) NOT NULL,
    phone VARCHAR(20),
    PRIMARY KEY (id),
    UNIQUE KEY uq_username (username),
    UNIQUE KEY uq_phone (phone) -- phone có thể NULL
);