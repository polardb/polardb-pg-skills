-- 慢查询统计 (需要 pg_stat_statements 扩展)
-- 查找执行时间最长的查询
SELECT
    calls AS 调用次数,
    ROUND(total_exec_time::numeric, 2) AS 总执行时间ms,
    ROUND(mean_exec_time::numeric, 2) AS 平均执行时间ms,
    ROUND((100 * total_exec_time / SUM(total_exec_time) OVER())::numeric, 2) AS 占比,
    query AS 查询语句
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 20;
