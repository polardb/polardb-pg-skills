-- 关键配置参数
-- 查看重要的 PostgreSQL 配置参数
SELECT
    name AS 参数名,
    setting AS 当前值,
    unit AS 单位,
    short_desc AS 说明
FROM pg_settings
WHERE name IN (
    'max_connections',
    'shared_buffers',
    'work_mem',
    'maintenance_work_mem',
    'effective_cache_size',
    'random_page_cost',
    'effective_io_concurrency',
    'autovacuum',
    'autovacuum_vacuum_scale_factor',
    'autovacuum_analyze_scale_factor',
    'autovacuum_vacuum_cost_limit',
    'statement_timeout',
    'lock_timeout',
    'idle_in_transaction_session_timeout',
    'max_wal_size',
    'min_wal_size',
    'checkpoint_completion_target',
    'wal_buffers',
    'default_statistics_target',
    'max_worker_processes',
    'max_parallel_workers_per_gather',
    'max_parallel_workers'
)
ORDER BY name;
