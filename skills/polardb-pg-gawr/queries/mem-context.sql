-- 内存上下文分析
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_mcxt
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;

-- 大内存进程的内存上下文详情
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_max_memory_backend_memory_context
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;

-- 共享内存分配
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_shmem_allocation
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;
