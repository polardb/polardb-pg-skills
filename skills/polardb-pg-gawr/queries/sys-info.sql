-- 操作系统信息
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_sys_info
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 10;
