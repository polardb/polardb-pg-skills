-- 按查询分析索引使用情况
-- 识别特定查询的索引使用效率
-- 帮助优化慢查询的索引策略

-- 查看每个表的索引使用详情
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    indexrelname AS 索引名,
    idx_scan AS 索引扫描次数,
    idx_tup_read AS 索引读取元组数,
    idx_tup_fetch AS 索引获取元组数,
    ROUND((idx_tup_read::float / NULLIF(idx_scan, 0))::numeric, 2) AS 每次扫描读取行数,
    CASE
        WHEN idx_scan = 0 THEN '未使用'
        WHEN idx_tup_read::float / NULLIF(idx_scan, 0) < 10 THEN '高效'
        WHEN idx_tup_read::float / NULLIF(idx_scan, 0) < 100 THEN '一般'
        ELSE '低效-考虑优化'
    END AS 效率评估,
    pg_size_pretty(pg_relation_size(indexrelid)) AS 索引大小
FROM pg_stat_user_indexes
ORDER BY idx_scan DESC
LIMIT 30;

-- 查看表上所有索引的定义
-- SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'your_table';

-- 索引优化建议:
-- 1. 未使用的索引: 考虑删除以减少写入开销
-- 2. 低效索引: 检查是否需要调整索引列顺序
-- 3. 重复索引: 检查是否有功能重叠的索引

-- 查找重复/冗余索引
SELECT
    a.indexrelid::regclass AS 索引名,
    a.indrelid::regclass AS 表名,
    pg_get_indexdef(a.indexrelid) AS 索引定义
FROM pg_index a
JOIN pg_index b ON a.indrelid = b.indrelid
    AND a.indexrelid != b.indexrelid
    AND (
        (a.indkey::text LIKE b.indkey::text || ' %')
        OR (a.indkey::text = b.indkey::text)
    )
WHERE a.indisunique = false
LIMIT 10;
