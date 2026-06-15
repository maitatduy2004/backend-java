-- Xóa một hàng cụ thể
DELETE FROM Account WHERE AccountID = 10;

-- Xóa nhiều hàng theo điều kiện
DELETE FROM Answer WHERE QuestionID = 5;

-- Xóa tất cả hàng trong bảng (giữ lại cấu trúc bảng)
DELETE FROM GroupAccount;

-- TRUNCATE - xóa toàn bộ dữ liệu, nhanh hơn DELETE, reset AUTO_INCREMENT
TRUNCATE TABLE GroupAccount;