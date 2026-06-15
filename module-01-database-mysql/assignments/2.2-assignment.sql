CREATE TABLE employees (
    EmployeeID INT NOT NULL AUTO_INCREMENT,
    FullName VARCHAR(100),
    Email VARCHAR(150) UNIQUE NOT NULL,
    Salary DECIMAL(10),
    DepartmentID INT NOT NULL,
    HireDate DATE DEFAULT '2024-01-01',
    PRIMARY KEY (EmployeeID),
    FOREIGN KEY (DepartmentID) REFERENCES Department (DepartmentID)
);