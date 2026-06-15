USE TestingSystem;

-- Lấy toàn bộ column
SELECT * FROM Account;

-- Lấy một số cột cụ thể
SELECT AccountID, FullName, Email From Account;

-- Lấy cột từ nhiều bảng, lưu ý phải chỉ rõ tên bảng để tránh nhầm lẫn
SELECT Account.FullName, Department.DepartmentName
FROM Account, Department;