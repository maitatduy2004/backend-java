-- Khóa chính gồm một cột
CREATE TABLE students (
    id INT NOT NULL AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

-- Khóa chính gồm nhiều cột
CREATE TABLE enrollments (
    student_id INT NOT NULL,
    class_id INT NOT NULL,
    PRIMARY KEY (student_id, class_id)
);