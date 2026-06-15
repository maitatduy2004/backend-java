# SQL - Bài tập tổng quan về database

---

## Mục lục

1. [Bài tập bắt buộc](#1-bài-tập-bắt-buộc)
2. [Bài tập cơ bản](#2-bài-tập-cơ-bản)
3. [Bài tập trung cấp](#3-bài-tập-trung-cấp)
4. [Bài tập nâng cao](#4-bài-tập-nâng-cao)
5. [Đáp án gợi ý](#5-đáp-án-gợi-ý)

---

## 1. Bài tập bắt buộc

Tạo database `TestingSystem` và 11 bảng dữ liệu với đầy đủ ràng buộc và kiểu dữ liệu phù hợp.

**Danh sách bảng:**

| Bảng               | Mô tả                     |
| ------------------ | ------------------------- |
| `Department`       | Phòng ban                 |
| `Position`         | Chức vụ                   |
| `Account`          | Tài khoản người dùng      |
| `Group`            | Nhóm                      |
| `GroupAccount`     | Quan hệ người dùng - nhóm |
| `TypeQuestion`     | Loại câu hỏi              |
| `CategoryQuestion` | Chủ đề câu hỏi            |
| `Question`         | Câu hỏi                   |
| `Answer`           | Câu trả lời               |
| `Exam`             | Đề thi                    |
| `ExamQuestion`     | Quan hệ đề thi - câu hỏi  |

**Yêu cầu:**

- Chọn đúng datatype cho từng column
- Áp dụng đầy đủ constraint phù hợp (PK, FK, NOT NULL, UNIQUE, DEFAULT, CHECK)
- Đảm bảo các quan hệ FK đúng chiều tham chiếu

---

## 2. Bài tập cơ bản

### Bài 2.1 - Tạo database độc lập

Tạo database `LibraryDB` với 3 bảng sau, tự thiết kế datatype và constraint phù hợp:

**Bảng `Author`:**

- AuthorID, FullName, Nationality, BirthDate

**Bảng `Book`:**

- BookID, Title, AuthorID, PublishedYear, Price, Stock

**Bảng `Member`:**

- MemberID, FullName, Email, Phone, RegisterDate

---

### Bài 2.2 - Nhận diện lỗi

Đoạn SQL dưới đây có **4 lỗi**. Tìm và sửa tất cả:

```sql
CREATE TABLE employees (
    EmployeeID      INT,
    FullName        VARCHAR,
    Email           VARCHAR(150) UNIQUE NOT NULL,
    Salary          DECIMAL(10),
    DepartmentID    INT NOT NULL,
    HireDate        DATE DEFAULT '2024-01-01',
    PRIMARY KEY,
    FOREIGN KEY (DepartmentID) REFERENCES Department
);
```

---

### Bài 2.3 - Chọn datatype đúng

Với mỗi trường dữ liệu dưới đây, chọn datatype phù hợp nhất và giải thích lý do:

| STT | Trường dữ liệu                                | Datatype của bạn | Lý do |
| --- | --------------------------------------------- | ---------------- | ----- |
| 1   | Số điện thoại VN (10 chữ số)                  | ?                | ?     |
| 2   | Điểm thi (0.0 đến 10.0)                       | ?                | ?     |
| 3   | Trạng thái đơn hàng (pending/paid/cancelled)  | ?                | ?     |
| 4   | Nội dung bài viết blog                        | ?                | ?     |
| 5   | Mã quốc gia (VN, US, JP)                      | ?                | ?     |
| 6   | Số lượng tồn kho (không âm)                   | ?                | ?     |
| 7   | Giá tiền (VD: 1,250,000 VNĐ)                  | ?                | ?     |
| 8   | Ảnh đại diện (lưu đường dẫn URL)              | ?                | ?     |
| 9   | Thời điểm đăng nhập cuối                      | ?                | ?     |
| 10  | Câu hỏi có phải dạng essay không (true/false) | ?                | ?     |

---

### Bài 2.4 - Điền constraint còn thiếu

Bảng `Student` dưới đây đang thiếu constraint. Điền vào chỗ trống `[?]` cho phù hợp:

```sql
CREATE TABLE Student (
    StudentID   INT             [?] AUTO_INCREMENT,
    Email       VARCHAR(150)    [?] [?],
    FullName    VARCHAR(100)    [?],
    GPA         DECIMAL(3,2)    [?],
    Status      ENUM(...)       [?] DEFAULT 'active',
    ClassID     INT,
    CreatedAt   DATETIME        [?],
    [?] (StudentID),
    [?] (ClassID) REFERENCES Class(ClassID)
);
```

---

### Bài 2.5 - Trả lời câu hỏi lý thuyết

Trả lời ngắn gọn các câu hỏi sau:

1. Sự khác nhau giữa `CHAR(10)` và `VARCHAR(10)` là gì? Cho ví dụ khi nên dùng từng loại.
2. Tại sao không nên dùng `FLOAT` để lưu giá tiền?
3. `PRIMARY KEY` và `UNIQUE KEY` khác nhau ở điểm nào?
4. Khi nào nên dùng `TIMESTAMP` thay vì `DATETIME`?
5. `NOT NULL` và `DEFAULT` có thể dùng cùng nhau không? Cho ví dụ.

---

## 3. Bài tập trung cấp

### Bài 3.1 - Thiết kế schema từ yêu cầu nghiệp vụ

Thiết kế schema cho hệ thống **quản lý bán hàng online** với các yêu cầu sau:

- Hệ thống có khách hàng và nhân viên, đều là "người dùng" nhưng có vai trò khác nhau
- Sản phẩm thuộc về một danh mục, có thể có nhiều ảnh
- Đơn hàng chứa nhiều sản phẩm, mỗi sản phẩm có số lượng và giá tại thời điểm mua
- Đơn hàng có trạng thái: pending → confirmed → shipping → delivered → cancelled
- Mỗi đơn hàng có địa chỉ giao hàng riêng (không phụ thuộc địa chỉ mặc định của khách)

**Yêu cầu nộp:**

- Danh sách bảng và các column với datatype + constraint
- Giải thích các quyết định thiết kế quan trọng (tại sao tách bảng này, tại sao dùng constraint kia)

---

### Bài 3.2 - Phân tích quan hệ

Với schema `TestingSystem` ở bài bắt buộc, trả lời các câu hỏi sau:

1. Vẽ sơ đồ quan hệ (dạng text) giữa các bảng, chỉ rõ loại quan hệ: 1-1, 1-N, hay N-N.
2. Bảng nào là bảng trung gian (junction table)? Composite Primary Key của chúng là gì?
3. Nếu xóa một `Account`, những bảng nào bị ảnh hưởng? Nên dùng `ON DELETE CASCADE` hay `RESTRICT` cho từng trường hợp? Giải thích.
4. `CreatorID` trong bảng `Group` và `Question` tham chiếu đến bảng nào? Ràng buộc gì cần áp dụng?

---

### Bài 3.3 - ALTER TABLE

Sau khi tạo xong `TestingSystem`, thực hiện các thay đổi sau bằng lệnh `ALTER TABLE`:

1. Thêm column `Level` vào bảng `Question` với kiểu `ENUM('easy', 'medium', 'hard')`, mặc định là `'medium'`
2. Thêm column `Description` vào bảng `CategoryQuestion`, kiểu `TEXT`, cho phép NULL
3. Thêm column `PassScore` vào bảng `Exam`, kiểu `DECIMAL(5,2)`, không được âm
4. Đổi tên column `Content` trong bảng `Question` thành `QuestionContent`
5. Xóa column `Duration` khỏi bảng `Exam` (giả sử không còn cần thiết)
6. Thêm constraint: `Code` trong bảng `Exam` phải là UNIQUE

---

### Bài 3.4 - Phát hiện vấn đề thiết kế

Xem xét schema dưới đây và chỉ ra **ít nhất 5 vấn đề** về thiết kế:

```sql
CREATE TABLE Orders (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    customer    VARCHAR(500),
    product     TEXT,
    qty         INT,
    price       FLOAT,
    discount    INT,
    address     VARCHAR(1000),
    note        VARCHAR(50),
    date        DATETIME,
    status      VARCHAR(20)
);
```

Với mỗi vấn đề: nêu vấn đề, giải thích tại sao là vấn đề, và đề xuất cách sửa.

---

## 4. Bài tập nâng cao

### Bài 4.1 - Thiết kế schema thực tế

Thiết kế schema cho hệ thống **Testing System mở rộng** với các yêu cầu bổ sung:

- Một `Exam` có thể được giao cho một hoặc nhiều `Group`
- Khi một `Account` làm bài thi, hệ thống lưu lại: thời điểm bắt đầu, thời điểm nộp, điểm số, và câu trả lời cụ thể cho từng câu hỏi
- Một câu hỏi `Multiple-Choice` có nhiều `Answer`, nhưng câu hỏi `Essay` thì không có `Answer` định sẵn
- Hệ thống cần hỗ trợ phân quyền: `Admin` có thể làm mọi thứ, `Creator` chỉ quản lý được câu hỏi và đề thi do mình tạo

**Yêu cầu nộp:**

- Các bảng mới cần thêm (tên, column, constraint)
- Các bảng cũ cần sửa đổi gì
- Giải thích cách xử lý trường hợp câu hỏi Essay không có Answer

---

### Bài 4.2 - So sánh phương án thiết kế

Có hai cách thiết kế để lưu địa chỉ của người dùng:

**Phương án A:**

```sql
CREATE TABLE users (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    full_name   VARCHAR(100) NOT NULL,
    address     VARCHAR(500)
);
```

**Phương án B:**

```sql
CREATE TABLE users (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    full_name   VARCHAR(100) NOT NULL
);

CREATE TABLE user_addresses (
    id          INT PRIMARY KEY AUTO_INCREMENT,
    user_id     INT NOT NULL,
    province    VARCHAR(100),
    district    VARCHAR(100),
    ward        VARCHAR(100),
    street      VARCHAR(200),
    is_default  TINYINT(1) DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);
```

Phân tích ưu và nhược điểm của từng phương án. Trong trường hợp nào nên chọn A, trong trường hợp nào nên chọn B?

---

### Bài 4.3 - Tư duy thiết kế

Trả lời các câu hỏi sau, mỗi câu cần giải thích rõ lý do:

1. Tại sao `GroupAccount` và `ExamQuestion` không có column `ID` riêng mà dùng Composite Primary Key?
2. Trong `TestingSystem`, nếu muốn lưu lịch sử khi `Account` đổi `Position` (chức vụ), schema hiện tại có đáp ứng được không? Cần thêm gì?
3. Bảng `Answer` đang dùng `isCorrect TINYINT(1)`. Nếu yêu cầu đổi thành hỗ trợ câu hỏi có **nhiều đáp án đúng với trọng số khác nhau** (vd: đáp án A đúng 40%, B đúng 60%), cần thay đổi schema như thế nào?
4. Khi hệ thống có hàng triệu `Question` và `Answer`, việc thiếu index sẽ gây ra vấn đề gì? Nên đánh index trên những column nào của hai bảng này?

---
