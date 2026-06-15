-- ============================================================
--  SAMPLE DATA
-- ============================================================
USE TestingSystem;

-- Department
INSERT INTO
    Department (DepartmentName)
VALUES ('Engineering'),
    ('Quality Assurance'),
    ('Product'),
    ('Human Resources');

-- Position
INSERT INTO
    `Position` (PositionName)
VALUES ('DEV'),
    ('TEST'),
    ('SCRUM MASTER'),
    ('PM');

-- Account (10 users)
INSERT INTO
    `Account` (
        Email,
        Username,
        FullName,
        DepartmentID,
        PositionID,
        CreateDate
    )
VALUES (
        'alice@example.com',
        'alice',
        'Alice Nguyen',
        1,
        1,
        '2024-01-10 08:00:00'
    ),
    (
        'bob@example.com',
        'bob',
        'Bob Tran',
        1,
        1,
        '2024-01-11 09:00:00'
    ),
    (
        'carol@example.com',
        'carol',
        'Carol Le',
        2,
        2,
        '2024-01-12 10:00:00'
    ),
    (
        'dave@example.com',
        'dave',
        'Dave Pham',
        2,
        2,
        '2024-01-13 11:00:00'
    ),
    (
        'eve@example.com',
        'eve',
        'Eve Hoang',
        3,
        4,
        '2024-01-14 08:30:00'
    ),
    (
        'frank@example.com',
        'frank',
        'Frank Vu',
        1,
        3,
        '2024-02-01 08:00:00'
    ),
    (
        'grace@example.com',
        'grace',
        'Grace Do',
        4,
        NULL,
        '2024-02-05 09:00:00'
    ),
    (
        'henry@example.com',
        'henry',
        'Henry Bui',
        1,
        1,
        '2024-02-10 10:00:00'
    ),
    (
        'irene@example.com',
        'irene',
        'Irene Dang',
        2,
        2,
        '2024-03-01 08:00:00'
    ),
    (
        'jack@example.com',
        'jack',
        'Jack Ly',
        NULL,
        NULL,
        '2024-03-15 14:00:00'
    );

-- Group
INSERT INTO
    `Group` (
        GroupName,
        CreatorID,
        CreateDate
    )
VALUES (
        'Backend Team',
        1,
        '2024-02-01 09:00:00'
    ),
    (
        'QA Team',
        3,
        '2024-02-02 10:00:00'
    ),
    (
        'Product Circle',
        5,
        '2024-02-10 11:00:00'
    );

-- GroupAccount
INSERT INTO
    GroupAccount (GroupID, AccountID, JoinDate)
VALUES (1, 1, '2024-02-01 09:00:00'),
    (1, 2, '2024-02-01 09:30:00'),
    (1, 8, '2024-02-11 08:00:00'),
    (1, 6, '2024-02-11 08:10:00'),
    (2, 3, '2024-02-02 10:00:00'),
    (2, 4, '2024-02-02 10:15:00'),
    (2, 9, '2024-03-02 08:00:00'),
    (3, 5, '2024-02-10 11:00:00'),
    (3, 7, '2024-02-12 09:00:00');

-- TypeQuestion
INSERT INTO
    TypeQuestion (TypeName)
VALUES ('Multiple Choice'),
    ('True/False'),
    ('Essay');

-- CategoryQuestion
INSERT INTO
    CategoryQuestion (CategoryName)
VALUES ('JavaScript'),
    ('Python'),
    ('Database'),
    ('Agile / Scrum'),
    ('Networking');

-- Question (15 câu)
INSERT INTO
    Question (
        Content,
        CategoryID,
        TypeID,
        CreatorID,
        CreateDate
    )
VALUES
    -- JavaScript
    (
        'JavaScript là ngôn ngữ lập trình phía client hay server?',
        1,
        1,
        1,
        '2024-02-15 08:00:00'
    ),
    (
        'Sự khác nhau giữa `let`, `const` và `var` trong JavaScript là gì?',
        1,
        3,
        2,
        '2024-02-15 09:00:00'
    ),
    (
        '`null == undefined` trả về giá trị gì trong JavaScript?',
        1,
        2,
        1,
        '2024-02-16 08:00:00'
    ),
    -- Python
    (
        'Python có hỗ trợ đa luồng (multithreading) không?',
        2,
        2,
        3,
        '2024-02-17 08:00:00'
    ),
    (
        'List comprehension trong Python là gì?',
        2,
        3,
        4,
        '2024-02-17 09:00:00'
    ),
    (
        'Kết quả của `type([])` trong Python là gì?',
        2,
        1,
        3,
        '2024-02-18 08:00:00'
    ),
    -- Database
    (
        'PRIMARY KEY có thể chứa giá trị NULL không?',
        3,
        2,
        1,
        '2024-02-20 08:00:00'
    ),
    (
        'INNER JOIN và LEFT JOIN khác nhau ở điểm nào?',
        3,
        3,
        2,
        '2024-02-20 09:00:00'
    ),
    (
        'Chỉ mục (INDEX) trong database có tác dụng gì?',
        3,
        1,
        4,
        '2024-02-21 08:00:00'
    ),
    -- Agile / Scrum
    (
        'Sprint trong Scrum thường kéo dài bao lâu?',
        4,
        1,
        5,
        '2024-03-01 08:00:00'
    ),
    (
        'Daily Standup có mục đích gì?',
        4,
        3,
        6,
        '2024-03-01 09:00:00'
    ),
    (
        'Product Backlog do ai quản lý?',
        4,
        1,
        5,
        '2024-03-02 08:00:00'
    ),
    -- Networking
    (
        'TCP và UDP khác nhau ở điểm nào?',
        5,
        3,
        8,
        '2024-03-10 08:00:00'
    ),
    (
        'DNS là viết tắt của gì?',
        5,
        1,
        8,
        '2024-03-10 09:00:00'
    ),
    (
        'HTTP sử dụng cổng (port) mặc định nào?',
        5,
        1,
        1,
        '2024-03-11 08:00:00'
    );

-- Answer
INSERT INTO
    Answer (
        Content,
        QuestionID,
        isCorrect
    )
VALUES
    -- Q1: JavaScript client hay server?
    ('Chỉ phía client', 1, 0),
    ('Chỉ phía server', 1, 0),
    ('Cả client lẫn server', 1, 1),
    ('Không phải cả hai', 1, 0),
    -- Q3: null == undefined
    ('true', 3, 1),
    ('false', 3, 0),
    -- Q4: Python multithreading
    ('Có', 4, 1),
    ('Không', 4, 0),
    -- Q6: type([])
    ('<class "list">', 6, 1),
    ('<class "array">', 6, 0),
    ('<class "tuple">', 6, 0),
    ('<class "dict">', 6, 0),
    -- Q7: PRIMARY KEY + NULL
    ('Có', 7, 0),
    ('Không', 7, 1),
    -- Q9: INDEX
    ('Tăng tốc truy vấn', 9, 1),
    (
        'Giảm dung lượng lưu trữ',
        9,
        0
    ),
    (
        'Tự động sắp xếp dữ liệu',
        9,
        0
    ),
    ('Không có tác dụng gì', 9, 0),
    -- Q10: Sprint duration
    ('1–4 tuần', 10, 1),
    ('1–3 tháng', 10, 0),
    ('1 ngày', 10, 0),
    ('6 tháng', 10, 0),
    -- Q12: Product Backlog owner
    ('Product Owner', 12, 1),
    ('Scrum Master', 12, 0),
    ('Development Team', 12, 0),
    ('Stakeholder', 12, 0),
    -- Q14: DNS
    ('Domain Name System', 14, 1),
    ('Data Network Service', 14, 0),
    ('Dynamic Name Server', 14, 0),
    ('Domain Node Service', 14, 0),
    -- Q15: HTTP default port
    ('80', 15, 1),
    ('443', 15, 0),
    ('8080', 15, 0),
    ('21', 15, 0);

-- Exam (5 đề)
INSERT INTO
    Exam (
        Code,
        Title,
        CategoryID,
        Duration,
        CreatorID,
        CreateDate
    )
VALUES (
        'JS-BASIC-01',
        'JavaScript Cơ Bản',
        1,
        30,
        1,
        '2024-03-01 08:00:00'
    ),
    (
        'PY-BASIC-01',
        'Python Cơ Bản',
        2,
        30,
        3,
        '2024-03-05 08:00:00'
    ),
    (
        'DB-BASIC-01',
        'Database Fundamentals',
        3,
        45,
        2,
        '2024-03-10 08:00:00'
    ),
    (
        'AGILE-01',
        'Agile & Scrum Essentials',
        4,
        20,
        5,
        '2024-03-15 08:00:00'
    ),
    (
        'NET-BASIC-01',
        'Networking Basics',
        5,
        25,
        8,
        '2024-03-20 08:00:00'
    );

-- ExamQuestion
INSERT INTO
    ExamQuestion (ExamID, QuestionID)
VALUES
    -- JS exam
    (1, 1),
    (1, 2),
    (1, 3),
    -- Python exam
    (2, 4),
    (2, 5),
    (2, 6),
    -- DB exam
    (3, 7),
    (3, 8),
    (3, 9),
    -- Agile exam
    (4, 10),
    (4, 11),
    (4, 12),
    -- Networking exam
    (5, 13),
    (5, 14),
    (5, 15);

-- ExamResult (20 lượt thi)
INSERT INTO
    ExamResult (
        ExamID,
        AccountID,
        Score,
        StartTime,
        SubmitTime
    )
VALUES
    -- JS exam
    (
        1,
        2,
        85.00,
        '2024-03-20 09:00:00',
        '2024-03-20 09:28:00'
    ),
    (
        1,
        3,
        70.00,
        '2024-03-20 09:00:00',
        '2024-03-20 09:25:00'
    ),
    (
        1,
        4,
        55.00,
        '2024-03-21 14:00:00',
        '2024-03-21 14:27:00'
    ),
    (
        1,
        8,
        90.00,
        '2024-03-21 14:00:00',
        '2024-03-21 14:30:00'
    ),
    (
        1,
        10,
        40.00,
        '2024-03-22 10:00:00',
        '2024-03-22 10:20:00'
    ),
    -- Python exam
    (
        2,
        1,
        75.00,
        '2024-03-22 09:00:00',
        '2024-03-22 09:29:00'
    ),
    (
        2,
        4,
        88.00,
        '2024-03-22 09:00:00',
        '2024-03-22 09:30:00'
    ),
    (
        2,
        9,
        62.00,
        '2024-03-23 10:00:00',
        '2024-03-23 10:28:00'
    ),
    (
        2,
        10,
        45.00,
        '2024-03-23 10:00:00',
        '2024-03-23 10:25:00'
    ),
    -- DB exam
    (
        3,
        1,
        95.00,
        '2024-03-25 08:00:00',
        '2024-03-25 08:40:00'
    ),
    (
        3,
        2,
        80.00,
        '2024-03-25 08:00:00',
        '2024-03-25 08:43:00'
    ),
    (
        3,
        3,
        72.00,
        '2024-03-25 09:00:00',
        '2024-03-25 09:44:00'
    ),
    (
        3,
        6,
        50.00,
        '2024-03-26 14:00:00',
        '2024-03-26 14:38:00'
    ),
    -- Agile exam
    (
        4,
        5,
        100.00,
        '2024-03-28 09:00:00',
        '2024-03-28 09:18:00'
    ),
    (
        4,
        6,
        85.00,
        '2024-03-28 09:00:00',
        '2024-03-28 09:19:00'
    ),
    (
        4,
        7,
        60.00,
        '2024-03-29 10:00:00',
        '2024-03-29 10:15:00'
    ),
    -- Networking exam
    (
        5,
        1,
        78.00,
        '2024-04-01 08:00:00',
        '2024-04-01 08:23:00'
    ),
    (
        5,
        8,
        92.00,
        '2024-04-01 08:00:00',
        '2024-04-01 08:24:00'
    ),
    (
        5,
        9,
        66.00,
        '2024-04-02 10:00:00',
        '2024-04-02 10:22:00'
    ),
    (
        5,
        10,
        30.00,
        '2024-04-02 10:00:00',
        '2024-04-02 10:20:00'
    );