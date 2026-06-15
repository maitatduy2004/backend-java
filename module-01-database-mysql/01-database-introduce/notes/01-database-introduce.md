# SQL - Tổng quan về Database

---

## Mục lục

1. [Giới thiệu tổng quan](#1-giới-thiệu-tổng-quan)
2. [Cài đặt MySQL Workbench](#2-cài-đặt-mysql-workbench)
3. [Web Architecture](#3-web-architecture)
4. [Database là gì?](#4-database-là-gì)
5. [Tạo Database & Table](#5-tạo-database--table)

---

## 1. Giới thiệu tổng quan

SQL (Structured Query Language) là ngôn ngữ tiêu chuẩn để tương tác với cơ sở dữ liệu quan hệ (relational database). Trong repo này, hệ quản trị cơ sở dữ liệu được sử dụng là **MySQL**.

**Mục tiêu:**

- Hiểu được cấu trúc và vai trò của cơ sở dữ liệu trong hệ thống
- Thành thạo các câu lệnh truy vấn, thao tác dữ liệu
- Áp dụng được vào backend thực tế (Spring Boot, Node.js, ...)

---

## 2. Cài đặt MySQL Workbench

**MySQL Workbench** là công cụ GUI chính thức của MySQL, dùng để:

- Quản lý kết nối đến MySQL server
- Viết và thực thi câu lệnh SQL
- Xem cấu trúc schema trực quan

**Các bước cài đặt:**

1. Truy cập [https://dev.mysql.com/downloads/workbench](https://dev.mysql.com/downloads/workbench)
2. Chọn đúng hệ điều hành (Windows / macOS / Linux)
3. Cài đặt kèm **MySQL Server** nếu chưa có
4. Mở Workbench → tạo connection mới với host `127.0.0.1`, port `3306`, user `root`

> **Lưu ý:** Nhớ lưu lại password root đã đặt lúc cài MySQL Server, vì không thể khôi phục dễ dàng sau đó.

---

## 3. Web Architecture

Hiểu web architecture giúp xác định vị trí và vai trò của database trong hệ thống.

```
Client (Browser / App)
        │
        │ HTTP Request
        ▼
   Web Server / API Server
        │
        │ Query
        ▼
    Database Server
```

**Luồng cơ bản:**

1. Client gửi request (vd: xem danh sách sản phẩm)
2. Server xử lý logic nghiệp vụ
3. Server truy vấn database để lấy dữ liệu
4. Server trả về response cho client

**Vai trò của database trong hệ thống:**

- Lưu trữ dữ liệu lâu dài (persistent storage)
- Đảm bảo tính nhất quán và toàn vẹn dữ liệu
- Hỗ trợ truy vấn, tìm kiếm, lọc dữ liệu hiệu quả

---

## 4. Database là gì?

**Database (Cơ sở dữ liệu)** là tập hợp dữ liệu được tổ chức có cấu trúc, cho phép lưu trữ, truy xuất và quản lý dữ liệu một cách hiệu quả.

### Các loại database phổ biến

| Loại             | Ví dụ                         | Đặc điểm                            |
| ---------------- | ----------------------------- | ----------------------------------- |
| Relational (SQL) | MySQL, PostgreSQL, SQL Server | Dữ liệu dạng bảng, có quan hệ       |
| Document (NoSQL) | MongoDB                       | Dữ liệu dạng JSON document          |
| Key-Value        | Redis                         | Truy xuất cực nhanh, dùng cho cache |
| Graph            | Neo4j                         | Biểu diễn quan hệ phức tạp          |

### Các khái niệm cơ bản trong Relational Database

**Database** - tập hợp các bảng liên quan đến một ứng dụng hoặc nghiệp vụ cụ thể.

**Table (Bảng)** - đơn vị lưu trữ dữ liệu, gồm các hàng và cột. Tương tự một tờ Excel.

**Row (Hàng / Record)** - một bản ghi dữ liệu cụ thể.

**Column (Cột / Field)** - một thuộc tính của bảng, mỗi cột có kiểu dữ liệu xác định.

**Schema** - cấu trúc tổng thể của database, bao gồm tất cả các bảng và quan hệ giữa chúng.

---

## 5. Tạo Database & Table

### 5.1 Tạo Database

```sql
CREATE DATABASE school_db;
```

Chọn database để làm việc:

```sql
USE school_db;
```

Xem danh sách database hiện có:

```sql
SHOW DATABASES;
```

Xóa database (cẩn thận):

```sql
DROP DATABASE school_db;
```

---

### 5.2 Tạo Table

Cú pháp tổng quát:

```sql
CREATE TABLE table_name (
    column_name datatype [constraints],
    ...
);
```

**Ví dụ - Tạo bảng `students`:**

```sql
CREATE TABLE students (
    id          INT             NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(100)    NOT NULL,
    email       VARCHAR(150)    NOT NULL UNIQUE,
    birth_date  DATE,
    created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
```

**Giải thích từng phần:**

| Thành phần       | Ý nghĩa                                  |
| ---------------- | ---------------------------------------- |
| `INT`            | Kiểu số nguyên                           |
| `VARCHAR(n)`     | Chuỗi ký tự, tối đa n ký tự              |
| `DATE`           | Ngày tháng (YYYY-MM-DD)                  |
| `DATETIME`       | Ngày giờ (YYYY-MM-DD HH:MM:SS)           |
| `NOT NULL`       | Bắt buộc phải có giá trị                 |
| `AUTO_INCREMENT` | Tự động tăng (dùng cho khóa chính)       |
| `UNIQUE`         | Không được trùng giá trị                 |
| `DEFAULT`        | Giá trị mặc định nếu không truyền vào    |
| `PRIMARY KEY`    | Khóa chính - định danh duy nhất mỗi hàng |

---

### 5.3 Xem & xóa Table

```sql
-- Xem danh sách bảng trong database hiện tại
SHOW TABLES;

-- Xem cấu trúc của bảng
DESCRIBE students;
-- hoặc
SHOW COLUMNS FROM students;

-- Xóa bảng
DROP TABLE students;
```

---

### 5.4 Ví dụ đầy đủ - Tạo schema cho hệ thống quản lý lớp học

```sql
CREATE DATABASE classroom_db;
USE classroom_db;

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

CREATE TABLE students (
    id          INT             NOT NULL AUTO_INCREMENT,
    full_name   VARCHAR(100)    NOT NULL,
    email       VARCHAR(150)    NOT NULL UNIQUE,
    class_id    INT,
    birth_date  DATE,
    created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id)
);
```

---
