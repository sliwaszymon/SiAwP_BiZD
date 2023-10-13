-- ZAD1
DROP TABLE regions CASCADE CONSTRAINTS;
DROP TABLE countries CASCADE CONSTRAINTS;
DROP TABLE locations CASCADE CONSTRAINTS;
DROP TABLE departments CASCADE CONSTRAINTS;
DROP TABLE jobs CASCADE CONSTRAINTS;
DROP TABLE employees CASCADE CONSTRAINTS;
DROP TABLE job_history CASCADE CONSTRAINTS;

-- ZAD 2
CREATE TABLE regions AS SELECT * FROM hr.regions;
CREATE TABLE countries AS SELECT * FROM hr.countries;
CREATE TABLE locations AS SELECT * FROM hr.locations;
CREATE TABLE departments AS SELECT * FROM hr.departments;
CREATE TABLE jobs AS SELECT * FROM hr.jobs;
CREATE TABLE employees AS SELECT * FROM hr.employees;
CREATE TABLE job_history AS SELECT * FROM hr.job_history;
CREATE TABLE job_grades AS SELECT * FROM hr.job_grades;

-- ZAD3.1
SELECT last_name || ' ' || salary AS wynagrodzenie
FROM employees
WHERE department_id IN (20, 50)
AND salary BETWEEN 2000 AND 7000
ORDER BY last_name;

-- ZAD3.2
-- w dbeaver : zamiast &
SELECT hire_date, last_name, :user_column AS user_column
FROM employees
WHERE manager_id IN (
    SELECT employee_id
    FROM employees
    WHERE EXTRACT(YEAR FROM hire_date) = 2005
)
ORDER BY :user_column;

-- ZAD3.3
SELECT first_name || ' ' || last_name AS full_name, salary, phone_number
FROM employees
WHERE SUBSTR(last_name, 3, 1) = 'e' 
  AND first_name LIKE :part_of_first_name
ORDER BY full_name DESC, salary ASC;


