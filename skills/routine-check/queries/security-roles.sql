-- 角色列表
-- 查看所有数据库角色及其权限
SELECT
    rolname AS 角色名,
    rolsuper AS 超级用户,
    rolcreaterole AS 可创建角色,
    rolcreatedb AS 可创建数据库,
    rolcanlogin AS 可登录,
    rolreplication AS 复制角色,
    rolconnlimit AS 连接限制,
    rolvaliduntil AS 密码过期时间
FROM pg_roles
ORDER BY rolname;
