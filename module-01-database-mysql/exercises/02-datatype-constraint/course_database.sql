CREATE DATABASE course_db;

USE course_db;

CREATE TABLE users (
    id INT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(150) NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    role ENUM(
        'admin',
        'instructor',
        'student'
    ) NOT NULL DEFAULT 'student',
    is_active TINYINT(1) NOT NULL DEFAULT 1,
    birth_date DATE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_email (email)
);

CREATE TABLE courses (
    id INT NOT NULL AUTO_INCREMENT,
    title VARCHAR(200) NOT NULL,
    description TEXT,
    price DECIMAL(10, 2) NOT NULL DEFAULT 0.00,
    instructor_id INT NOT NULL,
    status ENUM(
        'draft',
        'published',
        'archived'
    ) NOT NULL DEFAULT 'draft',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (instructor_id) REFERENCES users (id) ON DELETE RESTRICT,
    CONSTRAINT chk_price CHECK (price >= 0)
);

CREATE TABLE enrollments (
    student_id INT NOT NULL,
    course_id INT NOT NULL,
    enrolled_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    progress TINYINT NOT NULL DEFAULT 0,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (course_id) REFERENCES courses (id) ON DELETE CASCADE,
    CONSTRAINT chk_progress CHECK (
        progress >= 0
        AND progress <= 100
    )
);