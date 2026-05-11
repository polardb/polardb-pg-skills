-- 统计信息过期的表检测
-- 识别需要重新收集统计信息的大表
-- 大表统计信息不准会导致严重的执行计划问题

SELECT
    schemaname AS 模式名,
    relname AS 表名,
    n_live_tup AS 活元组数,
    n_mod_since_analyze AS analyze后修改行数,
    ROUND((n_mod_since_analyze::float / NULLIF(n_live_tup, 0) * 100)::numeric, 2) AS 修改比例,
    last_analyze AS 最后analyze时间,
    last_autoanalyze AS 最后自动analyze时间,
    COALESCE(last_analyze, last_autoanalyze) AS 最近analyze时间,
    NOW() - COALESCE(last_analyze, last_autoanalyze) AS 距离上次analyze,
    CASE
        WHEN n_mod_since_analyze::float / NULLIF(n_live_tup, 0) > 0.2 THEN '高 - 立即ANALYZE'
        WHEN n_mod_since_analyze::float / NULLIF(n_live_tup, 0) > 0.1 THEN '中 - 建议ANALYZE'
        WHEN NOW() - COALESCE(last_analyze, last_autoanalyze, '1970-01-01'::timestamp) > INTERVAL '7 days' THEN '过期 - 建议ANALYZE'
        ELSE '正常'
    END AS 建议操作,
    pg_size_pretty(pg_relation_size(schemaname || '.' || relname)) AS 表大小
FROM pg_stat_user_tables
WHERE n_live_tup > 1000  -- 只关注有一定数据量的表
ORDER BY
    CASE
        WHEN n_mod_since_analyze::float / NULLIF(n_live_tup, 0) > 0.2 THEN 1
        WHEN n_mod_since_analyze::float / NULLIF(n_live_tup, 0) > 0.1 THEN 2
        ELSE 3
    END,
    n_live_tup DESC
LIMIT 30;
