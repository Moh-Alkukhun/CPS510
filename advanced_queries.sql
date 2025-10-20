--Assignment 5, Advanced SQL Queries

--Query 1: Latest CPU per server (most recent reading)
COLUMN server_name FORMAT A15
WITH latest AS (
  SELECT pm.server_id,
         TO_NUMBER(pm.metric_value) AS cpu,
         pm.timestamp AS reading_time,
         ROW_NUMBER() OVER (PARTITION BY pm.server_id ORDER BY pm.timestamp DESC) rn
  FROM PERFORMANCE_METRICS pm
  WHERE pm.metric_type = 'cpu_util'
)
SELECT
  s.server_id,
  s.server_name,
  s.location,
  l.cpu           AS cpu_latest,
  l.reading_time  AS latest_timestamp
FROM SERVERS s
JOIN latest l
  ON l.server_id = s.server_id
 WHERE l.rn = 1
ORDER BY cpu_latest DESC NULLS LAST;


--Query 2: Which locations have consistently high CPU?
COLUMN location FORMAT A12
SELECT
  s.location,
  ROUND(AVG(TO_NUMBER(pm.metric_value)),1) AS avg_cpu,
  ROUND(STDDEV(TO_NUMBER(pm.metric_value)),1) AS sd_cpu,
  COUNT(*) AS samples
FROM SERVERS s
JOIN PERFORMANCE_METRICS pm
  ON pm.server_id = s.server_id
WHERE LOWER(pm.metric_type) = 'cpu_util'
GROUP BY s.location
HAVING AVG(TO_NUMBER(pm.metric_value)) >= 30   
   AND COUNT(*) >= 2
ORDER BY avg_cpu DESC;

--Query 3: Active Servers with no open scheduled maintenance
COLUMN server_name FORMAT A15
SELECT
  s.server_id,
  s.server_name,
  s.location,
  s.status
FROM SERVERS s
LEFT JOIN MAINTENANCE m
  ON m.server_id = s.server_id
 AND LOWER(m.status) IN ('open','scheduled')
WHERE LOWER(s.status) = 'active'
  AND m.server_id IS NULL
ORDER BY s.location, s.server_name;

-- Query 4: Incident load by server (alerts + open/scheduled maintenance), ranked

COLUMN server_name FORMAT A15

WITH incidents AS (
  SELECT a.server_id, 'alert' AS src
  FROM ALERTS a
  UNION ALL
  SELECT m.server_id, 'maint' AS src
  FROM MAINTENANCE m
  WHERE LOWER(TRIM(m.status)) IN ('open','scheduled','in progress','in_progress')
)
SELECT
  s.server_id,
  s.server_name,
  s.location,
  COUNT(*) AS total_incidents,
  SUM(CASE WHEN i.src = 'alert' THEN 1 ELSE 0 END) AS alerts,
  SUM(CASE WHEN i.src = 'maint' THEN 1 ELSE 0 END) AS maint_open_sched,
  RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_by_incidents
FROM incidents i
JOIN SERVERS s ON s.server_id = i.server_id
GROUP BY s.server_id, s.server_name, s.location
ORDER BY total_incidents DESC, s.server_name;


-- Query 5: Alerts by location & severity (with location totals)

COLUMN location FORMAT A12
COLUMN severity FORMAT A10

SELECT
  s.location,
  LOWER(a.severity) AS severity,
  COUNT(*) AS alerts,
  COUNT(DISTINCT s.server_id) AS servers_affected
FROM SERVERS s
JOIN ALERTS a
  ON a.server_id = s.server_id
GROUP BY ROLLUP (s.location, LOWER(a.severity))
ORDER BY s.location NULLS LAST, severity NULLS LAST;





