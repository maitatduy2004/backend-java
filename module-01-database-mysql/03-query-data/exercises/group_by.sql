-- Đếm số câu hỏi theo từng category
SELECT CategoryID, COUNT(*) AS TotalQuestions
FROM Question
GROUP BY
    CategoryID;

-- Đếm số đề thi theo từng creator, sắp xếp giảm dần
SELECT CreatorID, COUNT(*) AS TotalExams
FROM Exam
GROUP BY
    CreatorID
ORDER BY TotalExams DESC;

-- GROUP BY nhiều column
-- Số câu hỏi theo từng cặp (CategoryID, TypeID)
SELECT CategoryID, TypeID, COUNT(*) AS Total
FROM Question
GROUP BY
    CategoryID,
    TypeID;