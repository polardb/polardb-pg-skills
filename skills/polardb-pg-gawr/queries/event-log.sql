-- 数据库事件日志（ERROR/FATAL/PANIC/OOM/Core）
-- 查看最近的所有事件
SELECT
    to_timestamp(time) AS ts,
    logical_ins_name,
    physical_ins_name,
    event_type,
    level,
    event_content
FROM polar_gawr_collection.view_fact_polar_event
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
ORDER BY time DESC
LIMIT 50;

-- OOM 事件（signal 9）
SELECT
    to_timestamp(time) AS ts,
    physical_ins_name,
    event_type,
    event_content
FROM polar_gawr_collection.view_fact_polar_event
WHERE time > EXTRACT(EPOCH FROM now() - interval '24 hours')::INTEGER
  AND event_content LIKE '%signal 9%'
ORDER BY time DESC;

-- FATAL/PANIC 级别事件
SELECT
    to_timestamp(time) AS ts,
    physical_ins_name,
    event_type,
    event_content
FROM polar_gawr_collection.view_fact_polar_event
WHERE time > EXTRACT(EPOCH FROM now() - interval '24 hours')::INTEGER
  AND event_type IN ('FATAL', 'PANIC')
ORDER BY time DESC;

-- Core dump 趋势
SELECT
    to_timestamp(time - time % 3600) AS ts,
    physical_ins_name,
    MAX(core_file_num) AS core_files
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '24 hours')::INTEGER
  AND core_file_num > 0
GROUP BY time - time % 3600, physical_ins_name
ORDER BY ts;
