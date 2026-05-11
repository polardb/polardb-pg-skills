-- 长时间运行的查询
-- 查找运行超过 5 分钟的查询
SELECT
    pid AS 进程ID,
    usename AS 用户名,
    now() - query_start AS 运行时长,
    state AS 状态,
    query AS 查询语句
FROM pg_stat_activity
WHERE state = 'active'
  AND query NOT LIKE '%pg_stat_activity%'
  AND now() - query_start > interval '5 minutes'
ORDER BY query_start;
