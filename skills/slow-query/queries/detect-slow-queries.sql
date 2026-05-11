-- 慢查询检测 (需要 pg_stat_statements 扩展)
-- 识别执行时间最长的查询，按总执行时间降序排列
-- 参考阈值: 正常 < 100ms, 警告 100ms-1s, 危险 > 1s

SELECT
    queryid AS 查询ID,
    calls AS 调用次数,
    ROUND(total_exec_time::numeric, 2) AS 总执行时间ms,
    ROUND(mean_exec_time::numeric, 2) AS 平均执行时间ms,
    ROUND(max_exec_time::numeric, 2) AS 最大执行时间ms,
    ROUND(min_exec_time::numeric, 2) AS 最小执行时间ms,
    ROUND(stddev_exec_time::numeric, 2) AS 标准差ms,
    CASE
        WHEN mean_exec_time < 100 THEN '正常'
        WHEN mean_exec_time < 1000 THEN '警告'
        ELSE '危险'
    END AS 状态评估,
    ROUND((100 * total_exec_time / SUM(total_exec_time) OVER())::numeric, 2) AS 时间占比,
    query AS 查询语句
FROM pg_stat_statements
WHERE calls > 0
ORDER BY total_exec_time DESC
LIMIT 30;
