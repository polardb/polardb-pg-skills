-- 缓存命中率趋势
-- 命中率 = blks_hit / (blks_hit + blks_read)，低于 95% 需关注
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    ROUND(AVG(blks_hit_delta / NULLIF(blks_hit_delta + blks_read_delta, 0) * 100)::NUMERIC, 2) AS cache_hit_pct,
    ROUND(AVG(blks_hit_delta)::NUMERIC, 0)  AS blks_hit,
    ROUND(AVG(blks_read_delta)::NUMERIC, 0) AS blks_read
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;
