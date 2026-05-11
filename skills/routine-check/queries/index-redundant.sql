-- 重复/冗余索引
-- 检测具有相同列的重复索引，浪费存储和写入性能
SELECT
    pg_size_pretty(SUM(pg_relation_size(idx))::bigint) AS 浪费空间,
    (array_agg(idx))[1] AS 索引1,
    (array_agg(idx))[2] AS 索引2
FROM (
    SELECT
        i.indexrelid::regclass AS idx,
        i.indrelid::regclass AS table,
        string_agg(a.attname, ',' ORDER BY a.attnum) AS cols
    FROM pg_index i
    JOIN pg_attribute a ON a.attrelid = i.indrelid AND a.attnum = ANY(i.indkey)
    GROUP BY table, i.indexrelid, i.indrelid
) sub
GROUP BY table, cols
HAVING COUNT(*) > 1;
