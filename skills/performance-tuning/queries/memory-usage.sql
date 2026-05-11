-- 内存相关配置检查
-- 分析当前内存配置是否合理
SELECT
    name AS 参数名,
    setting AS 当前值,
    unit AS 单位,
    short_desc AS 说明
FROM pg_settings
WHERE name IN (
    'shared_buffers',
    'work_mem',
    'maintenance_work_mem',
    'huge_pages',
    'effective_cache_size',
    'wal_buffers'
)
ORDER BY name;
