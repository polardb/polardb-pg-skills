-- 行数估计检查
-- 用于检查表的行数估计准确性
-- 估计偏差大是慢查询的主要原因之一

-- 对比 pg_class 中的估计行数与实际行数
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    n_live_tup AS pg_stat估计行数,
    c.reltuples::bigint AS pg_class估计行数,
    CASE
        WHEN n_live_tup > 0 AND c.reltuples > 0 THEN
            ROUND((ABS(n_live_tup - c.reltuples::bigint)::float / n_live_tup * 100)::numeric, 2)
        ELSE 0
    END AS 估计偏差百分比,
    c.relpages AS 页面数,
    pg_size_pretty(pg_relation_size(c.oid)) AS 表大小,
    CASE
        WHEN c.reltuples = -1 THEN '从未分析'
        WHEN c.reltuples = 0 AND n_live_tup > 0 THEN '需要ANALYZE'
        ELSE '正常'
    END AS 状态
FROM pg_stat_user_tables t
JOIN pg_class c ON t.relid = c.oid
WHERE t.schemaname NOT IN ('pg_catalog', 'information_schema')
ORDER BY n_live_tup DESC
LIMIT 30;

-- 提示: 如果估计偏差大，可以执行以下操作
-- 1. ANALYZE table_name;  -- 更新统计信息
-- 2. SET default_statistics_target = 1000; ANALYZE table_name;  -- 提高采样精度
-- 3. ALTER TABLE table_name ALTER COLUMN col_name SET STATISTICS 1000; ANALYZE table_name;  -- 针对特定列

-- 使用 EXPLAIN ANALYZE 验证特定查询的估计偏差
-- EXPLAIN (ANALYZE, BUFFERS) SELECT * FROM table_name WHERE condition;
-- 对比 rows (估计) 和 actual rows (实际)
-- 如果相差 10 倍以上，统计信息可能存在问题
