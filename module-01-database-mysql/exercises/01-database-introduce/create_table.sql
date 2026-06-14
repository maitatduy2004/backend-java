-- Tạo table --
CREATE TABLE students (
    id          INT             NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(100)    NOT NULL,
    email       VARCHAR(150)    NOT NULL UNIQUE,
    class_id    INT,
    birth_date  DATE,
    created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);

CREATE TABLE teachers (
    id          INT             NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(100)    NOT NULL,
    email       VARCHAR(150)    NOT NULL UNIQUE,
    PRIMARY KEY (id)
);

CREATE TABLE classes (
    id          INT             NOT NULL AUTO_INCREMENT,
    class_name  VARCHAR(50)     NOT NULL,
    teacher_id  INT,
    PRIMARY KEY (id)
);

-- Xem danh sách bảng table trong database hiện tại --
SHOW TABLES;

-- Xem cấu trúc của bảng --
DESCRIBE students;
-- hoặc
SHOW COLUMNS FROM students;

-- Xóa bảng
DROP TABLE students;