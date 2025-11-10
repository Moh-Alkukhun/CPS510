BEGIN
  EXECUTE IMMEDIATE 'CREATE SEQUENCE METRIC_SEQ START WITH 10000 INCREMENT BY 1';
EXCEPTION WHEN OTHERS THEN IF SQLCODE != -955 THEN RAISE; END IF;
END;
/

INSERT INTO PERFORMANCE_METRICS (metric_id, server_id, metric_type, metric_value, timestamp)
VALUES (METRIC_SEQ.NEXTVAL, 101, 'cpu_util', 82, SYSTIMESTAMP - INTERVAL '2' HOUR);
INSERT INTO PERFORMANCE_METRICS VALUES (METRIC_SEQ.NEXTVAL, 101, 'cpu_util', 68, SYSTIMESTAMP - INTERVAL '5' HOUR);
INSERT INTO PERFORMANCE_METRICS VALUES (METRIC_SEQ.NEXTVAL, 109, 'cpu_util', 76, SYSTIMESTAMP - INTERVAL '1' HOUR);
INSERT INTO PERFORMANCE_METRICS VALUES (METRIC_SEQ.NEXTVAL, 110, 'cpu_util', 91, SYSTIMESTAMP - INTERVAL '3' HOUR);
INSERT INTO PERFORMANCE_METRICS VALUES (METRIC_SEQ.NEXTVAL, 111, 'cpu_util', 73, SYSTIMESTAMP - INTERVAL '4' HOUR);
INSERT INTO PERFORMANCE_METRICS VALUES (METRIC_SEQ.NEXTVAL, 112, 'cpu_util', 64, SYSTIMESTAMP - INTERVAL '2' HOUR);

COMMIT;

SELECT * FROM PERFORMANCE_METRICS;

SELECT * FROM ENVIRONMENTAL_SENSORS;

SHOW USER;
SELECT table_name FROM user_tables ORDER BY table_name;


-------------------------------

SELECT column_name AS primary_key
FROM all_cons_columns
WHERE table_name = 'Maintenance' 
  AND constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'MAINTENANCE' 
      AND constraint_type = 'P'
  );

-------------------------------

SELECT constraint_name, column_name
FROM all_cons_columns
WHERE table_name = 'maintenance'
  AND constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'maintenance'
      AND constraint_type = 'R'
  );


-------------------------------
SELECT * FROM Alerts;

-------------------------------
SELECT column_name AS primary_key
FROM all_cons_columns
WHERE table_name = 'MAINTENANCE'
  AND constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'MAINTENANCE'
      AND constraint_type = 'P'
  );

-------------------------------
SELECT constraint_name, column_name
FROM all_cons_columns
WHERE table_name = 'MAINTENANCE'
  AND constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'MAINTENANCE'
      AND constraint_type = 'R'
  );

-------------------------------
SELECT column_name AS primary_key
FROM all_cons_columns
WHERE table_name = 'PERFORMANCE_METRICS'
  AND constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'PERFORMANCE_METRICS'
      AND constraint_type = 'P'
  );

-------------------------------

SELECT constraint_name, column_name
FROM all_cons_columns
WHERE table_name = 'ALERTS'
  AND constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'ALERTS'
      AND constraint_type = 'R'
  );



-------------------------------
SELECT constraint_name, column_name
FROM all_cons_columns
WHERE table_name = 'ENVIRONMENTAL_SENSORS'
  AND constraint_name IN (
    SELECT constraint_name
    FROM all_constraints
    WHERE table_name = 'ENVIRONMENTAL_SENSORS'
      AND constraint_type = 'R'
  );


ALTER TABLE ENVIRONMENTAL_SENSORS
ADD CONSTRAINT fk_sensor_server
FOREIGN KEY (sensor_server_id)
REFERENCES SERVERS(server_id)
ON DELETE SET NULL;  -- or another action like CASCADE, depending on your needs

-------------------------------
--Creating Roles table:
CREATE TABLE Roles (
    role_id INT PRIMARY KEY,        -- unique ID for each role
    role_name VARCHAR(50),          -- name of the role (e.g., Admin, Technician)
    role_description VARCHAR(255)   -- optional: description of the role
);

SELECT * FROM Roles;

--Replace role_description with access_level
ALTER TABLE Roles
  DROP COLUMN role_description;

ALTER TABLE Roles
  ADD (access_level VARCHAR2(20) NOT NULL);

--Alter the User table by removing role and access_level
ALTER TABLE Users
  DROP COLUMN role;

ALTER TABLE Users
  DROP COLUMN access_level;

--Add foreign key role_id to Users table
ALTER TABLE Users
  ADD (role_id NUMBER);

ALTER TABLE Users
  ADD CONSTRAINT fk_role FOREIGN KEY (role_id) REFERENCES Roles(role_id);
  
SELECT * FROM Users;

--Insert roles into Roles table
INSERT INTO Users (name, email) VALUES ('LJ', 'LJ@gmail.com');

SELECT * FROM Users;

INSERT INTO Roles (role_name, access_level) VALUES ('Admin', 'Administrator');
INSERT INTO Roles (role_name, access_level) VALUES ('Technician', 'Technician');
INSERT INTO Roles (role_name, access_level) VALUES ('User', 'User');
INSERT INTO Roles (role_name, access_level) VALUES ('Manager', 'Manager');

COMMIT;

INSERT INTO Users (name, email, role_id) VALUES ('LJ', 'LJ@gmail.com', 4);
COMMIT;

--Insert users with role_id into Users table





