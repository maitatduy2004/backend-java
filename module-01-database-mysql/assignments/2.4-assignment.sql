CREATE TABLE Student (
    StudentID INT NOT NULL AUTO_INCREMENT,
    Email VARCHAR(150) NOT NULL UNIQUE,
    FullName VARCHAR(100) NOT NULL,
    GPA DECIMAL(3, 2) CHECK (GPA BETWEEN 0 AND 4),
    Status ENUM(
        'active',
        'inactive',
        'graduated'
    ) NOT NULL DEFAULT 'active',
    ClassID INT,
    CreatedAt DATETIME DEFAULT CURRENT_TIMESTAMP,
    PRIMARY KEY (StudentID),
    FOREIGN KEY (ClassID) REFERENCES Class (ClassID)
);