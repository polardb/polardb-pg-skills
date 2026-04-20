-- CPU 使用率趋势
-- 包含数据库用户态、系统态、PolarFS daemon CPU
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    ROUND(AVG(cpu_user_usage + cpu_sys_usage)::NUMERIC, 2)       AS cpu_total_pct,
    ROUND(AVG(cpu_user_usage)::NUMERIC, 2)                       AS cpu_user_pct,
    ROUND(AVG(cpu_sys_usage)::NUMERIC, 2)                        AS cpu_sys_pct,
    ROUND(AVG(pfsd_cpu_user / NULLIF(cpu_cores, 0))::NUMERIC, 2) AS pfsd_cpu_user_pct,
    ROUND(AVG(pfsd_cpu_sys / NULLIF(cpu_cores, 0))::NUMERIC, 2)  AS pfsd_cpu_sys_pct,
    MAX(cpu_cores)                                                AS cpu_cores
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;
