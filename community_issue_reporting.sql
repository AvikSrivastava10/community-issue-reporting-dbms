-- COMMUNITY ISSUE REPORTING AND VERIFICATION SYSTEM
-- -------------------------------------------------
-- Author: Avik Srivastava
-- Platform: Oracle Live SQL
-- Description: A DBMS mini-project for community issue reporting and verification.

----------------------------------------------------
-- TABLE CREATION
----------------------------------------------------

-- 1️⃣ USERS TABLE
CREATE TABLE Users (
    user_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    name VARCHAR2(100),
    email VARCHAR2(100) UNIQUE,
    phone VARCHAR2(15),
    address VARCHAR2(200),
    user_type VARCHAR2(20) CHECK (user_type IN ('Citizen', 'Officer'))
);

-- 2️⃣ CATEGORY TABLE
CREATE TABLE Category (
    category_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    category_name VARCHAR2(100),
    description VARCHAR2(200)
);

-- 3️⃣ ISSUES TABLE
CREATE TABLE Issues (
    issue_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    user_id NUMBER REFERENCES Users(user_id),
    category_id NUMBER REFERENCES Category(category_id),
    title VARCHAR2(150),
    description VARCHAR2(500),
    location VARCHAR2(200),
    date_reported DATE DEFAULT SYSDATE,
    status VARCHAR2(20) DEFAULT 'Pending',
    severity_level VARCHAR2(20)
);

-- 4️⃣ VERIFICATION TABLE
CREATE TABLE Verification (
    verification_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    issue_id NUMBER REFERENCES Issues(issue_id),
    verifier_id NUMBER REFERENCES Users(user_id),
    date_verified DATE,
    remarks VARCHAR2(300),
    verification_status VARCHAR2(20) CHECK (verification_status IN ('Verified', 'Rejected'))
);

-- 5️⃣ FEEDBACK TABLE
CREATE TABLE Feedback (
    feedback_id NUMBER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    issue_id NUMBER REFERENCES Issues(issue_id),
    user_id NUMBER REFERENCES Users(user_id),
    feedback_text VARCHAR2(300),
    rating NUMBER(1) CHECK (rating BETWEEN 1 AND 5),
    date_given DATE DEFAULT SYSDATE
);

----------------------------------------------------
-- SAMPLE DATA
----------------------------------------------------

-- USERS
INSERT INTO Users (name, email, phone, address, user_type)
VALUES ('Ravi Sharma', 'ravi@example.com', '9876543210', 'Sector 17, Chandigarh', 'Citizen');
INSERT INTO Users (name, email, phone, address, user_type)
VALUES ('Officer Meena', 'meena.officer@example.com', '9998887776', 'DD1 Block, CU', 'Officer');

-- CATEGORY
INSERT INTO Category (category_name, description)
VALUES ('Sanitation', 'Garbage, waste disposal, or cleanliness issues');
INSERT INTO Category (category_name, description)
VALUES ('Roads', 'Potholes, damaged roads, or traffic signals');

-- ISSUES
INSERT INTO Issues (user_id, category_id, title, description, location, severity_level)
VALUES (1, 1, 'Overflowing Garbage Bin', 'Garbage bin overflowing near park', 'Sector 17', 'High');

-- VERIFICATION
INSERT INTO Verification (issue_id, verifier_id, date_verified, remarks, verification_status)
VALUES (1, 2, SYSDATE, 'Visited the site, confirmed issue', 'Verified');

-- FEEDBACK
INSERT INTO Feedback (issue_id, user_id, feedback_text, rating)
VALUES (1, 1, 'Thank you for quick action!', 5);

----------------------------------------------------
-- SAMPLE QUERIES
----------------------------------------------------

-- 1️⃣ List all issues and their reporters
SELECT i.title, u.name AS reporter, i.status, i.date_reported
FROM Issues i JOIN Users u ON i.user_id = u.user_id;

-- 2️⃣ List issues verified by each officer
SELECT u.name AS officer_name, COUNT(v.issue_id) AS total_verified
FROM Verification v JOIN Users u ON v.verifier_id = u.user_id
GROUP BY u.name;

-- 3️⃣ Average feedback rating
SELECT ROUND(AVG(rating),2) AS avg_rating FROM Feedback;

-- 4️⃣ Display issues along with category names
SELECT i.title, c.category_name, i.status FROM Issues i
JOIN Category c ON i.category_id = c.category_id;

-- 5️⃣ Issues still pending verification
SELECT title FROM Issues WHERE status = 'Pending';
