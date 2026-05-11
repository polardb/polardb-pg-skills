-- 索引使用效率
-- 分析索引的扫描效率和缓存命中率
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    indexrelname AS 索引名,
    idx_scan AS 扫描次数,
    idx_tup_read AS 读取元组数,
    idx_tup_fetch AS 获取元组数,
    CASE
        WHEN idx_scan = 0 THEN '未使用'
        WHEN idx_tup_read::float / idx_scan < 10 THEN '高效'
        ELSE '低效'
    END AS 效率评估
FROM pg_stat_user_indexes
WHERE idx_scan > 0
ORDER BY idx_scan DESC;
