-- 存储空间趋势（WAL / Base / CSNLog 目录大小）
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    ROUND(AVG(pls_pg_wal_dir_size)::NUMERIC, 2)     AS wal_dir_mb,
    ROUND(AVG(polar_base_dir_size)::NUMERIC, 2)      AS base_dir_mb,
    ROUND(AVG(pls_pg_csnlog_dir_size)::NUMERIC, 2)  AS csnlog_dir_mb,
    MAX(wal_ready_files)                              AS wal_ready_files
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name
ORDER BY ts;
