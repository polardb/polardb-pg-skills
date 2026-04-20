-- IO 吞吐和 IOPS 趋势
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    ROUND(AVG(pls_throughput_read)::NUMERIC, 2)  AS read_throughput_kbs,
    ROUND(AVG(pls_throughput_write)::NUMERIC, 2) AS write_throughput_kbs,
    ROUND(AVG(pls_iops_read)::NUMERIC, 0)        AS iops_read,
    ROUND(AVG(pls_iops_write)::NUMERIC, 0)       AS iops_write,
    MAX(pls_iops_quota)                           AS iops_quota
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;

-- IO 详细信息（按文件类型/位置）
SELECT
    to_timestamp(time - time % 300) AS ts,
    fileloc,
    filetype,
    SUM(read_count) AS read_count,
    SUM(write_count) AS write_count,
    ROUND(AVG(read_throughput)::NUMERIC, 2) AS read_throughput,
    ROUND(AVG(write_throughput)::NUMERIC, 2) AS write_throughput
FROM polar_gawr_collection.view_fact_polar_stat_io_info
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, fileloc, filetype
ORDER BY ts, read_throughput DESC;
