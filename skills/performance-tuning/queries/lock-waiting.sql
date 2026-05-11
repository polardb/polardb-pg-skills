-- 锁等待分析
-- 查找正在等待锁的会话
SELECT
    blocked.pid AS 被阻塞PID,
    blocked.query AS 被阻塞查询,
    blocking.pid AS 阻塞源PID,
    blocking.query AS 阻塞源查询,
    now() - blocked.query_start AS 等待时长
FROM pg_stat_activity blocked
JOIN pg_stat_activity blocking ON blocking.pid = ANY(
    pg_blocking_pids(blocked.pid)
)
WHERE blocked.wait_event_type = 'Lock'
ORDER BY blocked.query_start;
