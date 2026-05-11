-- 数据库事务ID年龄
-- 检查所有数据库的事务ID年龄，防止事务ID回卷
-- 阈值: < 1.5亿 正常, 1.5-20亿 警告, > 20亿 危险
SELECT
    datname AS 数据库名,
    age(datfrozenxid) AS 事务ID年龄,
    datfrozenxid AS 冻结事务ID,
    pg_size_pretty(pg_database_size(datname)) AS 大小
FROM pg_database
WHERE datistemplate = false
ORDER BY age(datfrozenxid) DESC;
