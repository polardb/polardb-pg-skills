-- 查询统计 (需要 pg_stat_statements 扩展)
-- 查找调用次数最多和读取行数最多的查询
SELECT
    calls AS 调用次数,
    rows AS 返回行数,
    ROUND(mean_exec_time::numeric, 2) AS 平均执行时间ms,
    shared_blks_hit AS 缓存命中,
    shared_blks_read AS 磁盘读取,
    query AS 查询语句
FROM pg_stat_statements
ORDER BY calls DESC
LIMIT 20;
