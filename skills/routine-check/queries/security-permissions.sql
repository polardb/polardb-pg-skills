-- 表权限检查
-- 查看非默认用户的表权限
SELECT
    grantee AS 被授权者,
    table_schema AS 模式名,
    table_name AS 表名,
    privilege_type AS 权限类型
FROM information_schema.table_privileges
WHERE grantee NOT IN ('PUBLIC', 'postgres')
ORDER BY table_schema, table_name;
