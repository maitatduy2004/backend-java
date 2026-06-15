-- Alias cho column
SELECT
    AccountID AS id,
    FullName AS name,
    Email AS email
FROM Account;

-- Alias cho bảng (hữu ích khi join hoặc subquery)
SELECT a.FullName, a.Email
FROM Account AS a
WHERE
    a.DepartmentID = 1;

-- Alias trong tính toán
SELECT
    ExamID,
    Title,
    Duration,
    Duration / 60 AS DurationInHours
FROM Exam;