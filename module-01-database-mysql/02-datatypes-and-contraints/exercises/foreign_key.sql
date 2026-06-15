CREATE TABLE orders (
    id INT NOT NULL AUTO_INCREMENT,
    user_id INT NOT NULL,
    total DECIMAL(10, 2),
    PRIMARY KEY (id),
    FOREIGN KEY (user_id) REFERENCES users (id),
    -- FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE: Tự động xóa record con khi record cha bị xóa
);