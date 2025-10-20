--Assignment 5, Advanced SQL Queries

--Query 1: Avg CPU utilization per server in the last 24h
COLUMN server_name FORMAT A15
SELECT
  s.server_name,
  ROUND(AVG(pm.metric_value), 1) AS avg_cpu_24h
FROM
  SERVERS s
JOIN
  PERFORMANCE_METRICS pm
    ON pm.server_id = s.server_id
WHERE
  pm.metric_type = 'cpu_util'
  AND pm.timestamp >= SYSTIMESTAMP - INTERVAL '24' HOUR
GROUP BY
  s.server_name
ORDER BY
  avg_cpu_24h DESC NULLS LAST;