-- 等待中的连接
-- 查找正在等待资源的连接
SELECT
    pid AS 进程ID,
    now() - query_start AS 等待时长,
    state AS 状态,
    wait_event_type AS 等待类型,
    wait_event AS 等待事件,
    query AS 查询语句
FROM pg_stat_activity
WHERE wait_event IS NOT NULL
  AND state != 'idle'
ORDER BY query_start;
