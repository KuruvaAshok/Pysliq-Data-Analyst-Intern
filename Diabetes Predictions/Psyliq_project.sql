create database psyliq;
use psyliq;
show tables;

describe diabetes;
select * from diabetes;


-- 1. Retrieve the Patient_id and ages of all patients?
SELECT Patient_id, 
       YEAR(CURDATE()) - YEAR(STR_TO_DATE(`D.O.B`, '%d-%m-%Y')) - 
       (RIGHT(CURDATE(), 5) < RIGHT(STR_TO_DATE(`D.O.B`, '%d-%m-%Y'), 5)) AS Age
FROM diabetes;

-- 2. Select all female patients who are older than 40
SELECT *
FROM diabetes
WHERE gender = 'Female'
AND YEAR(CURDATE()) - YEAR(STR_TO_DATE(`D.O.B`, '%d-%m-%Y')) > 40;

-- 3. Calculate the average BMI of patients.
SELECT AVG(bmi) AS average_bmi FROM diabetes;

-- 4. List patients in descending order of blood glucose levels.
select patient_id, blood_glucose_level from diabetes order by blood_glucose_level desc;

-- 5. Find patients who have hypertension and diabetes.
select * from diabetes where hypertension = 1 and diabetes = 1;   -- 1 = Yes , 0 = No

-- 6. Determine the number of patients with heart disease.  
select * from diabetes where heart_disease = 1;       -- 1 == Yes , 0 = No

-- 7. Group patients by smoking history and count how many smokers and non-smokers there are.
select smoking_history,count(*) as smokers_nonsomkers from diabetes group by smoking_history;

-- 8. Retrieve the Patient_ids of patients who have a BMI greater than the average BMI.
select patient_id,BMI from diabetes where bmi>(select avg(bmi) from diabetes);

-- 9. Find the patient with the highest HbA1c level and the patient with the lowest HbA1clevel.
select max(hba1c_level),min(hba1c_level) from diabetes;

-- OR

SELECT *
FROM diabetes
ORDER BY HbA1c_level DESC
LIMIT 1;

SELECT *
FROM diabetes
ORDER BY HbA1c_level ASC
LIMIT 1;

-- 10. Calculate the age of patients in years (assuming the current date as of now).
SELECT Patient_id,
       YEAR(CURDATE()) - YEAR(STR_TO_DATE(`D.O.B`, '%d-%m-%Y')) - 
       (RIGHT(CURDATE(), 5) < RIGHT(STR_TO_DATE(`D.O.B`, '%d-%m-%Y'), 5)) AS Age
FROM diabetes;

-- 11. Rank patients by blood glucose level within each gender group.
select patient_id, blood_glucose_level, gender, rank() over(partition by 'gender' order by blood_glucose_level desc)as rnk from diabetes;

-- 12. Update the smoking history of patients who are older than 50 to "Ex-smoker."
/*/ SELECT *
FROM diabetes
WHERE (DATEDIFF(NOW(), STR_TO_DATE(`D.O.B`, '%d-%m-%Y')) / 365.25 > 50
       OR DATEDIFF(NOW(), STR_TO_DATE(`D.O.B`, '%m/%d/%Y')) / 365.25 > 50)
      AND `D.O.B` IS NOT NULL; /*/

UPDATE diabetes
SET smoking_history = 'Ex-smoker'
WHERE YEAR(CURDATE()) - YEAR(STR_TO_DATE(`D.O.B`, 
    CASE
        WHEN `D.O.B` LIKE '%-%' THEN '%d-%m-%Y'
        WHEN `D.O.B` LIKE '%/%' THEN '%m/%d/%Y'
        ELSE NULL 
    END
)) > 50;

-- 13. Insert a new patient into the database with sample data.
insert into diabetes values ('Ashok Kumar',	'PT100002', 'Male',	'27-02-1996', 0, 1,	'never', '25.19', '6.6', 120, 0);

-- 14. Delete all patients with heart disease from the database.
delete from diabetes where heart_disease = 1;

-- 15. Find patients who have hypertension but not diabetes using the EXCEPT operator.
select * from diabetes where hypertension = 1 and diabetes = 0;

-- 16. Define a unique constraint on the "patient_id" column to ensure its values are unique.
alter table diabetes modify column Patient_id varchar(255);
alter table diabetes add constraint uc_patient_id UNIQUE (Patient_id);

-- 17. Create a view that displays the Patient_ids, ages, and BMI of patients.
create table virtual_table as select patient_id, bmi, 
       YEAR(CURDATE()) - YEAR(STR_TO_DATE(`D.O.B`, '%d-%m-%Y')) - 
       (RIGHT(CURDATE(), 5) < RIGHT(STR_TO_DATE(`D.O.B`, '%d-%m-%Y'), 5)) AS Age 
FROM diabetes;

select * from virtual_table;

-- 18. Suggest improvements in the database schema to reduce data redundancy and improve data integrity.
/*/ 
1. Normalize the schema to eliminate redundant data and reduce update anomalies.
2. Ensure appropriate data types are used for each column to optimize storage.
3. Enforce referential integrity constraints using foreign keys.
4. Consider partitioning large tables to improve query performance.
/*/

-- 19. Explain how you can optimize the performance of SQL queries on this dataset.
/*/
1. Index frequently queried columns, such as Patient_id, blood_glucose_level, etc.
2. Use appropriate join strategies (e.g., nested loops, hash joins) depending on the query and data distribution.
3. Avoid using SELECT * and retrieve only the necessary columns.
4. Use EXPLAIN to analyze query execution plans and optimize accordingly.
5. Regularly analyze and optimize table structures and indexes based on query patterns and workload.
/*/