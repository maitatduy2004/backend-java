-- Tổng số account trong hệ thống
SELECT COUNT(*) AS TotalAccounts FROM Account;

-- Tổng số câu hỏi có creator (khác NULL)
SELECT COUNT(CreatorID) AS TotalWithCreator FROM Question;

-- Thời gian thi trung bình
SELECT AVG(Duration) AS AvgDuration FROM Exam;

-- Thời gian thi ngắn nhất và dài nhất
SELECT MIN(Duration) AS MinDuration, MAX(Duration) AS MaxDuration
FROM Exam;

-- Tổng số đề thi được tạo bởi creator ID = 1
SELECT COUNT(*) AS TotalExams FROM Exam WHERE CreatorID = 1;