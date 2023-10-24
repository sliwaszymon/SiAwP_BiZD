-- ZAD 1
DECLARE
    numer_max departments.department_id%TYPE;
    new_departament_number departments.department_id%TYPE;
    new_departament_name departments.department_name%TYPE := 'EDUCATION';
BEGIN
    SELECT MAX(department_id) INTO numer_max FROM departments;
    new_departament_number := numer_max + 10;
    INSERT INTO departments (department_id, department_name)
    VALUES (new_departament_number, new_departament_name);
END;

-- ZAD 2
DECLARE
    numer_max departments.department_id%TYPE;
    new_departament_number departments.department_id%TYPE;
    new_departament_name departments.department_name%TYPE := 'EDUCATION';
   	new_location_id departments.location_id%TYPE = 3000;
BEGIN
    SELECT MAX(department_id) INTO numer_max FROM departments;
    new_departament_number := numer_max + 10;
    INSERT INTO departments (department_id, department_name, location_id)
    VALUES (new_departament_number, new_departament_name, new_location_id);
END;

-- ZAD 3
CREATE TABLE nowa (
    value NUMBER(2, 0)
);
DECLARE
    i INT := 1;
BEGIN
    WHILE i <= 10 LOOP
        IF i != 4 AND i != 6 THEN
            INSERT INTO nowa (value) VALUES (i);
        END IF;
        i := i + 1;
    END LOOP;
END;

-- ZAD 4 - trzeba odpalić "Dbms output" i połączyć się z bazą
DECLARE
    v_country countries%ROWTYPE;
BEGIN
    SELECT * INTO v_country
    FROM countries
    WHERE country_id = 'CA';

    DBMS_OUTPUT.PUT_LINE('nazwa: ' || v_country.country_name);
    DBMS_OUTPUT.PUT_LINE('id regionu: ' || v_country.region_id);
END;

-- ZAD 5
DECLARE 
	TYPE DepartmentTable IS TABLE OF departments.department_name%TYPE 
	INDEX BY PLS_INTEGER;
	departments_table := DepartmentTable;
BEGIN
	FOR dep IN (SELECT department_id, department_name FROM departments) LOOP
		departments_table(dep.department_id) := dep.department_name;
	END LOOP;
	FOR i IN 1 .. 10 LOOP
		DBMS_OUTPUT.PUT_LINE('numer: ' || i * 10);
		DBMS_OUTPUT.PUT_LINE('nazwa departamentu: ' || departments_table(i*10));
	END LOOP;
END;

-- ZAD 6
DECLARE
    TYPE DepartmentTable IS TABLE OF departments%ROWTYPE INDEX BY PLS_INTEGER; 
    departments_table DepartmentTable;
BEGIN
    FOR dep IN (SELECT * FROM departments) LOOP
        departments_table(dep.department_id) := dep;
    END LOOP;
    FOR i IN 10..100 LOOP
        IF departments_table.EXISTS(i) THEN
            DBMS_OUTPUT.PUT_LINE('id departametnu: ' || departments_table(i).department_id);
            DBMS_OUTPUT.PUT_LINE('nazwa departamentu: ' || departments_table(i).department_name);
            DBMS_OUTPUT.PUT_LINE('id menagera: ' || departments_table(i).manager_id);
            DBMS_OUTPUT.PUT_LINE('id lokalizacji: ' || departments_table(i).location_id);
            DBMS_OUTPUT.NEW_LINE;
        END IF;
    END LOOP;
END;

-- ZAD 7
DECLARE
  CURSOR wynagrodzenie_crs IS
    SELECT employee_id, last_name, salary
    FROM employees
    WHERE department_id = 50;
    
  v_EMPLOYEE_ID employees.employee_id%TYPE;
  v_LAST_NAME employees.last_name%TYPE;
  v_SALARY employees.salary%TYPE;
BEGIN
  OPEN wynagrodzenie_crs;
  LOOP
    FETCH wynagrodzenie_crs INTO v_EMPLOYEE_ID, v_LAST_NAME, v_SALARY;
    EXIT WHEN wynagrodzenie_crs%NOTFOUND;
    IF v_SALARY > 3100 THEN
      DBMS_OUTPUT.PUT_LINE(v_LAST_NAME || ' - nie dawać podwyżki');
    ELSE
      DBMS_OUTPUT.PUT_LINE(v_LAST_NAME || ' - dać podwyżkę');
    END IF;
  END LOOP;
  CLOSE wynagrodzenie_crs;
END;

-- ZAD 8
DECLARE
  CURSOR wynagrodzenie_crs (p_min_salary NUMBER, p_max_salary NUMBER, p_first_name_part VARCHAR2) IS
    SELECT salary, first_name, last_name
    FROM employees
    WHERE salary BETWEEN p_min_salary AND p_max_salary
    AND UPPER(first_name) LIKE '%' || UPPER(p_first_name_part) || '%';
  v_SALARY employees.salary%TYPE;
  v_FIRST_NAME employees.first_name%TYPE;
  v_LAST_NAME employees.last_name%TYPE;
BEGIN
  OPEN wynagrodzenie_crs(1000, 5000, 'a');
  DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 1000-5000 i częścią imienia "A" lub "a":');
  LOOP
    FETCH wynagrodzenie_crs INTO v_SALARY, v_FIRST_NAME, v_LAST_NAME;
    EXIT WHEN wynagrodzenie_crs%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_FIRST_NAME || ' ' || v_LAST_NAME || ', Zarobki: ' || v_SALARY);
  END LOOP;
  CLOSE wynagrodzenie_crs;
  OPEN wynagrodzenie_crs(5000, 20000, 'u');
  DBMS_OUTPUT.PUT_LINE('Pracownicy z widełkami 5000-20000 i częścią imienia "U" lub "u":');
  LOOP
    FETCH wynagrodzenie_crs INTO v_SALARY, v_FIRST_NAME, v_LAST_NAME;
    EXIT WHEN wynagrodzenie_crs%NOTFOUND;
    DBMS_OUTPUT.PUT_LINE(v_FIRST_NAME || ' ' || v_LAST_NAME || ', Zarobki: ' || v_SALARY);
  END LOOP;
  CLOSE wynagrodzenie_crs;
END;

-- ZAD 9 A
CREATE OR REPLACE PROCEDURE DodajJob (
    p_Job_id VARCHAR2,
    p_Job_title VARCHAR2
) AS
BEGIN
    INSERT INTO Jobs (JOB_ID, JOB_TITLE)
    VALUES (p_Job_id, p_Job_title);
    DBMS_OUTPUT.PUT_LINE('Dodano nową pozycję do tabeli Jobs: Job_id=' || p_Job_id || ', Job_title=' || p_Job_title);

EXCEPTION
    WHEN OTHERS THEN
        DBMS_OUTPUT.PUT_LINE('Wystąpił błąd podczas wstawiania do tabeli Jobs: ' || SQLERRM);
END;
-- TEST
BEGIN
    DodajJob('IT_MGR', 'IT Manager');
    DodajJob('SA_MAN', 'Sales Manager');
END;

-- ZAD 9 B
CREATE OR REPLACE PROCEDURE ModyfikujJobTitle (
    p_Job_id VARCHAR2,
    p_Nowy_Job_title VARCHAR2
) AS
    v_liczba_zaktualizowanych NUMBER;
BEGIN
    UPDATE Jobs
    SET JOB_TITLE = p_Nowy_Job_title
    WHERE JOB_ID = p_Job_id;

    v_liczba_zaktualizowanych := SQL%ROWCOUNT;
   
    IF v_liczba_zaktualizowanych = 0 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Brak pasujących wierszy do zaktualizowania.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Aktualizacja zakończona pomyślnie: ' || v_liczba_zaktualizowanych || ' wierszy zaktualizowanych.');
    END IF;
END;
-- TEST
BEGIN
    ModyfikujJobTitle('IT_MGR', 'Nowy IT Manager');
END;

-- ZAD 9 C
CREATE OR REPLACE PROCEDURE UsunJob (
    p_Job_id VARCHAR2
) AS
    v_liczba_usunietych NUMBER;
BEGIN
    DELETE FROM Jobs
    WHERE JOB_ID = p_Job_id;

    v_liczba_usunietych := SQL%ROWCOUNT;

    IF v_liczba_usunietych = 0 THEN
        RAISE_APPLICATION_ERROR(-20002, 'Brak pasujących wierszy do usunięcia.');
    ELSE
        DBMS_OUTPUT.PUT_LINE('Usunięto wiersz z tabeli Jobs: ' || v_liczba_usunietych || ' wierszy usuniętych.');
    END IF;
END;
-- TEST
BEGIN
    UsunJob('IT_MGR');
END;

-- ZAD 9 D
CREATE OR REPLACE PROCEDURE PobierzZarobkiINazwisko (
    p_EMPLOYEE_ID NUMBER,
    p_Zarobki OUT NUMBER,
    p_Nazwisko OUT VARCHAR2
) AS
BEGIN
    SELECT salary, last_name
    INTO p_Zarobki, p_Nazwisko
    FROM employees
    WHERE employee_id = p_EMPLOYEE_ID;
END;
-- TEST
DECLARE
    v_Zarobki NUMBER;
    v_Nazwisko VARCHAR2(50);
BEGIN
    PobierzZarobkiINazwisko(121, v_Zarobki, v_Nazwisko);
    DBMS_OUTPUT.PUT_LINE('Zarobki: ' || v_Zarobki);
    DBMS_OUTPUT.PUT_LINE('Nazwisko: ' || v_Nazwisko);
END;

-- ZAD 9 E
-- SEKWENCJA DO TWORZENIA ID
DECLARE
    v_max_employee_id NUMBER;
BEGIN
    SELECT MAX(EMPLOYEE_ID) INTO v_max_employee_id FROM employees;
    EXECUTE IMMEDIATE 'CREATE SEQUENCE employees_seq START WITH ' || (v_max_employee_id + 1) || ' INCREMENT BY 1';
END;
-- WŁAŚCIWY KOD ZADANIA
CREATE OR REPLACE PROCEDURE DodajPracownika (
    p_Imie VARCHAR2 DEFAULT 'Nowy',
    p_Nazwisko VARCHAR2 DEFAULT 'Pracownik',
    p_Email VARCHAR2 DEFAULT 'nowy.pracownik@example.com',
    p_Wynagrodzenie NUMBER DEFAULT 1000
) AS
BEGIN
    IF p_Wynagrodzenie > 20000 THEN
        RAISE_APPLICATION_ERROR(-20003, 'Wynagrodzenie nie może przekroczyć 20000.');
    ELSE
        INSERT INTO employees (employee_id, first_name, last_name, email, hire_date, job_id, salary)
        VALUES (employees_seq.NEXTVAL, p_Imie, p_Nazwisko, p_Email, SYSDATE, 'IT_PROG', p_Wynagrodzenie);
    END IF;
END;
-- TEST
BEGIN
    DodajPracownika('Szymon', 'Sliwa', 'test@test.com', 6400);
END;