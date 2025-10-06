-- Assignment 4 - Part 1
-- Construction of 7-8 simple queries


-- Query 1: Show all servers and their status
SELECT server_id AS "Server ID",
        location AS "Location",
        status AS "Status"
FROM Servers
ORDER BY location, server_id;

-- Query 2: Show all users that are registered in the system + roles
SELECT user_id AS "User ID",
       NAME AS "Name",
       ROLE AS "Role"
FROM Users
ORDER BY NAME;

-- Query 3: Show all servers that experiened high CPU usage
SELECT metric_id AS "Metric ID",
       server_id AS "Server ID",
       metric_type AS "Metric Type",
       metric_value AS "Metric Value",
       timestamp AS "Timestamp"
FROM Performance_Metrics
WHERE metric_type = 'cpu_util'
  AND metric_value >= 50
ORDER BY timestamp DESC;

-- Query 4: Show maintenance records that occured in Ottawa server
SELECT m.maintenance_id AS "Maintenance ID",
       m.maintenance_type AS "Maintenance Type",
       m.notes AS "Notes",
       s.location AS "Location"
FROM Maintenance m
JOIN Servers s ON m.server_id = s.server_id
WHERE m.server_id = 111
ORDER BY m.maintenance_id DESC;

-- Query 5: Show all sensors that record a temperature above 35 degrees
SELECT sensor_id AS "Sensor ID",
       sensor_type AS "Sensor Type",
       SENSOR_VALUE AS "Sensor Value"
FROM Environmental_Sensors
WHERE sensor_type = 'temperature'
  AND SENSOR_VALUE > 22
ORDER BY sensor_id;

-- Query 6: Count maintenance records by status
SELECT status AS "Maintenance Status",
       COUNT(*) AS "Record Count"
FROM Maintenance
GROUP BY status
ORDER BY "Record Count" DESC;

-- Query 7: Average sensor value by sensor type
SELECT sensor_type AS "Sensor Type",
       AVG(TO_NUMBER(sensor_value)) AS "Average Sensor Value"
FROM Environmental_Sensors
GROUP BY sensor_type
ORDER BY sensor_type;








