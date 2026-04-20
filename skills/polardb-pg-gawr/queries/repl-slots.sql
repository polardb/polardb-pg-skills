-- 复制槽状态
-- 最近的复制槽快照
SELECT
    to_timestamp(time) AS ts,
    slot_name,
    slot_type,
    active,
    restart_latency_in_bytes
FROM polar_gawr_collection.view_fact_pg_replication_slots
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC;

-- 不活跃复制槽趋势（inactive_slots 来自 dbmetrics）
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    MAX(inactive_slots) AS inactive_slots,
    MAX(max_slot_wal_delay_in_mb) AS max_slot_wal_delay_mb
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name
ORDER BY ts;
