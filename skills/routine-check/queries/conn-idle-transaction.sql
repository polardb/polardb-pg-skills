-- 空闲事务检查
-- 查找处于 idle in transaction 状态的连接，可能持有锁阻塞其他操作
-- 时长阈值: < 60秒 正常, 60-300秒 警告, > 300秒 危险
SELECT
    pid AS 进程ID,
    usename AS 用户名,
    state AS 状态,
    now() - xact_start AS 事务时长,
    query AS 查询语句
FROM pg_stat_activity
WHERE state = 'idle in transaction'
ORDER BY xact_start;
