-- 锁阻塞链分析
-- 查找持有锁并阻塞其他会话的查询
SELECT
    pid,
    state,
    query,
    wait_event_type,
    wait_event,
    now() - query_start AS 持续时间
FROM pg_stat_activity
WHERE pid IN (
    SELECT DISTINCT blocking.pid
    FROM pg_stat_activity blocked
    JOIN pg_stat_activity blocking ON blocking.pid = ANY(
        pg_blocking_pids(blocked.pid)
    )
)
ORDER BY query_start;
