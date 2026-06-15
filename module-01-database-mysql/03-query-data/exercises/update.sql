-- Cập nhật một column
UPDATE Account SET DepartmentID = 2 WHERE AccountID = 5;

-- Cập nhật nhiều column
UPDATE Account
SET
    DepartmentID = 3,
    PositionID = 2
WHERE
    AccountID = 5;

-- Cập nhật nhiều hàng cùng lúc
UPDATE Exam SET Duration = 90 WHERE CategoryID = 1 AND Duration < 60;