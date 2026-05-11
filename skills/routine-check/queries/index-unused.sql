-- 未使用的索引
-- 找出从未被使用的索引，可考虑删除以节省空间和提高写入性能
-- 注意: 主键和唯一约束索引不应删除
SELECT
    schemaname || '.' || relname AS 表,
    indexrelname AS 索引名,
    pg_size_pretty(pg_relation_size(indexrelid)) AS 索引大小,
    idx_scan AS 扫描次数
FROM pg_stat_user_indexes
WHERE idx_scan = 0
  AND indexrelname NOT LIKE '%_pkey'
  AND indexrelname NOT LIKE '%_unique'
ORDER BY pg_relation_size(indexrelid) DESC;
