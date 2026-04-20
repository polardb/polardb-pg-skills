-- 数据库级统计（来自 pg_stat_database）
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_pg_stat_database
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 10;

-- 通过 dbmetrics 看元组操作趋势
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    ROUND(AVG(tup_returned_delta)::NUMERIC, 0) AS tup_returned,
    ROUND(AVG(tup_fetched_delta)::NUMERIC, 0) AS tup_fetched,
    ROUND(AVG(tup_inserted_delta)::NUMERIC, 0) AS tup_inserted,
    ROUND(AVG(tup_updated_delta)::NUMERIC, 0) AS tup_updated,
    ROUND(AVG(tup_deleted_delta)::NUMERIC, 0) AS tup_deleted,
    ROUND(AVG(deadlocks_delta)::NUMERIC, 0) AS deadlocks,
    ROUND(AVG(temp_files_delta)::NUMERIC, 0) AS temp_files,
    ROUND(AVG(conflicts_delta)::NUMERIC, 0) AS conflicts
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name
ORDER BY ts;
