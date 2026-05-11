-- 索引候选建议
-- 基于查询模式识别可能需要索引的列
-- 分析慢查询的 WHERE 和 JOIN 条件

-- 查找没有索引的大表 (可能需要添加索引)
SELECT
    schemaname AS 模式名,
    relname AS 表名,
    n_live_tup AS 估计行数,
    seq_scan AS 顺序扫描次数,
    idx_scan AS 索引扫描次数,
    CASE
        WHEN idx_scan IS NULL OR idx_scan = 0 THEN '无索引或未使用'
        WHEN seq_scan > idx_scan * 10 THEN '索引使用率低'
        ELSE '正常'
    END AS 索引状态,
    ROUND((seq_tup_read::float / NULLIF(seq_scan, 0))::numeric, 2) AS 平均顺序读取行数,
    pg_size_pretty(pg_relation_size(schemaname || '.' || relname)) AS 表大小
FROM pg_stat_user_tables
WHERE n_live_tup > 1000  -- 只关注较大的表
    AND seq_scan > 0  -- 有顺序扫描
ORDER BY
    CASE
        WHEN idx_scan IS NULL OR idx_scan = 0 THEN 1
        WHEN seq_scan > idx_scan * 10 THEN 2
        ELSE 3
    END,
    seq_scan DESC
LIMIT 20;

-- 查看表的现有索引
-- SELECT indexname, indexdef FROM pg_indexes WHERE tablename = 'your_table';

-- 创建索引建议:
-- 1. 为 WHERE 条件中频繁使用的列创建索引
-- 2. 为 JOIN 条件列创建索引
-- 3. 为 ORDER BY 列创建索引 (如果经常排序)
-- 4. 考虑组合索引: 将选择性高的列放在前面
-- 5. 考虑覆盖索引: INCLUDE 经常查询的列

-- 创建索引示例:
-- CREATE INDEX idx_name ON table_name (column1, column2);
-- CREATE INDEX idx_name ON table_name (filter_col) INCLUDE (select_col);
