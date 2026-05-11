-- 统计信息准确性检查
-- 对比估计行数与实际行数，识别统计信息偏差
-- 注意: 此查询需要 DBA 对具体表执行 EXPLAIN ANALYZE 来验证

-- 查看表的统计信息更新时间
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    n_live_tup AS 估计活元组数,
    n_dead_tup AS 死元组数,
    ROUND((n_dead_tup::float / NULLIF(n_live_tup + n_dead_tup, 0) * 100)::numeric, 2) AS 死元组比例,
    last_vacuum AS 最后vacuum时间,
    last_autovacuum AS 最后自动vacuum时间,
    last_analyze AS 最后analyze时间,
    last_autoanalyze AS 最后自动analyze时间,
    CASE
        WHEN last_analyze IS NULL AND last_autoanalyze IS NULL THEN '从未收集'
        WHEN GREATEST(COALESCE(last_analyze, '1970-01-01'), COALESCE(last_autoanalyze, '1970-01-01')) < NOW() - INTERVAL '7 days' THEN '需要更新'
        ELSE '正常'
    END AS 统计状态,
    CASE
        WHEN n_dead_tup::float / NULLIF(n_live_tup + n_dead_tup, 0) > 0.3 THEN '需要VACUUM'
        WHEN n_dead_tup::float / NULLIF(n_live_tup + n_dead_tup, 0) > 0.1 THEN '建议VACUUM'
        ELSE '正常'
    END AS VACUUM建议
FROM pg_stat_user_tables
ORDER BY n_live_tup DESC
LIMIT 50;
