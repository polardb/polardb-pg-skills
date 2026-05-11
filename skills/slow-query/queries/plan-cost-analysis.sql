-- 执行计划代价分析提示
-- 此文件包含用于分析执行计划的指导和示例
-- 使用 EXPLAIN ANALYZE 获取实际执行数据

-- 基本 EXPLAIN 用法 (不实际执行)
-- EXPLAIN SELECT * FROM your_table WHERE condition;

-- 推荐: 带实际统计的 EXPLAIN (会实际执行查询)
-- EXPLAIN (ANALYZE, BUFFERS, TIMING, VERBOSE) SELECT * FROM your_table WHERE condition;

-- JSON 格式输出 (便于程序解析)
-- EXPLAIN (ANALYZE, BUFFERS, TIMING, FORMAT JSON) SELECT * FROM your_table WHERE condition;

-- 查看当前会话的执行计划相关参数
SELECT
    name AS 参数名,
    setting AS 当前值,
    unit AS 单位,
    CASE name
        WHEN 'enable_seqscan' THEN '启用顺序扫描'
        WHEN 'enable_indexscan' THEN '启用索引扫描'
        WHEN 'enable_indexonlyscan' THEN '启用仅索引扫描'
        WHEN 'enable_bitmapscan' THEN '启用位图扫描'
        WHEN 'enable_nestloop' THEN '启用嵌套循环连接'
        WHEN 'enable_hashjoin' THEN '启用哈希连接'
        WHEN 'enable_mergejoin' THEN '启用合并连接'
        WHEN 'enable_sort' THEN '启用排序'
        WHEN 'enable_hashagg' THEN '启用哈希聚合'
        WHEN 'work_mem' THEN '工作内存 (排序/哈希使用)'
        WHEN 'random_page_cost' THEN '随机页面代价'
        WHEN 'seq_page_cost' THEN '顺序页面代价'
        WHEN 'cpu_tuple_cost' THEN 'CPU元组代价'
        WHEN 'cpu_index_tuple_cost' THEN 'CPU索引元组代价'
        WHEN 'cpu_operator_cost' THEN 'CPU操作符代价'
        WHEN 'effective_cache_size' THEN '有效缓存大小'
        WHEN 'default_statistics_target' THEN '默认统计目标'
        ELSE name
    END AS 说明
FROM pg_settings
WHERE name IN (
    'enable_seqscan', 'enable_indexscan', 'enable_indexonlyscan',
    'enable_bitmapscan', 'enable_nestloop', 'enable_hashjoin',
    'enable_mergejoin', 'enable_sort', 'enable_hashagg',
    'work_mem', 'random_page_cost', 'seq_page_cost',
    'cpu_tuple_cost', 'cpu_index_tuple_cost', 'cpu_operator_cost',
    'effective_cache_size', 'default_statistics_target'
)
ORDER BY name;
