-- 参数配置快照
SELECT
    to_timestamp(time) AS ts,
    name,
    setting
FROM polar_gawr_collection.view_fact_polar_settings
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC, name;

-- 数据库编码
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_db_encoding
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 5;
