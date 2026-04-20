-- 已安装扩展
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_extensions
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 30;

-- Global Plan Cache 统计
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_gpc
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 10;

-- 特性开关状态
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_feature_utils
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 10;

-- 维护窗口记录
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_advisor_window
WHERE time > EXTRACT(EPOCH FROM now() - interval '24 hours')::INTEGER
ORDER BY time DESC
LIMIT 20;

-- 物化视图统计
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_materialized_view
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 10;
