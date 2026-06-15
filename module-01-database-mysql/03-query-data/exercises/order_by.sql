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
WHERE
    Duration >= 60
ORDER BY Duration DESC;