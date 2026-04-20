-- PolarDB 复制延迟趋势
-- RO 节点延迟（通过 dbmetrics 中的 replay_lag、bg_replay_lag）
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    MAX(replay_lag) AS replay_lag_mb,
    MAX(bg_replay_lag) AS bg_replay_lag_mb,
    MAX(min_used_lag) AS min_used_lag_mb,
    MAX(logindex_mem_tbl_size) AS logindex_mem_tbl_size
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
  AND role = 'RO'
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;

-- RW 节点上看到的各 RO/Standby 的复制延迟
SELECT
    to_timestamp(time - time % 300) AS ts,
    application_name,
    MAX(replay_lag_in_ms) AS replay_lag_ms,
    MAX(replay_latency_in_bytes) AS replay_lag_bytes,
    MAX(sent_latency_in_bytes) AS sent_lag_bytes
FROM polar_gawr_collection.view_fact_pg_stat_replication
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, application_name
ORDER BY ts;

-- dbmetrics 中的复制延迟指标汇总（仅 RW 节点）
SELECT
    to_timestamp(time - time % 300) AS ts,
    MAX(replay_lag) AS replay_lag,
    MAX(bg_replay_lag) AS bg_replay_lag,
    MAX(min_used_lag) AS min_used_lag,
    MAX(max_slot_wal_delay_in_mb) AS max_slot_wal_delay_mb,
    MAX(inactive_slots) AS inactive_slots
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
  AND role = 'RW'
GROUP BY time - time % 300
ORDER BY ts;
