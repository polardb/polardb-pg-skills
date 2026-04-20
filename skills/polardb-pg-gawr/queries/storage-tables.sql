-- 表大小排行
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_relation_size
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;

-- 表年龄（事务 ID 年龄）
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_table_age
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;

-- 用户表统计（扫描、读写）
SELECT
    to_timestamp(time) AS ts,
    *
FROM polar_gawr_collection.view_fact_polar_stat_user_tables
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER
ORDER BY time DESC
LIMIT 20;

-- 健康状态：swell_time 和 db_age 趋势
SELECT
    to_timestamp(time - time % 300) AS ts,
    physical_ins_name,
    MAX(swell_time) AS swell_time_sec,
    MAX(db_age) AS db_age,
    MAX(oldest_active_xid_age) AS oldest_xid_age,
    MAX(two_pc_transactions) AS two_pc_txns
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '3 hours')::INTEGER
GROUP BY time - time % 300, physical_ins_name
ORDER BY ts;
