-- 文件系统空间使用趋势
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    ROUND(AVG(fs_blocks_usage)::NUMERIC, 2)   AS fs_usage_pct,
    ROUND(AVG(fs_inodes_usage)::NUMERIC, 2)   AS inodes_usage_pct,
    ROUND(AVG(fs_size_total)::NUMERIC, 0)     AS fs_total_mb,
    ROUND(AVG(pls_direntry_usage)::NUMERIC, 2) AS direntry_usage_pct
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name
ORDER BY ts;
