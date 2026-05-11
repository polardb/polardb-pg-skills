-- 数据库基本信息
-- 获取当前数据库名称、版本和大小
SELECT
    current_database() AS 数据库名,
    version() AS 版本,
    pg_size_pretty(pg_database_size(current_database())) AS 数据库大小;
