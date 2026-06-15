-- Category có hơn 5 câu hỏi
SELECT CategoryID, COUNT(*) AS TotalQuestions
FROM Question
GROUP BY
    CategoryID
HAVING
    COUNT(*) > 5;

-- Creator đã tạo từ 3 đề thi trở lên
SELECT CreatorID, COUNT(*) AS TotalExams
FROM Exam
GROUP BY
    CreatorID
HAVING
    COUNT(*) >= 3;

-- Department có từ 2 account trở lên, sắp xếp theo số lượng giảm dần
SELECT DepartmentID, COUNT(*) AS TotalAccounts
FROM Account
GROUP BY
    DepartmentID
HAVING
    COUNT(*) >= 2
ORDER BY TotalAccounts DESC;