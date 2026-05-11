-- 表空间使用情况
SELECT
    spcname AS 表空间名,
    pg_size_pretty(pg_tablespace_size(oid)) AS 大小,
    pg_catalog.pg_get_userbyid(spcowner) AS 所有者
FROM pg_tablespace
ORDER BY pg_tablespace_size(oid) DESC;
