# SQL - Lời giải

---

## Mục lục

1. [Bài 1 - Tạo TestingSystem](#bài-1--tạo-testingsystem)
2. [Bài 2.1 - LibraryDB](#bài-21--librarydb)
3. [Bài 2.2 - Nhận diện lỗi](#bài-22--nhận-diện-lỗi)
4. [Bài 2.3 - Chọn datatype đúng](#bài-23--chọn-datatype-đúng)
5. [Bài 2.4 - Điền constraint còn thiếu](#bài-24--điền-constraint-còn-thiếu)
6. [Bài 2.5 - Lý thuyết](#bài-25--lý-thuyết)
7. [Bài 3.1 - Thiết kế schema hệ thống bán hàng online](#bài-31--thiết-kế-schema-hệ-thống-bán-hàng-online)
8. [Bài 3.2 - Phân tích quan hệ TestingSystem](#bài-32--phân-tích-quan-hệ-testingsystem)
9. [Bài 3.3 - ALTER TABLE](#bài-33--alter-table)
10. [Bài 3.4 - Phát hiện vấn đề thiết kế](#bài-34--phát-hiện-vấn-đề-thiết-kế)
11. [Bài 4.1 - TestingSystem mở rộng](#bài-41--testingsystem-mở-rộng)
12. [Bài 4.2 - So sánh phương án thiết kế địa chỉ](#bài-42--so-sánh-phương-án-thiết-kế-địa-chỉ)
13. [Bài 4.3 - Tư duy thiết kế](#bài-43--tư-duy-thiết-kế)

---

## Bài 1 - Tạo TestingSystem

```sql
-- ============================================================
--  TestingSystem — Schema + Sample Data
-- ============================================================

DROP DATABASE IF EXISTS TestingSystem;

CREATE DATABASE TestingSystem;

USE TestingSystem;

CREATE TABLE Department (
    DepartmentID INT NOT NULL AUTO_INCREMENT,
    DepartmentName VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (DepartmentID)
);

CREATE TABLE `Position` (
    PositionID INT NOT NULL AUTO_INCREMENT,
    PositionName ENUM(
        'DEV',
        'TEST',
        'SCRUM MASTER',
        'PM'
    ) NOT NULL,
    PRIMARY KEY (PositionID)
);

CREATE TABLE `Account` (
    AccountID INT NOT NULL AUTO_INCREMENT,
    Email VARCHAR(150) NOT NULL UNIQUE,
    Username VARCHAR(50) NOT NULL UNIQUE,
    FullName VARCHAR(100) NOT NULL,
    DepartmentID INT,
    PositionID INT,
    CreateDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (AccountID),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID) ON UPDATE CASCADE ON DELETE SET NULL,
    FOREIGN KEY (PositionID) REFERENCES `Position` (PositionID) ON UPDATE CASCADE ON DELETE SET NULL
);

CREATE TABLE `Group` (
    GroupID INT NOT NULL AUTO_INCREMENT,
    GroupName VARCHAR(100) NOT NULL,
    CreatorID INT NOT NULL,
    CreateDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (GroupID),
    FOREIGN KEY (CreatorID) REFERENCES `Account` (AccountID) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE GroupAccount (
    GroupID INT NOT NULL,
    AccountID INT NOT NULL,
    JoinDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (GroupID, AccountID),
    FOREIGN KEY (GroupID) REFERENCES `Group` (GroupID) ON DELETE CASCADE,
    FOREIGN KEY (AccountID) REFERENCES `Account` (AccountID) ON DELETE CASCADE
);

CREATE TABLE TypeQuestion (
    TypeID INT NOT NULL AUTO_INCREMENT,
    TypeName VARCHAR(50) NOT NULL UNIQUE,
    PRIMARY KEY (TypeID)
);

CREATE TABLE CategoryQuestion (
    CategoryID INT NOT NULL AUTO_INCREMENT,
    CategoryName VARCHAR(100) NOT NULL UNIQUE,
    PRIMARY KEY (CategoryID)
);

CREATE TABLE Question (
    QuestionID INT NOT NULL AUTO_INCREMENT,
    Content TEXT NOT NULL,
    CategoryID INT NOT NULL,
    TypeID INT NOT NULL,
    CreatorID INT NOT NULL,
    CreateDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (QuestionID),
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion (CategoryID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (TypeID) REFERENCES TypeQuestion (TypeID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CreatorID) REFERENCES `Account` (AccountID) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE Answer (
    AnswerID INT NOT NULL AUTO_INCREMENT,
    Content TEXT NOT NULL,
    QuestionID INT NOT NULL,
    isCorrect TINYINT(1) NOT NULL DEFAULT 0,
    PRIMARY KEY (AnswerID),
    FOREIGN KEY (QuestionID) REFERENCES Question (QuestionID) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Exam (
    ExamID INT NOT NULL AUTO_INCREMENT,
    Code VARCHAR(50) NOT NULL,
    Title VARCHAR(200) NOT NULL,
    CategoryID INT NOT NULL,
    Duration INT NOT NULL, -- minutes
    CreatorID INT NOT NULL,
    CreateDate DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ExamID),
    UNIQUE KEY uq_exam_code (Code),
    CONSTRAINT chk_duration CHECK (Duration > 0),
    FOREIGN KEY (CategoryID) REFERENCES CategoryQuestion (CategoryID) ON UPDATE CASCADE ON DELETE RESTRICT,
    FOREIGN KEY (CreatorID) REFERENCES `Account` (AccountID) ON UPDATE CASCADE ON DELETE RESTRICT
);

CREATE TABLE ExamQuestion (
    ExamID INT NOT NULL,
    QuestionID INT NOT NULL,
    PRIMARY KEY (ExamID, QuestionID),
    FOREIGN KEY (ExamID) REFERENCES Exam (ExamID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Question (QuestionID) ON DELETE RESTRICT
);

CREATE TABLE ExamResult (
    ResultID INT NOT NULL AUTO_INCREMENT,
    ExamID INT NOT NULL,
    AccountID INT NOT NULL,
    Score DECIMAL(5, 2) NOT NULL DEFAULT 0, -- 0.00 – 100.00
    StartTime DATETIME NOT NULL,
    SubmitTime DATETIME,
    PRIMARY KEY (ResultID),
    CONSTRAINT chk_score CHECK (Score BETWEEN 0 AND 100),
    FOREIGN KEY (ExamID) REFERENCES Exam (ExamID) ON DELETE RESTRICT,
    FOREIGN KEY (AccountID) REFERENCES `Account` (AccountID) ON DELETE RESTRICT
);
```

---

## Bài 2.1 - LibraryDB

```sql
CREATE DATABASE LibraryDB;
USE LibraryDB;

CREATE TABLE Author (
    AuthorID    INT             NOT NULL AUTO_INCREMENT,
    FullName    VARCHAR(100)    NOT NULL,
    Nationality VARCHAR(50),
    BirthDate   DATE,
    PRIMARY KEY (AuthorID)
);

CREATE TABLE Book (
    BookID          INT             NOT NULL AUTO_INCREMENT,
    Title           VARCHAR(200)    NOT NULL,
    AuthorID        INT             NOT NULL,
    PublishedYear   YEAR,
    Price           DECIMAL(10, 0)  NOT NULL DEFAULT 0,
    Stock           INT             NOT NULL DEFAULT 0,
    PRIMARY KEY (BookID),
    FOREIGN KEY (AuthorID) REFERENCES Author(AuthorID) ON DELETE RESTRICT,
    CONSTRAINT chk_price CHECK (Price >= 0),
    CONSTRAINT chk_stock CHECK (Stock >= 0)
);

CREATE TABLE Member (
    MemberID        INT             NOT NULL AUTO_INCREMENT,
    FullName        VARCHAR(100)    NOT NULL,
    Email           VARCHAR(150)    NOT NULL,
    Phone           CHAR(10),
    RegisterDate    DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (MemberID),
    UNIQUE KEY uq_email (Email)
);
```

---

## Bài 2.2 - Nhận diện lỗi

**SQL gốc có lỗi:**

```sql
CREATE TABLE employees (
    EmployeeID      INT,
    FullName        VARCHAR,           -- Lỗi 1
    Email           VARCHAR(150) UNIQUE NOT NULL,
    Salary          DECIMAL(10),       -- Lỗi 2
    DepartmentID    INT NOT NULL,
    HireDate        DATE DEFAULT '2024-01-01',
    PRIMARY KEY,                       -- Lỗi 3
    FOREIGN KEY (DepartmentID) REFERENCES Department  -- Lỗi 4
);
```

**Bảng lỗi và cách sửa:**

| Lỗi | Vị trí                  | Vấn đề                                                      | Sửa thành                             |
| --- | ----------------------- | ----------------------------------------------------------- | ------------------------------------- |
| 1   | `VARCHAR`               | Thiếu độ dài tối đa - MySQL bắt buộc khai báo `VARCHAR(n)`  | `VARCHAR(100)`                        |
| 2   | `DECIMAL(10)`           | Thiếu số chữ số thập phân - cần khai báo đủ `DECIMAL(p, s)` | `DECIMAL(10, 2)`                      |
| 3   | `PRIMARY KEY`           | Thiếu tên column làm khóa chính                             | `PRIMARY KEY (EmployeeID)`            |
| 4   | `REFERENCES Department` | Thiếu tên column tham chiếu trong bảng cha                  | `REFERENCES Department(DepartmentID)` |

**SQL đã sửa:**

```sql
CREATE TABLE employees (
    EmployeeID      INT             NOT NULL AUTO_INCREMENT,
    FullName        VARCHAR(100)    NOT NULL,
    Email           VARCHAR(150)    NOT NULL UNIQUE,
    Salary          DECIMAL(10, 2),
    DepartmentID    INT             NOT NULL,
    HireDate        DATE            DEFAULT '2024-01-01',
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES Department(DepartmentID)
);
```

---

## Bài 2.3 - Chọn datatype đúng

| STT | Trường dữ liệu               | Datatype                               | Lý do                                                   |
| --- | ---------------------------- | -------------------------------------- | ------------------------------------------------------- |
| 1   | Số điện thoại VN (10 chữ số) | `CHAR(10)`                             | Luôn đúng 10 ký tự, không tính toán số học              |
| 2   | Điểm thi (0.0 đến 10.0)      | `DECIMAL(3, 1)`                        | Cần chính xác tuyệt đối, tránh sai số float             |
| 3   | Trạng thái đơn hàng          | `ENUM('pending', 'paid', 'cancelled')` | Tập giá trị cố định, ít thay đổi                        |
| 4   | Nội dung bài viết blog       | `TEXT` hoặc `MEDIUMTEXT`               | Chuỗi dài không giới hạn cố định                        |
| 5   | Mã quốc gia (VN, US, JP)     | `CHAR(2)`                              | Luôn đúng 2 ký tự theo chuẩn ISO 3166-1                 |
| 6   | Số lượng tồn kho (không âm)  | `INT UNSIGNED`                         | Không âm, không cần thập phân                           |
| 7   | Giá tiền VNĐ                 | `DECIMAL(15, 0)`                       | Chính xác tuyệt đối, VNĐ không có xu                    |
| 8   | URL ảnh đại diện             | `VARCHAR(500)`                         | URL có độ dài biến đổi                                  |
| 9   | Thời điểm đăng nhập cuối     | `DATETIME`                             | Cần lưu đúng thời điểm, không phụ thuộc timezone server |
| 10  | Câu hỏi dạng essay hay không | `TINYINT(1)`                           | Boolean trong MySQL: 0 = false, 1 = true                |

---

## Bài 2.4 - Điền constraint còn thiếu

```sql
CREATE TABLE Student (
    StudentID   INT             NOT NULL AUTO_INCREMENT,
    Email       VARCHAR(150)    NOT NULL UNIQUE,
    FullName    VARCHAR(100)    NOT NULL,
    GPA         DECIMAL(3, 2),                              -- Cho phép NULL (chưa có điểm)
    Status      ENUM('active', 'inactive', 'graduated') NOT NULL DEFAULT 'active',
    ClassID     INT,                                        -- Cho phép NULL (chưa xếp lớp)
    CreatedAt   DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class(ClassID) ON DELETE SET NULL
);
```

**Giải thích từng chỗ trống:**

| Column      | Constraint thêm vào                               | Lý do                                      |
| ----------- | ------------------------------------------------- | ------------------------------------------ |
| `StudentID` | `NOT NULL`                                        | PK không được NULL                         |
| `Email`     | `NOT NULL UNIQUE`                                 | Email bắt buộc và không trùng              |
| `FullName`  | `NOT NULL`                                        | Bắt buộc phải có tên                       |
| `GPA`       | _(không thêm)_                                    | Sinh viên mới chưa có điểm - cho phép NULL |
| `Status`    | `NOT NULL`                                        | Luôn phải có trạng thái                    |
| `CreatedAt` | `DEFAULT CURRENT_TIMESTAMP`                       | Tự động ghi thời điểm tạo                  |
| PK          | `PRIMARY KEY (StudentID)`                         | Định danh chính                            |
| FK          | `FOREIGN KEY (ClassID) REFERENCES Class(ClassID)` | Liên kết đến lớp học                       |

---

## Bài 2.5 - Lý thuyết

**1. Khác nhau giữa `CHAR(10)` và `VARCHAR(10)`**

`CHAR(10)` có độ dài cố định - luôn chiếm đúng 10 byte dù giá trị ngắn hơn, MySQL tự padding bằng khoảng trắng. `VARCHAR(10)` có độ dài biến đổi - chỉ chiếm đúng số byte cần thiết cộng thêm 1-2 byte lưu độ dài thực tế.

Nên dùng `CHAR` cho dữ liệu có độ dài cố định: mã quốc gia `CHAR(2)`, số điện thoại `CHAR(10)`, mã bưu chính `CHAR(5)`. Nên dùng `VARCHAR` cho dữ liệu có độ dài biến đổi: họ tên, email, địa chỉ.

**2. Tại sao không dùng `FLOAT` để lưu giá tiền?**

`FLOAT` và `DOUBLE` biểu diễn số thực theo chuẩn IEEE 754 nhị phân - một số thập phân như `99.99` không thể biểu diễn chính xác trong hệ nhị phân, dẫn đến sai số làm tròn (vd: `99.99` có thể thành `99.98999999...`). Trong tính toán tài chính, sai số nhỏ cộng dồn qua nhiều phép tính sẽ gây ra kết quả sai. Dùng `DECIMAL` thay thế vì nó lưu số thập phân chính xác tuyệt đối.

**3. `PRIMARY KEY` và `UNIQUE KEY` khác nhau ở đâu?**

|                        | PRIMARY KEY                 | UNIQUE KEY                          |
| ---------------------- | --------------------------- | ----------------------------------- |
| Số lượng trên một bảng | Chỉ 1                       | Nhiều                               |
| Cho phép NULL          | Không                       | Có (mỗi NULL được coi là khác nhau) |
| Mục đích               | Định danh chính của row     | Đảm bảo không trùng lặp             |
| Index                  | Tự động tạo clustered index | Tự động tạo non-clustered index     |

**4. Khi nào dùng `TIMESTAMP` thay vì `DATETIME`?**

Dùng `TIMESTAMP` khi cần tự động chuyển đổi theo timezone của server - phù hợp cho hệ thống có người dùng ở nhiều múi giờ khác nhau. `TIMESTAMP` cũng hỗ trợ `ON UPDATE CURRENT_TIMESTAMP` tiện lợi hơn. Tuy nhiên `TIMESTAMP` chỉ hỗ trợ đến năm 2038 (Year 2038 Problem) nên dùng `DATETIME` cho dữ liệu dài hạn như ngày sinh, ngày hết hạn hợp đồng.

**5. `NOT NULL` và `DEFAULT` có dùng cùng nhau không?**

Có. Khi kết hợp, column bắt buộc phải có giá trị nhưng nếu không truyền vào thì dùng giá trị mặc định - không bao giờ là NULL.

```sql
-- Ví dụ: status luôn có giá trị, mặc định là 'active' nếu không truyền
status      ENUM('active', 'inactive') NOT NULL DEFAULT 'active'

-- created_at luôn có giá trị, tự điền thời điểm hiện tại nếu không truyền
created_at  DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP
```

---

## Bài 3.1 - Thiết kế schema hệ thống bán hàng online

### Schema

```sql
CREATE DATABASE EcommerceDB;
USE EcommerceDB;

-- Bảng người dùng gộp chung (cả khách hàng lẫn nhân viên)
CREATE TABLE users (
    id          INT             NOT NULL AUTO_INCREMENT,
    email       VARCHAR(150)    NOT NULL,
    username    VARCHAR(50)     NOT NULL,
    full_name   VARCHAR(100)    NOT NULL,
    phone       VARCHAR(15),
    role        ENUM('customer', 'staff', 'admin') NOT NULL DEFAULT 'customer',
    is_active   TINYINT(1)      NOT NULL DEFAULT 1,
    created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    UNIQUE KEY uq_email    (email),
    UNIQUE KEY uq_username (username)
);

-- Danh mục sản phẩm (hỗ trợ nhiều cấp: cha/con)
CREATE TABLE categories (
    id          INT             NOT NULL AUTO_INCREMENT,
    name        VARCHAR(100)    NOT NULL UNIQUE,
    parent_id   INT             DEFAULT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (parent_id) REFERENCES categories(id) ON DELETE SET NULL
);

-- Sản phẩm
CREATE TABLE products (
    id          INT             NOT NULL AUTO_INCREMENT,
    name        VARCHAR(200)    NOT NULL,
    description TEXT,
    price       DECIMAL(15, 0)  NOT NULL,
    stock       INT             NOT NULL DEFAULT 0,
    category_id INT             NOT NULL,
    is_active   TINYINT(1)      NOT NULL DEFAULT 1,
    created_at  DATETIME        DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT,
    CONSTRAINT chk_price CHECK (price >= 0),
    CONSTRAINT chk_stock CHECK (stock >= 0)
);

-- Ảnh sản phẩm
CREATE TABLE product_images (
    id          INT             NOT NULL AUTO_INCREMENT,
    product_id  INT             NOT NULL,
    url         VARCHAR(500)    NOT NULL,
    is_primary  TINYINT(1)      NOT NULL DEFAULT 0,
    sort_order  INT             NOT NULL DEFAULT 0,
    PRIMARY KEY (id),
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE CASCADE
);

-- Đơn hàng
CREATE TABLE orders (
    id                  INT             NOT NULL AUTO_INCREMENT,
    customer_id         INT             NOT NULL,
    staff_id            INT             DEFAULT NULL,
    status              ENUM('pending', 'confirmed', 'shipping', 'delivered', 'cancelled')
                                        NOT NULL DEFAULT 'pending',
    total_amount        DECIMAL(15, 0)  NOT NULL DEFAULT 0,
    note                TEXT,
    -- Snapshot địa chỉ giao hàng tại thời điểm đặt hàng
    shipping_name       VARCHAR(100)    NOT NULL,
    shipping_phone      VARCHAR(15)     NOT NULL,
    shipping_province   VARCHAR(100)    NOT NULL,
    shipping_district   VARCHAR(100)    NOT NULL,
    shipping_ward       VARCHAR(100)    NOT NULL,
    shipping_street     VARCHAR(200)    NOT NULL,
    created_at          DATETIME        DEFAULT CURRENT_TIMESTAMP,
    updated_at          DATETIME        DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    PRIMARY KEY (id),
    FOREIGN KEY (customer_id) REFERENCES users(id) ON DELETE RESTRICT,
    FOREIGN KEY (staff_id)    REFERENCES users(id) ON DELETE SET NULL,
    CONSTRAINT chk_total CHECK (total_amount >= 0)
);

-- Chi tiết đơn hàng
CREATE TABLE order_items (
    id          INT             NOT NULL AUTO_INCREMENT,
    order_id    INT             NOT NULL,
    product_id  INT             NOT NULL,
    quantity    INT             NOT NULL,
    unit_price  DECIMAL(15, 0)  NOT NULL,
    PRIMARY KEY (id),
    FOREIGN KEY (order_id)   REFERENCES orders(id)   ON DELETE CASCADE,
    FOREIGN KEY (product_id) REFERENCES products(id) ON DELETE RESTRICT,
    CONSTRAINT chk_qty   CHECK (quantity > 0),
    CONSTRAINT chk_price CHECK (unit_price >= 0)
);
```

### Giải thích quyết định thiết kế

**1. Gộp customer và staff vào một bảng `users` với column `role`**

Cả hai đều có thuộc tính chung: email, tên, số điện thoại. Tách thành hai bảng riêng dẫn đến trùng lặp cấu trúc và phức tạp khi một người vừa là khách hàng vừa là nhân viên. Dùng `role` để phân biệt, logic phân quyền xử lý ở tầng ứng dụng.

**2. Tách `product_images` thành bảng riêng**

Một sản phẩm có nhiều ảnh - quan hệ 1-N. Nếu nhét URL ảnh vào một column `VARCHAR` thì vi phạm 1NF. Tách ra cho phép thêm/xóa từng ảnh độc lập.

**3. Địa chỉ giao hàng lưu thẳng vào `orders` dưới dạng snapshot**

Đây là dữ liệu tại thời điểm đặt hàng, không thay đổi dù khách sau đó cập nhật địa chỉ. Nếu dùng FK trỏ vào bảng địa chỉ, khi khách xóa địa chỉ thì lịch sử đơn hàng mất thông tin giao hàng.

**4. Lưu `unit_price` trong `order_items`**

Giá sản phẩm có thể thay đổi theo thời gian. Cần snapshot giá tại thời điểm mua để tính lại tổng tiền chính xác về sau.

**5. `staff_id` trong `orders` cho phép NULL**

Không phải đơn hàng nào cũng có nhân viên phụ trách. `ON DELETE SET NULL` để tránh mất đơn hàng khi nhân viên bị xóa khỏi hệ thống.

**6. `parent_id` trong `categories` tự tham chiếu**

Hỗ trợ danh mục nhiều cấp: Điện tử → Điện thoại → iPhone. Quan hệ đệ quy 1-N trên cùng một bảng.

---

## Bài 3.2 - Phân tích quan hệ TestingSystem

### Sơ đồ quan hệ

```
Department (1) ──── (N) Account (N) ──── (1) Position
                         │ (1)
              ┌──────────┴──────────┐
             (N)                   (N)
           Group               Question
             │ (1)                 │ (1)
             │                    │
            (N)                  (N)
        GroupAccount           Answer
        [junction]

Question (N) ──── ExamQuestion [junction] ──── (N) Exam
                                                     │ (N)
Question (N) ──── (1) CategoryQuestion ──────────── (1)
Question (N) ──── (1) TypeQuestion
```

**Tổng hợp loại quan hệ:**

| Quan hệ                        | Loại               |
| ------------------------------ | ------------------ |
| Department - Account           | 1-N                |
| Position - Account             | 1-N                |
| Account - Group (CreatorID)    | 1-N                |
| Account - GroupAccount         | 1-N                |
| Group - GroupAccount           | 1-N                |
| Account - Question (CreatorID) | 1-N                |
| CategoryQuestion - Question    | 1-N                |
| TypeQuestion - Question        | 1-N                |
| Question - Answer              | 1-N                |
| Question - ExamQuestion        | N-N (qua junction) |
| Exam - ExamQuestion            | N-N (qua junction) |
| CategoryQuestion - Exam        | 1-N                |
| Account - Exam (CreatorID)     | 1-N                |

### Bảng trung gian và Composite Primary Key

| Junction table | Composite PK           |
| -------------- | ---------------------- |
| `GroupAccount` | `(GroupID, AccountID)` |
| `ExamQuestion` | `(ExamID, QuestionID)` |

### Ảnh hưởng khi xóa một Account

| Bảng                   | Quan hệ         | Khuyến nghị | Lý do                                                   |
| ---------------------- | --------------- | ----------- | ------------------------------------------------------- |
| `GroupAccount`         | AccountID là FK | `CASCADE`   | Membership không còn ý nghĩa khi user bị xóa            |
| `Group` (CreatorID)    | CreatorID là FK | `RESTRICT`  | Không tự động xóa cả group - cần chuyển ownership trước |
| `Question` (CreatorID) | CreatorID là FK | `RESTRICT`  | Câu hỏi là tài sản của hệ thống                         |
| `Exam` (CreatorID)     | CreatorID là FK | `RESTRICT`  | Tương tự Question                                       |

> Trong thực tế nên dùng **soft delete** (thêm cột `deleted_at`) thay vì xóa thật, để bảo toàn toàn bộ dữ liệu lịch sử.

### CreatorID tham chiếu đến đâu?

`CreatorID` trong cả `Group` và `Question` đều tham chiếu đến `Account(AccountID)`.

```sql
-- Group
FOREIGN KEY (CreatorID) REFERENCES Account(AccountID) ON DELETE RESTRICT

-- Question
FOREIGN KEY (CreatorID) REFERENCES Account(AccountID) ON DELETE RESTRICT
```

Cần `NOT NULL` (mọi group/question đều phải có người tạo) và `ON DELETE RESTRICT` (không cho xóa account khi còn dữ liệu phụ thuộc).

---

## Bài 3.3 - ALTER TABLE

```sql
-- 1. Thêm column Level vào Question
ALTER TABLE Question
ADD COLUMN Level ENUM('easy', 'medium', 'hard') NOT NULL DEFAULT 'medium';

-- 2. Thêm column Description vào CategoryQuestion
ALTER TABLE CategoryQuestion
ADD COLUMN Description TEXT NULL;

-- 3. Thêm column PassScore vào Exam với CHECK không âm
ALTER TABLE Exam
ADD COLUMN PassScore DECIMAL(5, 2) NULL,
ADD CONSTRAINT chk_pass_score CHECK (PassScore >= 0);

-- 4. Đổi tên column Content thành QuestionContent (MySQL 8.0+)
ALTER TABLE Question
RENAME COLUMN Content TO QuestionContent;

-- Nếu MySQL < 8.0, dùng CHANGE thay thế:
-- ALTER TABLE Question
-- CHANGE COLUMN Content QuestionContent TEXT NOT NULL;

-- 5. Xóa column Duration khỏi Exam
ALTER TABLE Exam
DROP COLUMN Duration;

-- 6. Thêm UNIQUE constraint cho Code trong Exam
ALTER TABLE Exam
ADD CONSTRAINT uq_exam_code UNIQUE (Code);
```

---

## Bài 3.4 - Phát hiện vấn đề thiết kế

```sql
CREATE TABLE Orders (
    id       INT PRIMARY KEY AUTO_INCREMENT,
    customer VARCHAR(500),   -- Vấn đề 1
    product  TEXT,           -- Vấn đề 2
    qty      INT,            -- Vấn đề 3
    price    FLOAT,          -- Vấn đề 4
    discount INT,
    address  VARCHAR(1000),  -- Vấn đề 5
    note     VARCHAR(50),    -- Vấn đề 6
    date     DATETIME,
    status   VARCHAR(20)     -- Vấn đề 7
);
```

| STT | Vấn đề                                  | Tại sao là vấn đề                                                                    | Cách sửa                                                                                |
| --- | --------------------------------------- | ------------------------------------------------------------------------------------ | --------------------------------------------------------------------------------------- |
| 1   | `customer VARCHAR(500)` lưu tên         | Vi phạm chuẩn hóa - không thể lọc đơn theo khách, không có lịch sử mua hàng          | Dùng `customer_id INT FK` trỏ vào bảng `users`                                          |
| 2   | `product TEXT` lưu tên sản phẩm         | Một đơn có nhiều sản phẩm - không thể nhét vào một ô TEXT, không tính được tổng tiền | Tách thành bảng `order_items(order_id, product_id, quantity, unit_price)`               |
| 3   | `qty INT` không có constraint           | Số lượng có thể âm hoặc NULL - vô nghĩa về nghiệp vụ                                 | Thêm `NOT NULL` và `CHECK (qty > 0)`                                                    |
| 4   | `price FLOAT` để lưu tiền               | `FLOAT` có sai số làm tròn nhị phân, gây lỗi tài chính                               | Dùng `DECIMAL(15, 0)` cho VNĐ                                                           |
| 5   | `address VARCHAR(1000)` lưu địa chỉ thô | Không lọc được theo tỉnh/quận, không tích hợp được với đơn vị vận chuyển             | Tách thành `shipping_province`, `shipping_district`, `shipping_ward`, `shipping_street` |
| 6   | `note VARCHAR(50)` quá ngắn             | Ghi chú đơn hàng thường dài hơn 50 ký tự                                             | Đổi thành `note TEXT`                                                                   |
| 7   | `status VARCHAR(20)` không ràng buộc    | Có thể nhập giá trị sai ('PANDING', 'done',...) - không nhất quán                    | Dùng `ENUM('pending', 'confirmed', 'shipping', 'delivered', 'cancelled')`               |

---

## Bài 4.1 - TestingSystem mở rộng

### Bảng mới cần thêm

```sql
-- 1. Giao đề thi cho Group (quan hệ N-N)
CREATE TABLE ExamGroup (
    ExamID      INT         NOT NULL,
    GroupID     INT         NOT NULL,
    AssignedAt  DATETIME    DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (ExamID, GroupID),
    FOREIGN KEY (ExamID)  REFERENCES Exam(ExamID)     ON DELETE CASCADE,
    FOREIGN KEY (GroupID) REFERENCES `Group`(GroupID) ON DELETE CASCADE
);

-- 2. Lưu lượt làm bài thi của Account
CREATE TABLE ExamAttempt (
    AttemptID   INT             NOT NULL AUTO_INCREMENT,
    ExamID      INT             NOT NULL,
    AccountID   INT             NOT NULL,
    StartedAt   DATETIME        NOT NULL,
    SubmittedAt DATETIME        DEFAULT NULL,
    Score       DECIMAL(5, 2)   DEFAULT NULL,
    PRIMARY KEY (AttemptID),
    FOREIGN KEY (ExamID)    REFERENCES Exam(ExamID)       ON DELETE RESTRICT,
    FOREIGN KEY (AccountID) REFERENCES Account(AccountID) ON DELETE RESTRICT,
    CONSTRAINT chk_score CHECK (Score >= 0)
);

-- 3. Câu trả lời cụ thể cho từng câu hỏi trong lượt thi
CREATE TABLE AttemptAnswer (
    AttemptID   INT         NOT NULL,
    QuestionID  INT         NOT NULL,
    AnswerID    INT         DEFAULT NULL,   -- NULL nếu câu hỏi Essay
    EssayText   TEXT        DEFAULT NULL,   -- Nội dung trả lời Essay
    IsCorrect   TINYINT(1)  DEFAULT NULL,
    PRIMARY KEY (AttemptID, QuestionID),
    FOREIGN KEY (AttemptID)  REFERENCES ExamAttempt(AttemptID) ON DELETE CASCADE,
    FOREIGN KEY (QuestionID) REFERENCES Question(QuestionID)   ON DELETE RESTRICT,
    FOREIGN KEY (AnswerID)   REFERENCES Answer(AnswerID)       ON DELETE SET NULL
);
```

### Bảng cũ cần sửa đổi

```sql
-- Thêm Role vào Account để hỗ trợ phân quyền
ALTER TABLE Account
ADD COLUMN Role ENUM('admin', 'creator') NOT NULL DEFAULT 'creator';
```

### Xử lý câu hỏi Essay không có Answer

Trong `AttemptAnswer`:

- Câu hỏi **Multiple-Choice**: điền `AnswerID`, để `EssayText = NULL`
- Câu hỏi **Essay**: để `AnswerID = NULL`, điền nội dung vào `EssayText`

Có thể thêm CHECK constraint để đảm bảo tính nhất quán:

```sql
ALTER TABLE AttemptAnswer
ADD CONSTRAINT chk_answer_type
CHECK (
    (AnswerID IS NOT NULL AND EssayText IS NULL) OR
    (AnswerID IS NULL     AND EssayText IS NOT NULL)
);
```

---

## Bài 4.2 - So sánh phương án thiết kế địa chỉ

| Tiêu chí            | Phương án A (gộp vào users) | Phương án B (bảng riêng)    |
| ------------------- | --------------------------- | --------------------------- |
| Số địa chỉ mỗi user | Chỉ 1                       | Nhiều                       |
| Cấu trúc địa chỉ    | Chuỗi thô                   | Tách tỉnh/quận/phường/đường |
| Lọc theo tỉnh/thành | Không thể                   | Dễ dàng                     |
| Validate format     | Khó                         | Dễ                          |
| Độ phức tạp schema  | Thấp                        | Cao hơn                     |

**Chọn Phương án A khi:**

- Ứng dụng nội bộ đơn giản, địa chỉ chỉ để hiển thị
- Mỗi user chỉ có một địa chỉ duy nhất
- Không cần lọc theo địa lý
- Prototype/MVP cần ra nhanh

**Chọn Phương án B khi:**

- E-commerce: khách có thể có nhiều địa chỉ giao hàng
- Cần lọc đơn hàng theo tỉnh/thành hoặc tính phí ship theo khu vực
- Cần tích hợp với đơn vị vận chuyển (GHN, GHTK,...)
- Cần hỗ trợ `is_default` để chọn địa chỉ mặc định

---

## Bài 4.3 - Tư duy thiết kế

### Câu 1 - Tại sao dùng Composite PK thay vì ID riêng?

Composite PK `(GroupID, AccountID)` thể hiện đúng ngữ nghĩa: **một user chỉ tham gia một group một lần**. Nếu dùng ID riêng, database không thể ngăn chặn insert trùng:

```sql
-- Nếu có ID riêng, hai row này đều hợp lệ dù trùng nghiệp vụ:
INSERT INTO GroupAccount (ID, GroupID, AccountID) VALUES (1, 1, 5);
INSERT INTO GroupAccount (ID, GroupID, AccountID) VALUES (2, 1, 5); -- trùng!

-- Với Composite PK, row thứ hai bị reject ngay ở database layer
```

Ngoài ra Composite PK tự động tạo index cho cả hai column, tối ưu truy vấn theo cả hai chiều (tìm theo GroupID hoặc theo AccountID).

### Câu 2 - Lưu lịch sử đổi Position

Schema hiện tại **không đáp ứng được**. `Account.PositionID` chỉ lưu vị trí hiện tại - khi UPDATE thì mất thông tin cũ.

Cần thêm bảng lịch sử:

```sql
CREATE TABLE AccountPositionHistory (
    HistoryID       INT         NOT NULL AUTO_INCREMENT,
    AccountID       INT         NOT NULL,
    OldPositionID   INT         DEFAULT NULL,
    NewPositionID   INT         NOT NULL,
    ChangedAt       DATETIME    DEFAULT CURRENT_TIMESTAMP,
    ChangedBy       INT         DEFAULT NULL,
    PRIMARY KEY (HistoryID),
    FOREIGN KEY (AccountID)     REFERENCES Account(AccountID)   ON DELETE CASCADE,
    FOREIGN KEY (OldPositionID) REFERENCES Position(PositionID) ON DELETE SET NULL,
    FOREIGN KEY (NewPositionID) REFERENCES Position(PositionID) ON DELETE RESTRICT,
    FOREIGN KEY (ChangedBy)     REFERENCES Account(AccountID)   ON DELETE SET NULL
);
```

Mỗi lần thay đổi: INSERT vào `AccountPositionHistory` trước, sau đó UPDATE `Account.PositionID`. Đây là pattern **Audit Log** phổ biến trong hệ thống HR và ERP.

### Câu 3 - Hỗ trợ đáp án đúng có trọng số

`isCorrect TINYINT(1)` chỉ biểu diễn đúng/sai nhị phân - không đáp ứng được yêu cầu trọng số.

```sql
-- Xóa column cũ
ALTER TABLE Answer DROP COLUMN isCorrect;

-- Thêm column score thay thế
ALTER TABLE Answer
ADD COLUMN Score DECIMAL(5, 2) NOT NULL DEFAULT 0,
ADD CONSTRAINT chk_answer_score CHECK (Score >= 0 AND Score <= 100);
```

Ý nghĩa của `Score`: `0` = sai, `100` = đúng hoàn toàn, `40` = đúng một phần với trọng số 40%.

Khi tính điểm: lấy `SUM(Score)` của các đáp án user chọn chia cho `SUM(Score)` của tất cả đáp án đúng trong câu hỏi đó.

### Câu 4 - Index cho Question và Answer

**Vấn đề khi thiếu index:** MySQL phải duyệt toàn bộ bảng (Full Table Scan) cho mỗi truy vấn. Với 1 triệu rows, mỗi query có thể mất vài giây thay vì vài millisecond.

```sql
-- Bảng Question
CREATE INDEX idx_question_category ON Question (CategoryID);   -- lọc theo chủ đề
CREATE INDEX idx_question_type     ON Question (TypeID);       -- lọc theo loại câu hỏi
CREATE INDEX idx_question_creator  ON Question (CreatorID);    -- lọc theo người tạo
CREATE INDEX idx_question_date     ON Question (CreateDate);   -- sắp xếp theo ngày

-- Bảng Answer
CREATE INDEX idx_answer_question ON Answer (QuestionID);              -- JOIN từ Question
CREATE INDEX idx_answer_correct  ON Answer (QuestionID, isCorrect);   -- lọc đáp án đúng
```

**Lưu ý:** Index tăng tốc `SELECT` nhưng làm chậm `INSERT`/`UPDATE`/`DELETE`. Chỉ đánh index trên column thường xuất hiện trong `WHERE`, `JOIN ON`, `ORDER BY`. `PRIMARY KEY` và `FOREIGN KEY` đã tự động có index trong MySQL.

---
