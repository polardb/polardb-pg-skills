-- I/O 密集查询检测 (需要 pg_stat_statements 扩展)
-- 识别磁盘 I/O 消耗最大的查询
-- 这些查询可能需要添加索引或增大 shared_buffers

SELECT
    queryid AS 查询ID,
    calls AS 调用次数,
    ROUND(mean_exec_time::numeric, 2) AS 平均执行时间ms,
    shared_blks_read AS 磁盘读取块数,
    shared_blks_hit AS 缓存命中块数,
    ROUND((shared_blks_read::float / NULLIF(calls, 0))::numeric, 2) AS 每次调用读取块数,
    ROUND((shared_blks_hit::float / NULLIF(shared_blks_hit + shared_blks_read, 0) * 100)::numeric, 2) AS 缓存命中率,
    CASE
        WHEN shared_blks_hit::float / NULLIF(shared_blks_hit + shared_blks_read, 0) * 100 > 99 THEN '良好'
        WHEN shared_blks_hit::float / NULLIF(shared_blks_hit + shared_blks_read, 0) * 100 > 95 THEN '警告'
        ELSE '需要优化'
    END AS 缓存状态,
    local_blks_read AS 本地块读取,
    local_blks_hit AS 本地块命中,
    blk_read_time AS 块读取时间ms,
    blk_write_time AS 块写入时间ms,
    query AS 查询语句
FROM pg_stat_statements
WHERE calls > 0 AND shared_blks_read > 0
ORDER BY shared_blks_read DESC
LIMIT 20;
