USE zbd;

-- Create tables
CREATE TABLE IF NOT EXISTS Pracownik (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(40) NOT NULL,
    stanowisko VARCHAR(40) NOT NULL,
    numer_telefonu VARCHAR(12) NOT NULL,
    email VARCHAR(40) NOT NULL
);

CREATE TABLE Nieruchomosc (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    typ VARCHAR(20) NOT NULL,
    adres VARCHAR(255) NOT NULL,
    powierzchnia INT NOT NULL,
    ilosc_pokoi INT NOT NULL,
    cena FLOAT NOT NULL,
    opis TEXT
);

CREATE TABLE Notatka (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nieruchomosc_id INT,
    tresc TEXT,
    data DATETIME,
    autor INT,
    FOREIGN KEY (nieruchomosc_id) REFERENCES Nieruchomosc(ID),
    FOREIGN KEY (autor) REFERENCES Pracownik(ID)
);

CREATE TABLE Klient (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    imie VARCHAR(20) NOT NULL,
    nazwisko VARCHAR(40) NOT NULL,
    adres VARCHAR(255) NOT NULL,
    numer_telefonu VARCHAR(12) NOT NULL,
    email VARCHAR(40) NOT NULL
);

CREATE TABLE Transakcja (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    nieruchomosc_id INT,
    klient_id INT,
    data DATETIME,
    cena_sprzedazy FLOAT NOT NULL,
    oplaty_dodatkowe FLOAT,
    status_transakcji VARCHAR(20),
    FOREIGN KEY (nieruchomosc_id) REFERENCES Nieruchomosc(ID),
    FOREIGN KEY (klient_id) REFERENCES Klient(ID),
);

CREATE TABLE Platnosc (
    ID INT AUTO_INCREMENT PRIMARY KEY,
    transakcja_id INT,
    kwota FLOAT NOT NULL,
    data DATETIME,
    status VARCHAR(20) NOT NULL,
    FOREIGN KEY (transakcja_id) REFERENCES Transakcja(ID)
);

-- Add triggers
DELIMITER //
CREATE TRIGGER your_trigger_name
AFTER INSERT ON your_table_name
FOR EACH ROW
BEGIN
    -- Your trigger logic here
END;
//
DELIMITER ;