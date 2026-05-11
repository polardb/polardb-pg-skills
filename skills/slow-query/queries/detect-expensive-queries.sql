-- 高消耗查询检测 (需要 pg_stat_statements 扩展)
-- 识别 CPU 和 I/O 消耗最大的查询
-- 帮助发现资源消耗热点

SELECT
    queryid AS 查询ID,
    calls AS 调用次数,
    ROUND(mean_exec_time::numeric, 2) AS 平均执行时间ms,
    rows AS 返回总行数,
    ROUND((rows::float / NULLIF(calls, 0))::numeric, 2) AS 平均返回行数,
    shared_blks_hit AS 缓存命中块数,
    shared_blks_read AS 磁盘读取块数,
    ROUND((shared_blks_hit::float / NULLIF(shared_blks_hit + shared_blks_read, 0) * 100)::numeric, 2) AS 缓存命中率,
    shared_blks_dirtied AS 脏块数,
    shared_blks_written AS 写入块数,
    temp_blks_read AS 临时块读取,
    temp_blks_written AS 临时块写入,
    CASE
        WHEN temp_blks_read + temp_blks_written > 0 THEN '是 (work_mem可能不足)'
        ELSE '否'
    END AS 使用临时文件,
    query AS 查询语句
FROM pg_stat_statements
WHERE calls > 0
ORDER BY (shared_blks_read + temp_blks_read) DESC
LIMIT 20;
