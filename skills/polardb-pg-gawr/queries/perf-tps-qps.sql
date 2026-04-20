-- TPS 和 QPS 趋势
-- TPS = commits + rollbacks 增量
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    ROUND(AVG(commits_delta + rollbacks_delta)::NUMERIC, 2) AS tps,
    ROUND(AVG(commits_delta)::NUMERIC, 2)    AS commits,
    ROUND(AVG(rollbacks_delta)::NUMERIC, 2)  AS rollbacks,
    ROUND(AVG(qps_delta)::NUMERIC, 2)        AS qps
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;
