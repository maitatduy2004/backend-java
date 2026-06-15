# SQL - SELECT, WHERE, Aggregate Functions

---

## Mục lục

1. [SELECT & FROM](#1-select--from)
2. [WHERE](#2-where)
   - [2.1 Toán tử so sánh](#21-toán-tử-so-sánh)
   - [2.2 Toán tử logic](#22-toán-tử-logic)
   - [2.3 BETWEEN AND](#23-between-and)
   - [2.4 IN / NOT IN](#24-in--not-in)
   - [2.5 LIKE / NOT LIKE](#25-like--not-like)
   - [2.6 IS NULL / IS NOT NULL](#26-is-null--is-not-null)
3. [DISTINCT](#3-distinct)
4. [ORDER BY](#4-order-by)
5. [LIMIT](#5-limit)
6. [Alias](#6-alias)
7. [Aggregate Functions](#7-aggregate-functions)
8. [GROUP BY](#8-group-by)
9. [HAVING](#9-having)
10. [INSERT, UPDATE, DELETE](#10-insert-update-delete)
11. [Thứ tự thực thi câu lệnh SQL](#11-thứ-tự-thực-thi-câu-lệnh-sql)

---

> Toàn bộ ví dụ trong tài liệu này sử dụng database `TestingSystem`.

---

## 1. SELECT & FROM

`SELECT` dùng để chỉ định các column cần lấy. `FROM` chỉ định bảng nguồn.

```sql
-- Lấy tất cả các column
SELECT * FROM Account;

-- Lấy một số column cụ thể
SELECT AccountID, FullName, Email FROM Account;

-- Lấy column từ nhiều bảng (chỉ định rõ tên bảng để tránh nhầm)
SELECT Account.FullName, Department.DepartmentName
FROM Account, Department;
```

> **Lưu ý:** Tránh dùng `SELECT *` trong môi trường production vì lấy thừa dữ liệu, ảnh hưởng hiệu năng. Chỉ nên dùng khi khám phá dữ liệu.

---

## 2. WHERE

`WHERE` lọc các hàng thỏa mãn điều kiện trước khi trả về kết quả.

```sql
SELECT * FROM Account WHERE DepartmentID = 1;
```

---

### 2.1 Toán tử so sánh

| Toán tử        | Ý nghĩa           | Ví dụ                  |
| -------------- | ----------------- | ---------------------- |
| `=`            | Bằng              | `DepartmentID = 2`     |
| `!=` hoặc `<>` | Khác              | `Status != 'inactive'` |
| `>`            | Lớn hơn           | `Duration > 60`        |
| `<`            | Nhỏ hơn           | `Duration < 30`        |
| `>=`           | Lớn hơn hoặc bằng | `Duration >= 60`       |
| `<=`           | Nhỏ hơn hoặc bằng | `Duration <= 120`      |

```sql
-- Lấy các đề thi có thời gian trên 60 phút
SELECT ExamID, Title, Duration FROM Exam WHERE Duration > 60;

-- Lấy các câu hỏi không thuộc category ID = 3
SELECT * FROM Question WHERE CategoryID <> 3;
```

---

### 2.2 Toán tử logic

| Toán tử | Ý nghĩa                    |
| ------- | -------------------------- |
| `AND`   | Tất cả điều kiện phải đúng |
| `OR`    | Ít nhất một điều kiện đúng |

```sql
-- Account thuộc department 1 VÀ position 2
SELECT * FROM Account
WHERE DepartmentID = 1 AND PositionID = 2;

-- Account thuộc department 1 HOẶC department 2
SELECT * FROM Account
WHERE DepartmentID = 1 OR DepartmentID = 2;

-- Kết hợp AND và OR - dùng ngoặc để rõ ràng thứ tự ưu tiên
SELECT * FROM Question
WHERE (CategoryID = 1 OR CategoryID = 2) AND TypeID = 1;
```

> **Lưu ý:** `AND` có độ ưu tiên cao hơn `OR`. Luôn dùng dấu ngoặc khi kết hợp cả hai để tránh kết quả ngoài ý muốn.

---

### 2.3 BETWEEN AND

Lọc giá trị nằm trong một khoảng, **bao gồm cả hai đầu mút**.

```sql
-- Cú pháp
WHERE column BETWEEN value1 AND value2

-- Đề thi có thời gian từ 30 đến 90 phút
SELECT * FROM Exam WHERE Duration BETWEEN 30 AND 90;

-- Account tạo trong tháng 1/2024
SELECT * FROM Account
WHERE CreateDate BETWEEN '2024-01-01' AND '2024-01-31 23:59:59';

-- NOT BETWEEN
SELECT * FROM Exam WHERE Duration NOT BETWEEN 30 AND 90;
```

---

### 2.4 IN / NOT IN

Lọc giá trị nằm trong một tập hợp cho trước. Gọn hơn nhiều lần `OR`.

```sql
-- Câu hỏi thuộc category 1, 2 hoặc 3
SELECT * FROM Question WHERE CategoryID IN (1, 2, 3);

-- Tương đương với
SELECT * FROM Question
WHERE CategoryID = 1 OR CategoryID = 2 OR CategoryID = 3;

-- Câu hỏi KHÔNG thuộc các category đó
SELECT * FROM Question WHERE CategoryID NOT IN (1, 2, 3);

-- IN với chuỗi
SELECT * FROM Position WHERE PositionName IN ('Dev', 'Test');
```

---

### 2.5 LIKE / NOT LIKE

Tìm kiếm theo mẫu chuỗi. Dùng ký tự đại diện (wildcard):

| Ký tự | Ý nghĩa                                |
| ----- | -------------------------------------- |
| `%`   | Thay thế cho 0 hoặc nhiều ký tự bất kỳ |
| `_`   | Thay thế cho đúng 1 ký tự bất kỳ       |

```sql
-- FullName bắt đầu bằng "Nguyen"
SELECT * FROM Account WHERE FullName LIKE 'Nguyen%';

-- Email kết thúc bằng "@gmail.com"
SELECT * FROM Account WHERE Email LIKE '%@gmail.com';

-- FullName chứa chữ "an" ở bất kỳ vị trí nào
SELECT * FROM Account WHERE FullName LIKE '%an%';

-- Username có đúng 5 ký tự
SELECT * FROM Account WHERE Username LIKE '_____';

-- Username bắt đầu bằng "dev" và có đúng 6 ký tự tổng
SELECT * FROM Account WHERE Username LIKE 'dev___';

-- NOT LIKE
SELECT * FROM Account WHERE Email NOT LIKE '%@gmail.com';
```

> **Lưu ý:** `LIKE` với `%` ở đầu (`'%keyword'`) sẽ không dùng được index, gây chậm khi bảng lớn. Cân nhắc dùng Full-Text Search cho các trường hợp tìm kiếm phức tạp.

---

### 2.6 IS NULL / IS NOT NULL

Kiểm tra giá trị `NULL`. **Không thể** dùng `= NULL` hay `!= NULL`.

```sql
-- Account chưa được gán phòng ban
SELECT * FROM Account WHERE DepartmentID IS NULL;

-- Account đã có phòng ban
SELECT * FROM Account WHERE DepartmentID IS NOT NULL;

-- Câu hỏi chưa có câu trả lời nào (join sẽ học sau, ví dụ minh họa khái niệm)
SELECT * FROM Answer WHERE Content IS NULL;
```

---

## 3. DISTINCT

Loại bỏ các hàng trùng lặp trong kết quả.

```sql
-- Lấy danh sách các DepartmentID đang có Account
SELECT DISTINCT DepartmentID FROM Account;

-- Lấy danh sách các CategoryID đang có Question
SELECT DISTINCT CategoryID FROM Question;

-- DISTINCT trên nhiều column - trùng lặp khi cả hai column đều giống nhau
SELECT DISTINCT DepartmentID, PositionID FROM Account;
```

---

## 4. ORDER BY

Sắp xếp kết quả theo một hoặc nhiều column.

```sql
-- Sắp xếp tăng dần (mặc định ASC)
SELECT * FROM Account ORDER BY FullName ASC;

-- Sắp xếp giảm dần
SELECT * FROM Exam ORDER BY CreateDate DESC;

-- Sắp xếp theo nhiều tiêu chí
-- Ưu tiên theo CategoryID tăng dần, trong cùng category thì theo CreateDate mới nhất
SELECT * FROM Question ORDER BY CategoryID ASC, CreateDate DESC;

-- Sắp xếp kết hợp với WHERE
SELECT ExamID, Title, Duration
FROM Exam
WHERE Duration >= 60
ORDER BY Duration DESC;
```

---

## 5. LIMIT

Giới hạn số hàng trả về. Thường dùng cho phân trang (pagination).

```sql
-- Lấy 5 account đầu tiên
SELECT * FROM Account LIMIT 5;

-- Bỏ qua 10 hàng đầu, lấy 5 hàng tiếp theo (trang 3, mỗi trang 5 items)
SELECT * FROM Account LIMIT 5 OFFSET 10;

-- Viết tắt: LIMIT offset, count
SELECT * FROM Account LIMIT 10, 5;

-- Top 3 đề thi mới nhất
SELECT ExamID, Title, CreateDate
FROM Exam
ORDER BY CreateDate DESC
LIMIT 3;
```

**Công thức phân trang:**

```
OFFSET = (page - 1) * pageSize
LIMIT  = pageSize

-- Trang 1, 10 items/trang: LIMIT 10 OFFSET 0
-- Trang 2, 10 items/trang: LIMIT 10 OFFSET 10
-- Trang 3, 10 items/trang: LIMIT 10 OFFSET 20
```

---

## 6. Alias

Đặt tên tạm thời cho column hoặc bảng trong câu truy vấn. Dùng từ khóa `AS` (có thể bỏ qua `AS`).

```sql
-- Alias cho column
SELECT
    AccountID   AS id,
    FullName    AS name,
    Email       AS email
FROM Account;

-- Alias cho bảng (hữu ích khi join hoặc subquery)
SELECT a.FullName, a.Email
FROM Account AS a
WHERE a.DepartmentID = 1;

-- Alias trong tính toán
SELECT
    ExamID,
    Title,
    Duration,
    Duration / 60 AS DurationInHours
FROM Exam;
```

---

## 7. Aggregate Functions

Hàm tổng hợp thực hiện tính toán trên một tập hợp các hàng và trả về **một giá trị duy nhất**.

| Hàm             | Ý nghĩa                          |
| --------------- | -------------------------------- |
| `COUNT(*)`      | Đếm tổng số hàng                 |
| `COUNT(column)` | Đếm số hàng có giá trị khác NULL |
| `SUM(column)`   | Tính tổng                        |
| `AVG(column)`   | Tính trung bình                  |
| `MIN(column)`   | Giá trị nhỏ nhất                 |
| `MAX(column)`   | Giá trị lớn nhất                 |

```sql
-- Tổng số account trong hệ thống
SELECT COUNT(*) AS TotalAccounts FROM Account;

-- Tổng số câu hỏi có creator (khác NULL)
SELECT COUNT(CreatorID) AS TotalWithCreator FROM Question;

-- Thời gian thi trung bình
SELECT AVG(Duration) AS AvgDuration FROM Exam;

-- Thời gian thi ngắn nhất và dài nhất
SELECT MIN(Duration) AS MinDuration, MAX(Duration) AS MaxDuration FROM Exam;

-- Tổng số đề thi được tạo bởi creator ID = 1
SELECT COUNT(*) AS TotalExams FROM Exam WHERE CreatorID = 1;
```

> **Phân biệt `COUNT(*)` và `COUNT(column)`:**
>
> - `COUNT(*)` đếm tất cả các hàng, kể cả hàng có giá trị NULL
> - `COUNT(column)` chỉ đếm các hàng có giá trị khác NULL ở column đó

---

## 8. GROUP BY

Nhóm các hàng có cùng giá trị ở một hoặc nhiều column, thường dùng kết hợp với Aggregate Functions.

```sql
-- Đếm số câu hỏi theo từng category
SELECT CategoryID, COUNT(*) AS TotalQuestions
FROM Question
GROUP BY CategoryID;

-- Đếm số account theo từng department
SELECT DepartmentID, COUNT(*) AS TotalAccounts
FROM Account
GROUP BY DepartmentID;

-- Đếm số đề thi theo từng creator, sắp xếp giảm dần
SELECT CreatorID, COUNT(*) AS TotalExams
FROM Exam
GROUP BY CreatorID
ORDER BY TotalExams DESC;

-- GROUP BY nhiều column
-- Số câu hỏi theo từng cặp (CategoryID, TypeID)
SELECT CategoryID, TypeID, COUNT(*) AS Total
FROM Question
GROUP BY CategoryID, TypeID;
```

> **Quy tắc quan trọng:** Trong `SELECT`, chỉ được phép dùng:
>
> - Các column xuất hiện trong `GROUP BY`
> - Aggregate functions
>
> Không thể `SELECT` một column không nằm trong `GROUP BY` mà không bọc trong aggregate function.

---

## 9. HAVING

Lọc kết quả **sau khi** đã `GROUP BY`. Tương tự `WHERE` nhưng áp dụng cho nhóm, không phải hàng.

```sql
-- Category có hơn 5 câu hỏi
SELECT CategoryID, COUNT(*) AS TotalQuestions
FROM Question
GROUP BY CategoryID
HAVING COUNT(*) > 5;

-- Creator đã tạo từ 3 đề thi trở lên
SELECT CreatorID, COUNT(*) AS TotalExams
FROM Exam
GROUP BY CreatorID
HAVING COUNT(*) >= 3;

-- Department có từ 2 account trở lên, sắp xếp theo số lượng giảm dần
SELECT DepartmentID, COUNT(*) AS TotalAccounts
FROM Account
GROUP BY DepartmentID
HAVING COUNT(*) >= 2
ORDER BY TotalAccounts DESC;
```

**Phân biệt `WHERE` và `HAVING`:**

|                         | WHERE          | HAVING                   |
| ----------------------- | -------------- | ------------------------ |
| Lọc                     | Từng hàng      | Từng nhóm (sau GROUP BY) |
| Dùng Aggregate function | Không          | Có                       |
| Thứ tự thực thi         | Trước GROUP BY | Sau GROUP BY             |

```sql
-- WHERE và HAVING kết hợp
-- Đếm số câu hỏi của category 1, 2, 3 - chỉ lấy category có trên 3 câu hỏi
SELECT CategoryID, COUNT(*) AS Total
FROM Question
WHERE CategoryID IN (1, 2, 3)
GROUP BY CategoryID
HAVING COUNT(*) > 3;
```

---

## 10. INSERT, UPDATE, DELETE

### 10.1 INSERT

```sql
-- Insert một hàng, chỉ định column
INSERT INTO Department (DepartmentName)
VALUES ('Engineering');

-- Insert nhiều hàng cùng lúc
INSERT INTO Position (PositionName) VALUES
('Dev'),
('Test'),
('Scrum Master'),
('PM');

-- Insert với đầy đủ column (phải đúng thứ tự)
INSERT INTO Account (Email, Username, FullName, DepartmentID, PositionID)
VALUES ('john@example.com', 'johndoe', 'John Doe', 1, 1);
```

### 10.2 UPDATE

```sql
-- Cập nhật một column
UPDATE Account
SET DepartmentID = 2
WHERE AccountID = 5;

-- Cập nhật nhiều column
UPDATE Account
SET DepartmentID = 3, PositionID = 2
WHERE AccountID = 5;

-- Cập nhật nhiều hàng cùng lúc
UPDATE Exam
SET Duration = 90
WHERE CategoryID = 1 AND Duration < 60;
```

> **Cảnh báo:** Luôn kiểm tra `WHERE` bằng `SELECT` trước khi `UPDATE`. `UPDATE` không có `WHERE` sẽ cập nhật **tất cả** các hàng trong bảng.

### 10.3 DELETE

```sql
-- Xóa một hàng cụ thể
DELETE FROM Account WHERE AccountID = 10;

-- Xóa nhiều hàng theo điều kiện
DELETE FROM Answer WHERE QuestionID = 5;

-- Xóa tất cả hàng trong bảng (giữ lại cấu trúc bảng)
DELETE FROM GroupAccount;

-- TRUNCATE - xóa toàn bộ dữ liệu, nhanh hơn DELETE, reset AUTO_INCREMENT
TRUNCATE TABLE GroupAccount;
```

> **Phân biệt `DELETE` và `TRUNCATE`:**
>
> - `DELETE` có thể dùng `WHERE`, ghi log từng hàng, có thể rollback
> - `TRUNCATE` xóa toàn bộ, không ghi log từng hàng, reset AUTO_INCREMENT, không thể rollback

---

## 11. Thứ tự thực thi câu lệnh SQL

Thứ tự **viết** và thứ tự **thực thi** của SQL khác nhau. Hiểu điều này giúp tránh nhiều lỗi phổ biến.

```sql
SELECT   CategoryID, COUNT(*) AS Total   -- 6. Chọn column để hiển thị
FROM     Question                        -- 1. Xác định bảng nguồn
WHERE    TypeID = 1                      -- 2. Lọc hàng
GROUP BY CategoryID                      -- 3. Nhóm
HAVING   COUNT(*) > 2                    -- 4. Lọc nhóm
ORDER BY Total DESC                      -- 5. Sắp xếp
LIMIT    5;                              -- 7. Giới hạn kết quả
```

**Thứ tự thực thi thực tế:**

```
FROM → WHERE → GROUP BY → HAVING → SELECT → ORDER BY → LIMIT
```

> Đây là lý do tại sao **không thể dùng alias trong WHERE hoặc HAVING** - alias được định nghĩa ở bước `SELECT`, nhưng `WHERE` và `HAVING` được thực thi trước đó.

```sql
-- LỖI: alias 'Total' chưa tồn tại khi HAVING chạy
SELECT CategoryID, COUNT(*) AS Total
FROM Question
GROUP BY CategoryID
HAVING Total > 2;        -- Lỗi ở MySQL strict mode

-- ĐÚNG: dùng lại aggregate function
SELECT CategoryID, COUNT(*) AS Total
FROM Question
GROUP BY CategoryID
HAVING COUNT(*) > 2;     -- Đúng
```

---
