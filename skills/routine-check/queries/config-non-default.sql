-- 非默认配置
-- 查看所有被修改过的配置参数
SELECT
    name AS 参数名,
    setting AS 当前值,
    source AS 来源,
    sourcefile AS 配置文件
FROM pg_settings
WHERE source != 'default'
ORDER BY name;
