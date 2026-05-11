-- 表缓存使用情况
-- 查看哪些表占用了最多的缓存
SELECT
    c.relname AS 表名,
    pg_size_pretty(pg_relation_size(c.oid)) AS 表大小,
    ROUND(
        100.0 * pg_relation_size(c.oid) /
        NULLIF(SUM(pg_relation_size(c2.oid)) OVER(), 0),
        2
    ) AS 大小占比
FROM pg_class c
JOIN pg_namespace n ON n.oid = c.relnamespace
JOIN pg_class c2 ON c2.relkind IN ('r', 'i')
WHERE c.relkind = 'r'
  AND n.nspname NOT IN ('pg_catalog', 'information_schema')
ORDER BY pg_relation_size(c.oid) DESC
LIMIT 20;
