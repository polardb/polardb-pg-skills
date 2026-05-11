-- 表大小和统计信息
-- 检查表大小、活跃行、死行比例和 VACUUM 状态
-- 死行比例阈值: < 10% 正常, 10-30% 警告, > 30% 危险
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    pg_size_pretty(pg_total_relation_size(relid)) AS 总大小,
    n_live_tup AS 活跃行数,
    n_dead_tup AS 死行数,
    CASE
        WHEN n_live_tup + n_dead_tup = 0 THEN 0
        ELSE ROUND(100.0 * n_dead_tup / (n_live_tup + n_dead_tup), 2)
    END AS 死行比例,
    last_vacuum AS 最后手动VACUUM,
    last_autovacuum AS 最后自动VACUUM,
    last_analyze AS 最后手动ANALYZE,
    last_autoanalyze AS 最后自动ANALYZE
FROM pg_stat_user_tables
ORDER BY pg_total_relation_size(relid) DESC;
