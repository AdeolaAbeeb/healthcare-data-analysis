-- Hospital group admissions: 8 business questions
-- Table: admissions  (load healthcare_dataset_clean.csv; all columns already cleaned)
-- Columns: Name, Age, Gender, Blood_Type, Medical_Condition, Date_of_Admission, Doctor, Hospital,
--          Insurance_Provider, Billing_Amount, Room_Number, Admission_Type, Discharge_Date, Medication,
--          Test_Results, Length_of_Stay, Age_Group, Admission_Year, Admission_Month
-- Written in portable SQL and tested on SQLite (results match the Excel Analysis sheet).
-- PostgreSQL / MySQL 8: runs as is.  SQL Server: replace "LIMIT 10" with "SELECT TOP 10 ...".

-- Optional (PostgreSQL) table definition:
-- CREATE TABLE admissions (Name text, Age int, Gender text, Blood_Type text, Medical_Condition text,
--   Date_of_Admission date, Doctor text, Hospital text, Insurance_Provider text, Billing_Amount numeric(12,2),
--   Room_Number int, Admission_Type text, Discharge_Date date, Medication text, Test_Results text,
--   Length_of_Stay int, Age_Group text, Admission_Year int, Admission_Month int);
-- \copy admissions FROM 'healthcare_dataset_clean.csv' CSV HEADER

-- Q1. Admissions per medical condition (rank 1 = most common)
SELECT Medical_Condition, COUNT(*) AS admissions,
       ROUND(100.0*COUNT(*)/SUM(COUNT(*)) OVER (),2) AS pct_of_total
FROM admissions GROUP BY Medical_Condition ORDER BY admissions DESC;

-- Q2. Average and total billing per medical condition
SELECT Medical_Condition, ROUND(AVG(Billing_Amount),2) AS avg_billing, ROUND(SUM(Billing_Amount),2) AS total_billing
FROM admissions GROUP BY Medical_Condition ORDER BY total_billing DESC;

-- Q3. Average length of stay per admission type
SELECT Admission_Type, ROUND(AVG(Length_of_Stay),2) AS avg_length_of_stay_days, COUNT(*) AS admissions
FROM admissions GROUP BY Admission_Type ORDER BY avg_length_of_stay_days DESC;

-- Q4. Insurance provider with the highest total billing
SELECT Insurance_Provider, ROUND(SUM(Billing_Amount),2) AS total_billing, COUNT(*) AS admissions
FROM admissions GROUP BY Insurance_Provider ORDER BY total_billing DESC;

-- Q5. Top 10 hospitals by total billing
SELECT Hospital, ROUND(SUM(Billing_Amount),2) AS total_billing, COUNT(*) AS admissions
FROM admissions GROUP BY Hospital ORDER BY total_billing DESC LIMIT 10;

-- Q6. Admissions trend by year and month
SELECT Admission_Year AS year, Admission_Month AS month, COUNT(*) AS admissions
FROM admissions GROUP BY Admission_Year, Admission_Month ORDER BY year, month;

-- Q7. Test result share per medical condition
SELECT Medical_Condition,
       ROUND(100.0*SUM(CASE WHEN Test_Results='Normal' THEN 1 ELSE 0 END)/COUNT(*),2) AS pct_normal,
       ROUND(100.0*SUM(CASE WHEN Test_Results='Abnormal' THEN 1 ELSE 0 END)/COUNT(*),2) AS pct_abnormal,
       ROUND(100.0*SUM(CASE WHEN Test_Results='Inconclusive' THEN 1 ELSE 0 END)/COUNT(*),2) AS pct_inconclusive
FROM admissions GROUP BY Medical_Condition ORDER BY Medical_Condition;

-- Q8. Average billing per age group
SELECT Age_Group, ROUND(AVG(Billing_Amount),2) AS avg_billing, COUNT(*) AS admissions
FROM admissions GROUP BY Age_Group ORDER BY avg_billing DESC;
