USE zbd;

-- TABLES PRE-CREATION

CREATE TABLE IF NOT EXISTS Worker (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(40) NOT NULL,
    role ENUM('manager', 'broker') NOT NULL,
    phone VARCHAR(12) NOT NULL,
    email VARCHAR(40) NOT NULL
);

INSERT INTO Worker (name, surname, role, phone, email)
VALUES
    ('John', 'Doe', 'manager', '1234567890', 'john.doe@example.com'),
    ('Jane', 'Smith', 'broker', '9876543210', 'jane.smith@example.com'),
    ('Mike', 'Johnson', 'broker', '5551234567', 'mike.johnson@example.com');

CREATE TABLE IF NOT EXISTS Property (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    type ENUM('flat', 'building') NOT NULL,
    adres VARCHAR(255) NOT NULL,
    area FLOAT NOT NULL,
    rooms INT NOT NULL,
    sqm_price FLOAT NOT NULL,
    description TEXT
);

CREATE TABLE IF NOT EXISTS Client (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(20) NOT NULL,
    surname VARCHAR(40) NOT NULL,
    phone VARCHAR(12) NOT NULL,
    email VARCHAR(40) NOT NULL
);

CREATE TABLE IF NOT EXISTS Transaction (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    client_id INT,
    worker_id INT,
    data DATETIME,
    final_price FLOAT NOT NULL,
    status_transakcji ENUM('started', 'completed', 'cancelled') NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Property(ID),
    FOREIGN KEY (client_id) REFERENCES Client(ID),
    FOREIGN KEY (worker_id) REFERENCES Worker(ID)
);

CREATE TABLE IF NOT EXISTS Historical_transaction (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    property_id INT,
    client_id INT,
    worker_id INT,
    data DATETIME,
    final_price FLOAT NOT NULL,
    status_transakcji ENUM('started', 'completed', 'cancelled') NOT NULL,
    FOREIGN KEY (property_id) REFERENCES Property(ID),
    FOREIGN KEY (client_id) REFERENCES Client(ID),
    FOREIGN KEY (worker_id) REFERENCES Worker(ID)
);
