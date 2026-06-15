# SQL - Datatype & Constraint

---

## Mục lục

1. [Datatype](#1-datatype)
   - [1.1 Number](#11-number)
   - [1.2 Character](#12-character)
   - [1.3 Date & Time](#13-date--time)
   - [1.4 Enum](#14-enum)
2. [Constraint](#2-constraint)
   - [2.1 Primary Key](#21-primary-key)
   - [2.2 Foreign Key](#22-foreign-key)
   - [2.3 Unique Key](#23-unique-key)
   - [2.4 Default](#24-default)
   - [2.5 Not Null](#25-not-null)
   - [2.6 Check](#26-check)
3. [Ví dụ tổng hợp](#3-ví-dụ-tổng-hợp)

---

## 1. Datatype

Mỗi column trong bảng phải được khai báo một kiểu dữ liệu cụ thể. Chọn đúng datatype giúp tiết kiệm bộ nhớ và đảm bảo tính toàn vẹn dữ liệu.

---

### 1.1 Number

| Kiểu            | Kích thước | Phạm vi                                | Dùng cho                           |
| --------------- | ---------- | -------------------------------------- | ---------------------------------- |
| `TINYINT`       | 1 byte     | -128 đến 127 (hoặc 0–255 nếu UNSIGNED) | Trạng thái, flag (0/1)             |
| `SMALLINT`      | 2 byte     | -32,768 đến 32,767                     | Số nhỏ                             |
| `INT`           | 4 byte     | -2,147,483,648 đến 2,147,483,647       | ID, số lượng thông thường          |
| `BIGINT`        | 8 byte     | Rất lớn                                | ID hệ thống lớn, timestamp dạng số |
| `FLOAT`         | 4 byte     | Số thực, độ chính xác thấp             | Tọa độ, số gần đúng                |
| `DOUBLE`        | 8 byte     | Số thực, độ chính xác cao hơn          | Tính toán khoa học                 |
| `DECIMAL(p, s)` | Biến đổi   | Chính xác tuyệt đối                    | Tiền tệ, giá trị tài chính         |

> **Lưu ý:** Không dùng `FLOAT` hoặc `DOUBLE` cho tiền tệ vì có thể gây sai số làm tròn. Dùng `DECIMAL` thay thế.

```sql
price       DECIMAL(10, 2)    -- tối đa 10 chữ số, 2 chữ số thập phân
quantity    INT UNSIGNED      -- chỉ dương, không âm
is_active   TINYINT(1)        -- dùng như boolean: 0 = false, 1 = true
```

---

### 1.2 Character

| Kiểu         | Đặc điểm                                  | Dùng cho                     |
| ------------ | ----------------------------------------- | ---------------------------- |
| `CHAR(n)`    | Độ dài cố định, padding bằng khoảng trắng | Mã cố định: mã tỉnh, mã loại |
| `VARCHAR(n)` | Độ dài biến đổi, tối đa n ký tự           | Tên, email, địa chỉ          |
| `TEXT`       | Chuỗi dài, tối đa ~65KB                   | Mô tả, nội dung bài viết     |
| `MEDIUMTEXT` | Tối đa ~16MB                              | Bài viết dài                 |
| `LONGTEXT`   | Tối đa ~4GB                               | Nội dung rất lớn (log, HTML) |

> **Lưu ý:** `CHAR(n)` luôn chiếm đúng n byte dù giá trị ngắn hơn. `VARCHAR(n)` chỉ chiếm đúng số byte cần thiết + 1-2 byte lưu độ dài.

```sql
country_code    CHAR(2)         -- VD, US, JP - luôn 2 ký tự
full_name       VARCHAR(100)
bio             TEXT
```

---

### 1.3 Date & Time

| Kiểu        | Format                | Dùng cho                                     |
| ----------- | --------------------- | -------------------------------------------- |
| `DATE`      | `YYYY-MM-DD`          | Ngày sinh, ngày hết hạn                      |
| `TIME`      | `HH:MM:SS`            | Giờ làm việc, thời lượng                     |
| `DATETIME`  | `YYYY-MM-DD HH:MM:SS` | Thời điểm tạo/cập nhật record                |
| `TIMESTAMP` | `YYYY-MM-DD HH:MM:SS` | Giống DATETIME nhưng tự chuyển theo timezone |
| `YEAR`      | `YYYY`                | Năm sản xuất, năm học                        |

**Phân biệt `DATETIME` vs `TIMESTAMP`:**

- `DATETIME` lưu đúng giá trị bạn nhập, không quan tâm timezone. Phạm vi: 1000-01-01 đến 9999-12-31.
- `TIMESTAMP` tự động chuyển đổi theo timezone của server. Phạm vi: 1970-01-01 đến 2038-01-19.

```sql
birth_date      DATE
created_at      DATETIME        DEFAULT CURRENT_TIMESTAMP
updated_at      DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
```

---

### 1.4 Enum

`ENUM` giới hạn giá trị của column trong một tập hợp cố định.

```sql
status      ENUM('active', 'inactive', 'banned')      DEFAULT 'active'
gender      ENUM('male', 'female', 'other')
role        ENUM('admin', 'teacher', 'student')        NOT NULL
```

**Ưu điểm:** Đơn giản, dễ đọc, tiết kiệm bộ nhớ.

**Nhược điểm:** Khó thay đổi sau khi deploy (cần `ALTER TABLE`). Với hệ thống lớn, nên dùng bảng lookup riêng thay vì `ENUM`.

---

## 2. Constraint

Constraint là các ràng buộc áp đặt lên column hoặc bảng nhằm đảm bảo tính toàn vẹn dữ liệu.

---

### 2.1 Primary Key

Định danh duy nhất cho mỗi hàng trong bảng. Mỗi bảng chỉ có **một** Primary Key, không được `NULL`, không được trùng.

```sql
-- Cách 1: Khai báo inline
id INT NOT NULL AUTO_INCREMENT PRIMARY KEY

-- Cách 2: Khai báo ở cuối (khuyến nghị, rõ ràng hơn)
CREATE TABLE students (
    id          INT         NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(100) NOT NULL,
    PRIMARY KEY (id)
);

-- Composite Primary Key (khóa chính gồm nhiều cột)
CREATE TABLE enrollments (
    student_id  INT     NOT NULL,
    class_id    INT     NOT NULL,
    PRIMARY KEY (student_id, class_id)
);
```

---

### 2.2 Foreign Key

Tạo quan hệ giữa hai bảng. Đảm bảo giá trị trong column phải tồn tại ở bảng tham chiếu.

```sql
CREATE TABLE orders (
    id          INT     NOT NULL AUTO_INCREMENT,
    user_id     INT     NOT NULL,
    total       DECIMAL(10, 2),
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users(id)
);
```

**Các hành động khi record cha bị xóa/sửa:**

| Tùy chọn              | Hành vi                             |
| --------------------- | ----------------------------------- |
| `RESTRICT` (mặc định) | Không cho xóa/sửa nếu có record con |
| `CASCADE`             | Tự động xóa/sửa record con theo     |
| `SET NULL`            | Đặt foreign key thành NULL          |
| `NO ACTION`           | Tương tự RESTRICT                   |

```sql
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE SET NULL
```

---

### 2.3 Unique Key

Đảm bảo không có hai hàng nào có cùng giá trị ở column đó. Khác Primary Key ở chỗ: có thể có nhiều Unique Key, và cho phép giá trị `NULL` (mỗi NULL được coi là khác nhau).

```sql
CREATE TABLE users (
    id          INT             NOT NULL AUTO_INCREMENT,
    email       VARCHAR(150)    NOT NULL UNIQUE,
    username    VARCHAR(50)     NOT NULL,
    phone       VARCHAR(20),
    PRIMARY KEY (id),
    UNIQUE KEY uq_username (username),
    UNIQUE KEY uq_phone (phone)         -- phone có thể NULL
);
```

---

### 2.4 Default

Gán giá trị mặc định cho column khi `INSERT` không truyền giá trị cho column đó.

```sql
status      ENUM('active', 'inactive')  DEFAULT 'active'
created_at  DATETIME                    DEFAULT CURRENT_TIMESTAMP
score       INT                         DEFAULT 0
is_verified TINYINT(1)                  DEFAULT 0
```

---

### 2.5 Not Null

Bắt buộc column phải có giá trị, không được để trống.

```sql
full_name   VARCHAR(100)    NOT NULL
email       VARCHAR(150)    NOT NULL
```

> Nếu không khai báo `NOT NULL`, column mặc định cho phép `NULL`. Nên khai báo rõ ràng để tránh nhầm lẫn.

---

### 2.6 Check

Ràng buộc giá trị phải thỏa mãn một điều kiện nhất định. Hỗ trợ từ MySQL 8.0.16 trở lên.

```sql
CREATE TABLE products (
    id          INT             NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100)    NOT NULL,
    price       DECIMAL(10, 2)  NOT NULL,
    quantity    INT             NOT NULL,
    discount    DECIMAL(5, 2),
    PRIMARY KEY (id),
    CONSTRAINT chk_price        CHECK (price > 0),
    CONSTRAINT chk_quantity     CHECK (quantity >= 0),
    CONSTRAINT chk_discount     CHECK (discount >= 0 AND discount <= 100)
);
```

---

## 3. Ví dụ tổng hợp

Schema cho hệ thống quản lý khóa học, áp dụng đầy đủ các datatype và constraint đã học:

```sql
CREATE DATABASE course_db;
USE course_db;

CREATE TABLE users (
    id              INT                                     NOT NULL AUTO_INCREMENT,
    full_name       VARCHAR(100)                            NOT NULL,
    email           VARCHAR(150)                            NOT NULL,
    password_hash   VARCHAR(255)                            NOT NULL,
    role            ENUM('admin', 'instructor', 'student')  NOT NULL    DEFAULT 'student',
    is_active       TINYINT(1)                              NOT NULL    DEFAULT 1,
    birth_date      DATE,
    created_at      DATETIME                                            DEFAULT CURRENT_TIMESTAMP,
    updated_at      DATETIME                                            DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_email (email)
);

CREATE TABLE courses (
    id              INT             NOT NULL AUTO_INCREMENT,
    title           VARCHAR(200)    NOT NULL,
    description     TEXT,
    price           DECIMAL(10, 2)  NOT NULL    DEFAULT 0.00,
    instructor_id   INT             NOT NULL,
    status          ENUM('draft', 'published', 'archived') NOT NULL DEFAULT 'draft',
    created_at      DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (instructor_id) REFERENCES users(id) ON DELETE RESTRICT,
    CONSTRAINT chk_price CHECK (price >= 0)
);

CREATE TABLE enrollments (
    student_id      INT         NOT NULL,
    course_id       INT         NOT NULL,
    enrolled_at     DATETIME    DEFAULT CURRENT_TIMESTAMP,
    progress        TINYINT     NOT NULL DEFAULT 0,
    PRIMARY KEY (student_id, course_id),
    FOREIGN KEY (student_id) REFERENCES users(id)   ON DELETE CASCADE,
    FOREIGN KEY (course_id)  REFERENCES courses(id) ON DELETE CASCADE,
    CONSTRAINT chk_progress CHECK (progress >= 0 AND progress <= 100)
);
```

---
