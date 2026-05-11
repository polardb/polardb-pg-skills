-- 缺失索引的外键
-- 检查外键列是否缺少索引，缺失索引会导致 JOIN 和级联删除性能问题
SELECT
    tc.table_name AS 表名,
    kcu.column_name AS 列名,
    tc.constraint_name AS 约束名
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
WHERE tc.constraint_type = 'FOREIGN KEY'
  AND NOT EXISTS (
    SELECT 1 FROM pg_indexes pi
    WHERE pi.tablename = tc.table_name
      AND pi.indexdef LIKE '%' || kcu.column_name || '%'
  )
ORDER BY tc.table_name;
