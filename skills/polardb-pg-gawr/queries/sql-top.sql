-- Top SQL 分析
-- 数据源：1) GAWR 采集的历史快照（view_fact_polar_stat_top_sql）
--        2) pg_stat_statements 实时视图（累计统计）

-- === GAWR 历史 Top SQL 快照（每 10 分钟采样一次） ===
-- 字段随数据动态创建，使用 SELECT * 确保兼容
SELECT *
FROM polar_gawr_collection.view_fact_polar_stat_top_sql
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 50;

-- === pg_stat_statements 实时 Top SQL === 
-- 先检查 pg_stat_statements 是否可用
SELECT COUNT(*) > 0 AS pg_stat_statements_available
FROM pg_extension WHERE extname = 'pg_stat_statements';

-- Top 20 SQL：按累计执行时间排序
-- 适用于 PG14+（total_exec_time），低版本请将 total_exec_time 替换为 total_time
SELECT
    queryid,
    SUBSTRING(query, 1, 200) AS query_preview,
    calls,
    ROUND(total_exec_time::NUMERIC, 2) AS total_exec_time_ms,
    ROUND((total_exec_time / NULLIF(calls, 0))::NUMERIC, 2) AS avg_exec_time_ms,
    ROUND(total_plan_time::NUMERIC, 2) AS total_plan_time_ms,
    rows,
    shared_blks_hit,
    shared_blks_read,
    ROUND((shared_blks_hit::NUMERIC / NULLIF(shared_blks_hit + shared_blks_read, 0) * 100), 2) AS cache_hit_pct
FROM pg_stat_statements
WHERE dbid = (SELECT oid FROM pg_database WHERE datname = current_database())
ORDER BY total_exec_time DESC
LIMIT 20;

-- Top 20 SQL：按调用次数排序
SELECT
    queryid,
    SUBSTRING(query, 1, 200) AS query_preview,
    calls,
    ROUND(total_exec_time::NUMERIC, 2) AS total_exec_time_ms,
    ROUND((total_exec_time / NULLIF(calls, 0))::NUMERIC, 2) AS avg_exec_time_ms,
    rows
FROM pg_stat_statements
WHERE dbid = (SELECT oid FROM pg_database WHERE datname = current_database())
ORDER BY calls DESC
LIMIT 20;

-- Top 20 SQL：按平均执行时间排序（找慢查询）
SELECT
    queryid,
    SUBSTRING(query, 1, 200) AS query_preview,
    calls,
    ROUND((total_exec_time / NULLIF(calls, 0))::NUMERIC, 2) AS avg_exec_time_ms,
    ROUND(total_exec_time::NUMERIC, 2) AS total_exec_time_ms,
    rows
FROM pg_stat_statements
WHERE dbid = (SELECT oid FROM pg_database WHERE datname = current_database())
  AND calls > 0
ORDER BY avg_exec_time_ms DESC
LIMIT 20;
