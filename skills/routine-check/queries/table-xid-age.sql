-- 表事务ID年龄
-- 检查表级别的事务ID年龄，定位可能导致回卷问题的表
SELECT
    c.relname AS 表名,
    pg_size_pretty(pg_total_relation_size(c.oid)) AS 总大小,
    age(c.relfrozenxid) AS 事务ID年龄,
    s.n_dead_tup AS 死行数,
    s.n_live_tup AS 活跃行数,
    s.last_vacuum,
    s.last_autovacuum
FROM pg_stat_user_tables s
JOIN pg_class c ON s.relname = c.relname AND s.schemaname = c.relnamespace::regnamespace::text
WHERE c.relkind = 'r'
ORDER BY age(c.relfrozenxid) DESC;
