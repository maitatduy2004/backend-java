USE TestingSystem;
-- Lọc các hàng thỏa ãn điều kiện
SELECT * FROM Account WHERE DepartmentID = 1;

-- Lấy các đề thi có thời gian dưới 30 phút
SELECT * FROM exam WHERE Duration <= 30;

-- Lấy các câu hỏi không thuộc category ID = 3
SELECT * FROM Question WHERE CategoryID != 3;

-- Account thuộc department 1 VÀ position 2
SELECT * FROM Account WHERE DepartmentID = 1 AND PositionID = 2;

-- Account thuộc department 1 HOẶC department 2
SELECT * FROM Account WHERE DepartmentID = 1 OR DepartmentID = 2;

-- Kết hợp AND và OR - dùng ngoặc để rõ ràng thứ tự ưu tiên
SELECT *
FROM Question
WHERE (
        CategoryID = 1
        OR CategoryID = 2
    )
    AND TypeID = 1;

-- Đề thi có thời gian từ 30 đến 90 phút
SELECT * FROM Exam WHERE Duration BETWEEN 30 AND 90;

-- Account tạo trong tháng 1/2024
SELECT *
FROM Account
WHERE
    CreateDate BETWEEN '2024-01-01' AND '2024-01-31 23:59:59';

-- NOT BETWEEN
SELECT * FROM Exam WHERE Duration NOT BETWEEN 30 AND 90;

-- Câu hỏi thuộc category 1, 2 hoặc 3
SELECT * FROM Question WHERE CategoryID IN (1, 2, 3);

-- Tương đương với
SELECT *
FROM Question
WHERE
    CategoryID = 1
    OR CategoryID = 2
    OR CategoryID = 3;

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

-- Account chưa được gán phòng ban
SELECT * FROM Account WHERE DepartmentID IS NULL;

-- Account đã có phòng ban
SELECT * FROM Account WHERE DepartmentID IS NOT NULL;

-- Câu hỏi chưa có câu trả lời nào (join sẽ học sau, ví dụ minh họa khái niệm)
SELECT * FROM Answer WHERE Content IS NULL;