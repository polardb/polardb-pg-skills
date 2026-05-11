-- 索引使用情况
-- 查看索引的扫描次数和大小，评估索引使用效率
-- 扫描次数阈值: > 1000 正常, 100-1000 警告, 0 未使用
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    indexrelname AS 索引名,
    pg_size_pretty(pg_relation_size(indexrelid)) AS 索引大小,
    idx_scan AS 索引扫描次数,
    idx_tup_read AS 读取元组数,
    idx_tup_fetch AS 获取元组数
FROM pg_stat_user_indexes
ORDER BY idx_scan ASC, pg_relation_size(indexrelid) DESC
LIMIT 20;
