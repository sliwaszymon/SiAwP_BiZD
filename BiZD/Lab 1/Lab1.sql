CREATE TABLE regions (
	region_id NUMBER PRIMARY KEY,
	region_name VARCHAR2(60)
);

CREATE TABLE countries (
	country_id NUMBER PRIMARY KEY,
	country_name VARCHAR2(60),
	region_id NUMBER,
	FOREIGN KEY (region_id) REFERENCES regions(region_id)
);

CREATE TABLE locations (
	location_id NUMBER PRIMARY KEY,
	street_address VARCHAR2(60),
	postal_code VARCHAR2(10),
	city VARCHAR2(60),
	state_province VARCHAR2(60),
	country_id NUMBER,
	FOREIGN KEY (country_id) REFERENCES countries(country_id)
);

CREATE TABLE departments (
	department_id NUMBER PRIMARY KEY,
	department_name VARCHAR2(60),
	manager_id NUMBER,
	location_id NUMBER,
	FOREIGN KEY (location_id) REFERENCES locations(location_id)
);

CREATE TABLE jobs (
	job_id NUMBER PRIMARY KEY,
	job_title VARCHAR2(60),
	min_salary NUMBER,
	max_salary NUMBER,
	CHECK ((max_salary - min_salary) >= 2000)
);

CREATE TABLE employees (
	employee_id NUMBER PRIMARY KEY,
	first_name VARCHAR2(20),
	last_name VARCHAR2(20),
	email VARCHAR2(60),
	phone_number VARCHAR2(13) NULL,
	hire_date DATE,
	job_id NUMBER,
	salary NUMBER,
	commission_pct NUMBER NULL,
	manager_id NUMBER,
	department_id NUMBER,
	FOREIGN KEY (department_id) REFERENCES departments(department_id),
	FOREIGN KEY (job_id) REFERENCES jobs(job_id),
	FOREIGN KEY (manager_id) REFERENCES employees(employee_id)
);

ALTER TABLE departments ADD FOREIGN KEY (manager_id) REFERENCES employees(employee_id);

CREATE TABLE job_history (
	employee_id NUMBER,
	start_date DATE,
	end_date DATE,
	job_id NUMBER,
	department_id NUMBER,
	PRIMARY KEY (employee_id, start_date),
	FOREIGN KEY (job_id) REFERENCES jobs(job_id),
	FOREIGN KEY (department_id) REFERENCES departments(department_id)
);