-- FUNKCJE 1
CREATE OR REPLACE FUNCTION get_job_title(job_id_param IN VARCHAR2)
    RETURN VARCHAR2
IS
    v_job_title jobs.job_title%TYPE;
BEGIN
    SELECT job_title
    INTO v_job_title
    FROM jobs
    WHERE job_id = job_id_param;

    RETURN v_job_title;
EXCEPTION
    WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'Praca o podanym ID nie istnieje');
END;
-- TEST
DECLARE
  v_job_title VARCHAR2(100);
BEGIN
  v_job_title := get_job_title('AD_PRES');
  DBMS_OUTPUT.PUT_LINE('Nazwa pracy: ' || v_job_title);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
END;


-- FUNKCJE 2
CREATE OR REPLACE FUNCTION calculate_annual_income(employee_id_param IN NUMBER)
RETURN NUMBER
IS
  v_salary NUMBER;
  v_commission_pct NUMBER;
  v_annual_income NUMBER;
BEGIN
  SELECT salary, commission_pct
  INTO v_salary, v_commission_pct
  FROM employees
  WHERE employee_id = employee_id_param;

  v_annual_income := v_salary * 12;

  IF v_commission_pct IS NOT NULL THEN
    v_annual_income := v_annual_income + (v_salary * v_commission_pct);
  END IF;

  RETURN v_annual_income;
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20001, 'Pracownik o podanym ID nie istnieje');
END;
-- TEST
DECLARE
  v_annual_income NUMBER;
BEGIN
  v_annual_income := calculate_annual_income(101);
  DBMS_OUTPUT.PUT_LINE('Roczne zarobki pracownika: ' || v_annual_income);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
END;


-- FUNKCJE 3
CREATE OR REPLACE FUNCTION get_area_code(phone_number_param IN VARCHAR2)
RETURN VARCHAR2
IS
  v_area_code VARCHAR2(10);
BEGIN
  SELECT REGEXP_SUBSTR(phone_number_param, '^\+?\d{1,4}') 
  INTO v_area_code
  FROM dual;

  RETURN v_area_code;
END;
-- TEST
DECLARE
  v_area_code VARCHAR2(10);
BEGIN
  v_area_code := get_area_code('+48-522-456-790');
  DBMS_OUTPUT.PUT_LINE('Numer kierunkowy: ' || v_area_code);
EXCEPTION
  WHEN OTHERS THEN
    DBMS_OUTPUT.PUT_LINE('Błąd: ' || SQLERRM);
END;


-- FUNKCJE 4
-- FUNKCJE 4
CREATE OR REPLACE FUNCTION capitalize_first_last(str IN VARCHAR2) RETURN VARCHAR2
IS
  v_result VARCHAR2(4000);
BEGIN
  IF str IS NULL THEN
    RETURN NULL;
  END IF;
  
  v_result := LOWER(str);

  IF LENGTH(v_result) >= 2 THEN
    v_result := INITCAP(SUBSTR(v_result, 1, 1)) || SUBSTR(v_result, 2, LENGTH(v_result) - 2) || INITCAP(SUBSTR(v_result, -1));
  ELSE
    v_result := INITCAP(v_result);
  END IF;

  RETURN v_result;
END;
-- TEST
DECLARE
  v_input VARCHAR2(100);
  v_output VARCHAR2(100);
BEGIN
  v_input := 'aLa Ma KoTa';
  v_output := capitalize_first_last(v_input);
  DBMS_OUTPUT.PUT_LINE('Wynik: ' || v_output);
END;


-- FUNKCJE 5
CREATE OR REPLACE FUNCTION pesel_to_birthdate(pesel_param IN VARCHAR2) 
RETURN VARCHAR2
IS
  v_birthdate VARCHAR2(11);
  v_year NUMBER;
  v_month NUMBER;
  v_day NUMBER;
BEGIN
  IF LENGTH(pesel_param) <> 11 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Nieprawidłowa długość numeru PESEL');
  END IF;

  v_year := TO_NUMBER(SUBSTR(pesel_param, 1, 2));
  v_month := TO_NUMBER(SUBSTR(pesel_param, 3, 2));
  v_day := TO_NUMBER(SUBSTR(pesel_param, 5, 2));

  IF v_month < 20 THEN
    v_year := v_year + 1900;
  ELSE
    v_year := v_year + 2000;
  END IF;
  
  v_birthdate := TRIM(TO_CHAR(v_year, '0000')) || '-' || TRIM(TO_CHAR(v_month, '00')) || '-' || TRIM(TO_CHAR(v_day, '00'));

  RETURN v_birthdate;
EXCEPTION
  WHEN OTHERS THEN
    RAISE_APPLICATION_ERROR(-20002, 'Błąd: ' || SQLERRM);
END;
-- TEST
DECLARE
  v_pesel VARCHAR2(11);
  v_birthdate VARCHAR2(10);
BEGIN
  v_pesel := '99052421433';
  v_birthdate := pesel_to_birthdate(v_pesel);
  DBMS_OUTPUT.PUT_LINE('Data urodzenia: ' || v_birthdate);
END;


-- FUNKCJE 6
CREATE OR REPLACE FUNCTION get_employee_department_count(country_name_param IN VARCHAR2)
RETURN VARCHAR2
IS
  v_employee_count NUMBER;
  v_department_count NUMBER;
BEGIN
  SELECT COUNT(*)
  INTO v_department_count
  FROM countries c
  JOIN locations l ON c.country_id = l.country_id
  JOIN departments d ON d.location_id = l.location_id 
  WHERE UPPER(country_name) = UPPER(country_name_param);

  IF v_department_count = 0 THEN
    RAISE_APPLICATION_ERROR(-20001, 'Kraj nie istnieje w bazie danych');
  END IF;

  SELECT COUNT(*) INTO v_employee_count
  FROM employees e
  JOIN departments d ON e.department_id = d.department_id
  JOIN locations l ON d.location_id = l.location_id
  JOIN countries c ON l.country_id = c.country_id
  WHERE UPPER(c.country_name) = UPPER(country_name_param);

  RETURN 'Liczba pracowników: ' || TO_CHAR(v_employee_count) || ', Liczba departamentów: ' || TO_CHAR(v_department_count);
EXCEPTION
  WHEN NO_DATA_FOUND THEN
    RAISE_APPLICATION_ERROR(-20002, 'Brak danych');
END;
-- TEST
DECLARE
  v_result VARCHAR2(100);
BEGIN
  v_result := get_employee_department_count('United States of America');
  DBMS_OUTPUT.PUT_LINE('Wynik: ' || v_result);
END;


-- WYZWALACZE 1
-- TABELA POMOCNICZA
CREATE TABLE archiwum_departamentow (
    id NUMBER,
    nazwa VARCHAR2(100),
    data_zamknięcia DATE,
    ostatni_manager VARCHAR2(100)
);
-- WYZWALACZ
CREATE OR REPLACE TRIGGER archiwum_departamentow_trigger
AFTER DELETE ON departments
FOR EACH ROW
DECLARE
    v_manager_first_name employees.first_name%TYPE;
    v_manager_last_name employees.last_name%TYPE;
BEGIN
    SELECT first_name, last_name
    INTO v_manager_first_name, v_manager_last_name
    FROM employees
    WHERE employee_id = :OLD.manager_id;

    INSERT INTO archiwum_departamentow (id, nazwa, data_zamknięcia, ostatni_manager)
    VALUES (:OLD.department_id, :OLD.department_name, SYSDATE, v_manager_first_name || ' ' || v_manager_last_name);
END;
