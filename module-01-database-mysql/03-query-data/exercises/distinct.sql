-- Lấy danh sách các DepartmentID đang có Account
SELECT DISTINCT DepartmentID FROM Account;

-- Lấy danh sách các CategoryID đang có Question
SELECT DISTINCT CategoryID FROM Question;

-- DISTINCT trên nhiều column - trùng lặp khi cả hai column đều giống nhau
SELECT DISTINCT DepartmentID, PositionID FROM Account;