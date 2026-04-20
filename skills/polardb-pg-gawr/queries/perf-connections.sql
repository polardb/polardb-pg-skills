-- 连接数趋势
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    role,
    ROUND(AVG(connections)::NUMERIC, 0)           AS total_conns,
    ROUND(AVG(active_connections)::NUMERIC, 0)    AS active_conns,
    ROUND(AVG(idle_connections)::NUMERIC, 0)      AS idle_conns,
    ROUND(AVG(idle_transactions)::NUMERIC, 0)     AS idle_in_txn,
    MAX(longest_sql_running_time)                  AS longest_sql_ms,
    MAX(longest_tx_running_time)                   AS longest_txn_ms
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name, role
ORDER BY ts;

-- 连接 Top 用户
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_active_conn_top_user
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;
