-- 连接状态汇总
-- 按状态、用户、应用分组统计连接数
SELECT
    state AS 状态,
    count(*) AS 连接数,
    usename AS 用户名,
    application_name AS 应用名
FROM pg_stat_activity
WHERE state IS NOT NULL
GROUP BY state, usename, application_name
ORDER BY 连接数 DESC;
