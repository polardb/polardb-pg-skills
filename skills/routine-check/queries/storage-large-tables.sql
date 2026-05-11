-- 最大的表 (含索引)
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    pg_size_pretty(pg_total_relation_size(relid)) AS 总大小,
    pg_size_pretty(pg_relation_size(relid)) AS 表大小,
    pg_size_pretty(pg_total_relation_size(relid) - pg_relation_size(relid)) AS 索引大小
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC
LIMIT 20;
