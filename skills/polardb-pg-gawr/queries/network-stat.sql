-- TCP 网络统计
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_network
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
ORDER BY time DESC
LIMIT 20;
