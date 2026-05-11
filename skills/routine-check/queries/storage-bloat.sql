-- 表膨胀估算
-- 检查表的死行情况，评估是否需要 VACUUM
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    pg_size_pretty(pg_relation_size(relid)) AS 表大小,
    n_live_tup AS 活跃行,
    n_dead_tup AS 死行,
    ROUND(100.0 * n_dead_tup / NULLIF(n_live_tup + n_dead_tup, 0), 2) AS 膨胀比例
FROM pg_stat_user_tables
WHERE n_dead_tup > 0
ORDER BY n_dead_tup DESC
LIMIT 20;
