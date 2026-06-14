CREATE TABLE products (
    id INT NOT NULL AUTO_INCREMENT,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    quantity INT NOT NULL,
    discount DECIMAL(5, 2),
    PRIMARY KEY (id),
    CONSTRAINT chk_price CHECK (price > 0),
    CONSTRAINT chk_quantity CHECK (quantity >= 0),
    CONSTRAINT chk_discount CHECK (
        discount >= 0
        AND discount <= 100
    )
);