-- Insert một hàng, chỉ định column
INSERT INTO Department (DepartmentName) VALUES ('Engineering');

-- Insert nhiều hàng cùng lúc
INSERT INTO
    Position(PositionName)
VALUES ('Dev'),
    ('Test'),
    ('Scrum Master'),
    ('PM');

-- Insert với đầy đủ column (phải đúng thứ tự)
INSERT INTO
    Account (
        Email,
        Username,
        FullName,
        DepartmentID,
        PositionID
    )
VALUES (
        'john@example.com',
        'johndoe',
        'John Doe',
        1,
        1
    );