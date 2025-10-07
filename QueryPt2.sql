-- Creating Advanced Queries - Part 2 - Assignment 4

--Able to show most recent metric entry for each
--Filters Performance_Metrics to keep only new record
--Easier to query the latest CPU, memory or other metrics
WITH last_mnt AS (
  SELECT
    m.*,
    ROW_NUMBER() OVER (PARTITION BY m.server_id ORDER BY m."timestamp" DESC) AS rn
  FROM Maintenance m
)
SELECT
  s.server_id       AS "Server ID",
  s.location        AS "Location",
  s.status          AS "Status",
  lm.maintenance_type AS "Maintenance Type",
  lm.timestamp    AS "Maintenance Time",
  u.name            AS "Technician",
  u.role            AS "Role"
FROM Servers s
LEFT JOIN last_mnt lm ON lm.server_id = s.server_id AND lm.rn = 1
LEFT JOIN Users u     ON u.user_id = lm.user_id
WHERE UPPER(s.status) = 'ACTIVE'
ORDER BY s.location, s.server_id;