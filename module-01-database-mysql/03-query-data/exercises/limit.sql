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