-- IO 延迟分布
-- 关注 num_morethan100ms，占比超过 5% 说明 IO 性能有问题
SELECT
    to_timestamp(time - time % 300) AS ts,
    iotype,
    SUM(num_lessthan200us) AS lt_200us,
    SUM(num_lessthan1ms) AS lt_1ms,
    SUM(num_lessthan10ms) AS lt_10ms,
    SUM(num_lessthan100ms) AS lt_100ms,
    SUM(num_morethan100ms) AS gt_100ms,
    ROUND(
        (SUM(num_morethan100ms)::NUMERIC /
        NULLIF(SUM(num_lessthan200us + num_lessthan1ms + num_lessthan10ms + num_lessthan100ms + num_morethan100ms), 0)
        * 100)::NUMERIC, 2
    ) AS slow_io_pct
FROM polar_gawr_collection.view_fact_polar_stat_io_latency
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, iotype
ORDER BY ts, slow_io_pct DESC;

-- 批量 IO 延迟
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_bulk_io_latency
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;
