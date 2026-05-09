-- Secure Banking & Fraud Detection Project
-- Initialize Database
CREATE DATABASE IF NOT EXISTS SecureBankPro;
USE SecureBankPro;

-- Create Tables
CREATE TABLE Users (
    user_id INT PRIMARY KEY AUTO_INCREMENT,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE Accounts (
    account_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id INT,
    balance DECIMAL(15, 2) CHECK (balance >= 0),
    status ENUM('Active', 'Frozen') DEFAULT 'Active',
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

CREATE TABLE Transactions (
    tx_id INT PRIMARY KEY AUTO_INCREMENT,
    sender_id INT,
    receiver_id INT,
    amount DECIMAL(15, 2),
    tx_type VARCHAR(20),
    tx_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (sender_id) REFERENCES Accounts(account_id),
    FOREIGN KEY (receiver_id) REFERENCES Accounts(account_id)
);

CREATE TABLE Audit_Logs (
    log_id INT PRIMARY KEY AUTO_INCREMENT,
    account_id INT,
    old_balance DECIMAL(15,2),
    new_balance DECIMAL(15,2),
    changed_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Stored Procedure for Safe Transfers
DELIMITER //
CREATE PROCEDURE SafeTransfer(IN from_acc INT, IN to_acc INT, IN transfer_amount DECIMAL(15,2))
BEGIN
    DECLARE EXIT HANDLER FOR SQLEXCEPTION BEGIN ROLLBACK; END;
    START TRANSACTION;
    UPDATE Accounts SET balance = balance - transfer_amount WHERE account_id = from_acc AND status = 'Active';
    UPDATE Accounts SET balance = balance + transfer_amount WHERE account_id = to_acc AND status = 'Active';
    INSERT INTO Transactions(sender_id, receiver_id, amount, tx_type) VALUES (from_acc, to_acc, transfer_amount, 'TRANSFER');
    COMMIT;
END //
DELIMITER ;

-- Trigger for Audit Trail
DELIMITER //
CREATE TRIGGER before_balance_update BEFORE UPDATE ON Accounts FOR EACH ROW
BEGIN
    INSERT INTO Audit_Logs(account_id, old_balance, new_balance) VALUES (OLD.account_id, OLD.balance, NEW.balance);
END //
DELIMITER ;
