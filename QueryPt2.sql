-- Creating Advanced Queries - Part 2 - Assignment 4

--Query 1:
--Able to show most recent metric entry for each
--Filters Performance_Metrics to keep only new record
--Easier to query the latest CPU, memory or other metrics
--Uses JOIN
WITH last_mnt AS (
  SELECT
    m.*,
    ROW_NUMBER() OVER (
      PARTITION BY m.server_id
      ORDER BY m."TIMESTAMP" DESC
    ) AS rn
  FROM Maintenance m
)
SELECT
  s.server_id           AS "Server ID",
  s.location            AS "Location",
  s.status              AS "Status",
  lm.maintenance_type   AS "Maintenance Type",
  lm."TIMESTAMP"        AS "Maintenance Time",
  u.name                AS "Technician",
  u.role                AS "Role"
FROM Servers s
LEFT JOIN last_mnt lm ON lm.server_id = s.server_id AND lm.rn = 1
LEFT JOIN Users u     ON u.user_id = lm.user_id
WHERE UPPER(s.status) = 'ACTIVE'
ORDER BY s.location, s.server_id;


--Query 2
--Top 3 servers by averafe CPU over the last 7 days
--DENSe_RANK used
WITH cpu_7d AS (
  SELECT
    pm.server_id,
    AVG(pm.metric_value) AS avg_cpu
  FROM Performance_Metrics pm
  WHERE pm.metric_type = 'cpu_util'
    AND pm."TIMESTAMP" >= (SYSDATE - 7)
  GROUP BY pm.server_id
),
ranked AS (
  SELECT
    server_id,
    avg_cpu,
    DENSE_RANK() OVER (ORDER BY avg_cpu DESC) AS rnk
  FROM cpu_7d
)
SELECT
  r.server_id     AS "Server ID",
  ROUND(r.avg_cpu, 2) AS "Avg CPU (7d)"
FROM ranked r
WHERE r.rnk <= 3
ORDER BY r.avg_cpu DESC, r.server_id;

--Query 3
--Mean time to resolution by server location
--MTTR means how long it usually takes to fix a problem after its reported
SELECT
  s.location           AS "Location",
  COUNT(*)             AS "Resolved Alerts"
FROM Alerts a
JOIN Servers s ON s.server_id = a.server_id
WHERE UPPER(a.status) = 'RESOLVED'
GROUP BY s.location
ORDER BY "Resolved Alerts" DESC;


--Query 4
--Maintenance pipeline by location
--Counts scheduled/in_progress/completed items per location and shows the last completed time.

SELECT
  s.location AS "Location",
  SUM(CASE WHEN LOWER(m.status) = 'scheduled'   THEN 1 ELSE 0 END)    AS "Scheduled",
  SUM(CASE WHEN LOWER(m.status) = 'in_progress' THEN 1 ELSE 0 END)    AS "In Progress",
  SUM(CASE WHEN LOWER(m.status) = 'completed'   THEN 1 ELSE 0 END)    AS "Completed",
  MAX(CASE WHEN LOWER(m.status) = 'completed' THEN m."TIMESTAMP" END) AS "Last Completed"
FROM Maintenance m
JOIN Servers s ON s.server_id = m.server_id
GROUP BY s.location
ORDER BY "In Progress" DESC, "Scheduled" DESC, "Location";


-- Query 5

CREATE OR REPLACE VIEW Monthly_Server_Health AS
SELECT
  s.server_id,
  s.server_name,
  TO_CHAR(p.timestamp, 'YYYY-MM') AS month, -- Group by month
  AVG(CASE WHEN p.metric_type = 'cpu_util' THEN p.metric_value END) AS avg_cpu_usage,
  MAX(CASE WHEN m.status = 'completed' THEN m.timestamp END) AS last_maintenance_time,
  MAX(CASE WHEN m.status = 'completed' THEN m.status END) AS last_maintenance_status
FROM SERVERS s
JOIN PERFORMANCE_METRICS p ON s.server_id = p.server_id
LEFT JOIN MAINTENANCE m ON s.server_id = m.server_id AND TO_CHAR(p.timestamp, 'YYYY-MM') = TO_CHAR(m.timestamp, 'YYYY-MM')
WHERE p.timestamp >= (SYSDATE - INTERVAL '1' YEAR) -- Consider the last year of data
GROUP BY s.server_id, s.server_name, TO_CHAR(p.timestamp, 'YYYY-MM')
ORDER BY s.server_id, month;

SELECT * FROM Monthly_Server_Health;






