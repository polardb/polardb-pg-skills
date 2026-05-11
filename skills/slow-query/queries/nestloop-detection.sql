-- Nested Loop 问题检测
-- 通过 pg_stat_statements 识别可能存在 nestloop 问题的查询
-- 特征: 高调用次数但返回行数少的查询

-- 查找可能有 nestloop 问题的查询 (高调用，平均返回行少)
SELECT
    queryid AS 查询ID,
    calls AS 调用次数,
    rows AS 总返回行数,
    ROUND((rows::float / NULLIF(calls, 0))::numeric, 2) AS 平均返回行数,
    ROUND(mean_exec_time::numeric, 2) AS 平均执行时间ms,
    ROUND(total_exec_time::numeric, 2) AS 总执行时间ms,
    shared_blks_hit + shared_blks_read AS 总访问块数,
    ROUND(((shared_blks_hit + shared_blks_read)::float / NULLIF(calls, 0))::numeric, 2) AS 每次访问块数,
    CASE
        WHEN rows::float / NULLIF(calls, 0) < 1 AND mean_exec_time > 100 THEN '可能nestloop问题'
        WHEN (shared_blks_hit + shared_blks_read)::float / NULLIF(calls, 0) > 1000 AND rows::float / NULLIF(calls, 0) < 10 THEN '可能全表扫描'
        ELSE '正常'
    END AS 问题诊断,
    query AS 查询语句
FROM pg_stat_statements
WHERE calls > 10  -- 过滤低频查询
ORDER BY
    CASE
        WHEN rows::float / NULLIF(calls, 0) < 1 AND mean_exec_time > 100 THEN 1
        ELSE 2
    END,
    mean_exec_time DESC
LIMIT 20;

-- 诊断说明:
-- 1. "可能nestloop问题": 每次调用返回行很少但执行时间长
--    - 检查 EXPLAIN ANALYZE 中的 loops 值
--    - 如果 loops 很大，说明 nestloop 内表被多次扫描
--    - 解决: 更新统计信息或考虑禁用 nestloop 测试
-- 2. "可能全表扫描": 访问了大量数据块但返回行很少
--    - 检查是否缺少合适的索引
--    - 检查 WHERE 条件是否能使用索引

-- 使用以下命令禁用 nestloop 进行测试:
-- SET enable_nestloop = off;
-- EXPLAIN ANALYZE your_query;
-- RESET enable_nestloop;
