-- Join 分析查询
-- 查看表之间的关系和 Join 统计信息
-- 帮助识别可能存在 Join 性能问题的场景

-- 查看外键关系 (可能需要 Join 的表)
SELECT
    tc.table_schema AS 模式名,
    tc.table_name AS 子表,
    kcu.column_name AS 外键列,
    ccu.table_name AS 父表,
    ccu.column_name AS 引用列,
    CASE
        WHEN idx.indexname IS NOT NULL THEN '有索引'
        ELSE '无索引 - 建议创建'
    END AS 外键索引状态
FROM information_schema.table_constraints tc
JOIN information_schema.key_column_usage kcu
    ON tc.constraint_name = kcu.constraint_name
    AND tc.table_schema = kcu.table_schema
JOIN information_schema.constraint_column_usage ccu
    ON ccu.constraint_name = tc.constraint_name
    AND ccu.table_schema = tc.table_schema
LEFT JOIN pg_indexes idx
    ON idx.tablename = tc.table_name
    AND idx.schemaname = tc.table_schema
    AND idx.indexdef LIKE '%' || kcu.column_name || '%'
WHERE tc.constraint_type = 'FOREIGN KEY'
    AND tc.table_schema NOT IN ('pg_catalog', 'information_schema')
ORDER BY tc.table_name;

-- 常见 Join 类型说明:
-- Nested Loop: 外表每行与内表 Join，适合小表或有索引的情况
--   问题: 如果外表行数被低估，会导致内表被循环多次
-- Hash Join: 构建哈希表，适合大表等值 Join
--   问题: 需要足够的 work_mem
-- Merge Join: 两表排序后合并，适合已排序的数据
--   问题: 需要排序操作，可能消耗 CPU

-- 调优建议:
-- 1. 确保 Join 列有适当索引
-- 2. 确保统计信息准确 (ANALYZE)
-- 3. 考虑调整 work_mem 参数
