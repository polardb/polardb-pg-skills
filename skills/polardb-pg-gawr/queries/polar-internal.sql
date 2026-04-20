-- PolarDB 内部指标趋势
-- LogIndex、复制延迟、Checkpoint
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    MAX(logindex_mem_tbl_size) AS logindex_mem_size,
    MAX(replay_lag) AS replay_lag,
    MAX(bg_replay_lag) AS bg_replay_lag
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;

-- WAL 相关（仅 RW）
SELECT
    to_timestamp(time - time % 300) AS ts,
    MAX(wal_ready_files) AS wal_ready_files,
    ROUND(AVG(pls_pg_wal_dir_size)::NUMERIC, 2) AS wal_dir_mb,
    ROUND(AVG(polar_wal_dir_size)::NUMERIC, 2) AS polar_wal_dir_mb
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
  AND role = 'RW'
GROUP BY time - time % 300
ORDER BY ts;

-- Checkpoint 相关（仅 RW）
SELECT
    to_timestamp(time - time % 300) AS ts,
    SUM(checkpoints_timed_delta) AS checkpoints_timed,
    SUM(checkpoints_req_delta) AS checkpoints_req,
    SUM(checkpoint_sync_time_delta) AS sync_time_ms,
    SUM(checkpoint_write_time_delta) AS write_time_ms,
    SUM(buffers_checkpoint_delta) AS buffers_checkpoint,
    SUM(buffers_backend_delta) AS buffers_backend
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
  AND role = 'RW'
GROUP BY time - time % 300
ORDER BY ts;

-- GCC/GRC 统计
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_gcc_grc
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 10;
