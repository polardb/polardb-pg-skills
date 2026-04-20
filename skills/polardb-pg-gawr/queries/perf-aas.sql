-- AAS 等待事件分析（Average Active Session）
-- 按时间段聚合各等待事件的计数
SELECT
    to_timestamp(time - time % 300) AS ts,
    wait_event_type,
    wait_event,
    SUM(wait_count) AS total_wait_count,
    ROUND(SUM(wait_count)::NUMERIC / 300, 2) AS avg_active_sessions
FROM polar_gawr_collection.view_fact_polar_aas_history
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, wait_event_type, wait_event
ORDER BY ts, total_wait_count DESC;

-- 全时段 Top 20 等待事件汇总
SELECT
    wait_event_type,
    wait_event,
    SUM(wait_count) AS total_wait_count
FROM polar_gawr_collection.view_fact_polar_aas_history
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY wait_event_type, wait_event
ORDER BY total_wait_count DESC
LIMIT 20;

-- dbmetrics 中的等待事件分类统计（粗粒度）
SELECT
    to_timestamp(time - time % 300) AS ts,
    AVG(cpu_waits) AS cpu_waits,
    AVG(lwlock_waits) AS lwlock_waits,
    AVG(lock_waits) AS lock_waits,
    AVG(io_waits) AS io_waits,
    AVG(bufferpin_waits) AS bufferpin_waits,
    AVG(ipc_waits) AS ipc_waits,
    AVG(client_waits) AS client_waits
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300
ORDER BY ts;
