-- 按进程类型的内存分布
SELECT
    to_timestamp(time - time % 300) AS ts,
    backend_type,
    ROUND(AVG(rss)::NUMERIC, 2) AS avg_rss_mb,
    MAX(rss) AS max_rss_mb,
    ROUND(AVG(backend_num)::NUMERIC, 0) AS avg_backend_num,
    ROUND(AVG(cpu_user)::NUMERIC, 2) AS avg_cpu_user,
    ROUND(AVG(cpu_sys)::NUMERIC, 2) AS avg_cpu_sys
FROM polar_gawr_collection.view_fact_polar_stat_process
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
GROUP BY time - time % 300, backend_type
ORDER BY ts, avg_rss_mb DESC;

-- 最近的大内存进程
SELECT
    to_timestamp(time) AS ts,
    backend_type,
    rss AS rss_mb,
    backend_num,
    shared_read_ps,
    shared_write_ps
FROM polar_gawr_collection.view_fact_polar_stat_process
WHERE time > EXTRACT(EPOCH FROM now() - interval '30 minutes')::INTEGER
ORDER BY rss DESC
LIMIT 20;
