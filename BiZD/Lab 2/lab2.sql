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

-- ZAD3.3 - w DBeaver nie potrafie tego zrobić więc robię na czuja tak jak powinno działać w SQL developerze
SELECT first_name || ' ' || last_name AS full_name, salary, phone_number
FROM employees
WHERE SUBSTR(last_name, 3, 1) = 'e' 
AND first_name LIKE '%&part_of_first_name%'
ORDER BY full_name DESC, salary ASC;

-- ZAD 3.4
SELECT
    first_name || ' ' || last_name AS full_name,
    ROUND(MONTHS_BETWEEN(SYSDATE, hire_date)) AS months_worked,
    CASE
        WHEN MONTHS_BETWEEN(SYSDATE, hire_date) <= 150 THEN salary * 0.10
        WHEN MONTHS_BETWEEN(SYSDATE, hire_date) <= 200 THEN salary * 0.20
        ELSE salary * 0.30
    END AS bonus
FROM employees
ORDER BY months_worked;

-- ZAD 3.5
SELECT
    department_id,
    SUM(salary) AS total_salary,
    ROUND(AVG(salary)) AS avg_salary
FROM employees
WHERE department_id IN (
    SELECT department_id
    FROM employees
    GROUP BY department_id
    HAVING MIN(salary) > 5000
)
GROUP BY department_id;

-- ZAD 3.6
SELECT
    e.last_name AS nazwisko,
    e.department_id AS id_departamentu,
    d.department_name AS nazwa_departamentu,
    e.job_id AS id_pracy
FROM
    employees e
JOIN
    departments d ON e.department_id = d.department_id
JOIN
    locations l ON d.location_id = l.location_id
WHERE
    l.city = 'Toronto';
   
-- ZAD 3.7
SELECT
    emplo.first_name AS imie_pracownika,
    emplo.last_name AS nazwisko_pracownika,
    coemplo.first_name AS imie_wspolpracownika,
    coemplo.last_name AS nazwisko_wspolpracownika
FROM
    employees emplo
JOIN
    employees coemplo ON emplo.department_id  = coemplo.department_id 
WHERE
    emplo.FIRST_NAME = 'Jennifer';

-- ZAD 3.8
SELECT
    d.DEPARTMENT_ID,
    d.DEPARTMENT_NAME
FROM
    departments d
LEFT JOIN
    employees e ON d.DEPARTMENT_ID = e.DEPARTMENT_ID
WHERE
    e.EMPLOYEE_ID IS NULL;
    
-- sprawdzenie:
SELECT * FROM employees WHERE DEPARTMENT_ID = 200;

-- ZAD 3.9
CREATE TABLE job_grades AS SELECT * FROM hr.job_grades;

-- ZAD 3.10
SELECT
    emplo.first_name AS imie,
    emplo.last_name AS nazwisko,
    emplo.job_id AS id_pracy,
    dep.department_name AS nazwa_departamentu,
    emplo.salary AS zarobki,
    grades.grade AS ocena_zarobkow
FROM employees emplo
JOIN departments dep ON emplo.department_id= dep.department_id
LEFT JOIN job_grades grades ON emplo.salary BETWEEN grades.min_salary AND grades.max_salary;

-- ZAD 3.11
SELECT
    first_name AS imie,
    last_name AS nazwisko,
    salary AS zarobki
FROM employees
WHERE salary > (SELECT AVG(salary) FROM employees)
ORDER BY salary DESC;

-- ZAD 3.12
SELECT
    emplo.employee_id AS id,
    emplo.first_name AS imie,
    emplo.last_name AS nazwisko
FROM employees emplo
WHERE emplo.department_id IN (
    SELECT DISTINCT coemplo.department_id
    FROM employees coemplo
    WHERE coemplo.last_name LIKE '%u%'
);
