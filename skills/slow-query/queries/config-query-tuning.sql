-- 查询性能相关配置参数 (PolarDB PG 版)
-- 检查影响查询性能的关键参数设置
-- 提供调优建议和实例规格升级参考

SELECT
    name AS 参数名,
    setting AS 当前值,
    unit AS 单位,
    boot_val AS 默认值,
    CASE
        WHEN setting != boot_val THEN '已修改'
        ELSE '默认'
    END AS 修改状态,
    CASE name
        -- 内存相关 (PolarDB PG 默认 shared_buffers 为内存的 75%)
        WHEN 'shared_buffers' THEN
            CASE
                WHEN pg_size_bytes(setting || COALESCE(unit, '')) < 1073741824 THEN '偏小-建议升级实例规格'
                ELSE '正常 (PolarDB默认75%)'
            END
        WHEN 'work_mem' THEN
            CASE
                WHEN setting::int < 4096 THEN '偏小-可能导致磁盘排序'
                WHEN setting::int > 65536 THEN '较大-注意并发影响'
                ELSE '正常'
            END
        WHEN 'effective_cache_size' THEN
            CASE
                WHEN pg_size_bytes(setting || COALESCE(unit, '')) < 2147483648 THEN '偏小-建议升级实例规格'
                ELSE '正常'
            END
        WHEN 'maintenance_work_mem' THEN
            CASE
                WHEN setting::int < 65536 THEN '偏小-影响VACUUM/CREATE INDEX'
                ELSE '正常'
            END
        -- 代价相关
        WHEN 'random_page_cost' THEN
            CASE
                WHEN setting::float > 2 THEN 'HDD设置-PolarDB SSD建议1.1-1.5'
                ELSE '正常(SSD设置)'
            END
        WHEN 'effective_io_concurrency' THEN
            CASE
                WHEN setting::int < 10 THEN '偏小-PolarDB建议100-200'
                ELSE '正常'
            END
        -- 统计相关
        WHEN 'default_statistics_target' THEN
            CASE
                WHEN setting::int < 100 THEN '偏小-可能导致估计不准'
                WHEN setting::int > 500 THEN '较大-ANALYZE开销增加'
                ELSE '正常'
            END
        ELSE '检查文档'
    END AS 建议
FROM pg_settings
WHERE name IN (
    -- 内存参数
    'shared_buffers', 'work_mem', 'effective_cache_size',
    'maintenance_work_mem', 'temp_buffers',
    -- 代价参数
    'random_page_cost', 'seq_page_cost', 'effective_io_concurrency',
    'cpu_tuple_cost', 'cpu_index_tuple_cost', 'cpu_operator_cost',
    -- 统计参数
    'default_statistics_target',
    -- 并行参数
    'max_parallel_workers_per_gather', 'parallel_tuple_cost',
    'parallel_setup_cost', 'min_parallel_table_scan_size',
    -- 其他
    'enable_partitionwise_join', 'enable_partitionwise_aggregate',
    'jit', 'jit_above_cost'
)
ORDER BY
    CASE
        WHEN name IN ('shared_buffers', 'work_mem', 'effective_cache_size') THEN 1
        WHEN name IN ('random_page_cost', 'effective_io_concurrency') THEN 2
        WHEN name = 'default_statistics_target' THEN 3
        ELSE 4
    END;

-- PolarDB PG 参数调优建议:
-- 1. shared_buffers: PolarDB 默认为内存的 75%，如果内存不足建议升级实例规格
-- 2. effective_cache_size: 如果偏小，建议升级实例规格
-- 3. work_mem: 4-64MB，根据并发连接数调整，频繁磁盘排序可适当调大
-- 4. random_page_cost: PolarDB 使用 SSD，建议设为 1.1-1.5
-- 5. effective_io_concurrency: PolarDB SSD 建议设为 200
-- 6. default_statistics_target: 大表可适当提高到 500-1000
--
-- 实例规格升级建议:
-- - 如果 shared_buffers 或 effective_cache_size 偏小，考虑升级到更高内存规格
-- - 如果频繁出现 work_mem 溢出(磁盘排序)，考虑升级规格或调整参数
-- - 如果 CPU 利用率持续过高，考虑升级到更高 CPU 规格
-- - 如果并行查询不生效，检查 max_parallel_workers_per_gather 和实例 CPU 核数
