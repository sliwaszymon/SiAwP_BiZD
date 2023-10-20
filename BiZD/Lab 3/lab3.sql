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
	departments_table DepartmentTable;
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
    TYPE DepartmentRecord IS RECORD (
        department_id departments.department_id%TYPE,
        department_name departments.department_name%TYPE,
        manager_id departments.manager_id%TYPE,
        location_id departments.location_id%TYPE
    );
    
    TYPE DepartmentTable IS TABLE OF DepartmentRecord
        INDEX BY PLS_INTEGER;
    
    department_info DepartmentTable;
    
BEGIN
    -- Wypełniamy tablicę department_info danymi z tabeli departments
    FOR dep IN (SELECT * FROM departments) LOOP
        department_info(r.department_id).department_id := dep.department_id;
        department_info(r.department_id).department_name := dep.department_name;
        department_info(r.department_id).manager_id := dep.manager_id;
        department_info(r.department_id).location_id := dep.location_id;
    END LOOP;
    FOR i IN 1..10 LOOP
        DBMS_OUTPUT.PUT_LINE('Department ID: ' || department_info(i*10).department_id);
        DBMS_OUTPUT.PUT_LINE('Department Name: ' || department_info(i*10.department_name);
        DBMS_OUTPUT.PUT_LINE('Manager ID: ' || department_info(i*10).manager_id);
        DBMS_OUTPUT.PUT_LINE('Location ID: ' || department_info(i*10).location_id);
        DBMS_OUTPUT.NEW_LINE;
    END LOOP;
END;
