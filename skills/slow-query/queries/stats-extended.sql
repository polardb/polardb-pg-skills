-- 扩展统计信息查询 (PostgreSQL 10+)
-- 查看已创建的扩展统计信息
-- 扩展统计用于解决多列关联导致的估计偏差问题

-- 查看现有扩展统计信息
SELECT
    stxname AS 统计名称,
    stxnamespace::regnamespace AS 模式名,
    stxrelid::regclass AS 表名,
    CASE
        WHEN 'd' = ANY(stxkind) THEN '是'
        ELSE '否'
    END AS 包含dependencies,
    CASE
        WHEN 'n' = ANY(stxkind) THEN '是'
        ELSE '否'
    END AS 包含ndistinct,
    CASE
        WHEN 'f' = ANY(stxkind) THEN '是'
        ELSE '否'
    END AS 包含mcv,
    CASE
        WHEN 'e' = ANY(stxkind) THEN '是'
        ELSE '否'
    END AS 包含expressions,
    pg_get_statisticsobjdef(oid) AS 定义
FROM pg_statistic_ext
ORDER BY stxrelid::regclass::text;

-- 提示: 创建扩展统计信息的语法
-- CREATE STATISTICS stat_name (dependencies) ON col1, col2 FROM table_name;
-- CREATE STATISTICS stat_name (ndistinct) ON col1, col2 FROM table_name;
-- CREATE STATISTICS stat_name ON (expression) FROM table_name;  -- PG14+
-- 创建后需要执行 ANALYZE table_name 来收集统计信息
