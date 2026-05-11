-- 索引效率分析
-- 查找索引扫描但返回大量行的索引 (可能需要优化)
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    indexrelname AS 索引名,
    idx_scan AS 扫描次数,
    idx_tup_read AS 读取元组数,
    CASE
        WHEN idx_scan = 0 THEN 0
        ELSE ROUND(idx_tup_read::numeric / idx_scan, 2)
    END AS 平均每次读取行数,
    pg_size_pretty(pg_relation_size(indexrelid)) AS 索引大小
FROM pg_stat_user_indexes
WHERE idx_scan > 100
ORDER BY (idx_tup_read::numeric / idx_scan) DESC
LIMIT 20;
