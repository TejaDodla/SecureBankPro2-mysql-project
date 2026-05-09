# Secure Banking & Fraud Detection System

This repository contains a robust MySQL database project focused on security, transaction integrity, and audit logging.

## Features
- **ACID Compliance**: Uses Stored Procedures with Transactions to ensure money transfers never fail halfway.
- **Data Constraints**: Implements `CHECK` constraints to prevent negative balances.
- **Audit Logging**: Automated triggers record every change to account balances for forensic security.
- **Relational Integrity**: Professional schema with proper Foreign Key relationships.

## How to use
1. Run `secure_banking_project.sql` in your MySQL environment.
2. Test a secure transfer: `CALL SafeTransfer(1, 2, 500.00);`
3. View the audit trail: `SELECT * FROM Audit_Logs;`
