-- 内存使用率趋势
-- 包含总内存使用率和各组件内存
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    ROUND(AVG(mem_total_usage)::NUMERIC, 2)   AS mem_usage_pct,
    ROUND(AVG(mem_total_used)::NUMERIC, 0)    AS mem_used_mb,
    MAX(mem_total)                             AS mem_total_mb,
    ROUND(AVG(engine_mem_used)::NUMERIC, 0)   AS engine_mem_mb,
    ROUND(AVG(pfsd_mem_used)::NUMERIC, 0)     AS pfsd_mem_mb,
    ROUND(AVG(manager_mem_used)::NUMERIC, 0)  AS manager_mem_mb,
    ROUND(AVG(engine_kmem_used)::NUMERIC, 0)  AS engine_kmem_mb,
    ROUND(AVG(engine_mem_mapped_file)::NUMERIC, 0) AS mapped_file_mb
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;
