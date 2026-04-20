-- 实例概览：角色、版本、规格、节点信息
-- 查看最近的实例基本信息（每个物理节点一条）
SELECT
    to_timestamp(MAX(time)) AS latest_time,
    logical_ins_name,
    physical_ins_name,
    MAX(role) AS role,
    MAX(version) AS version,
    MAX(host) AS host,
    MAX(cpu_cores) AS cpu_cores,
    MAX(mem_total) AS mem_total_mb
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '30 minutes')::INTEGER
GROUP BY logical_ins_name, physical_ins_name
ORDER BY role, physical_ins_name;

-- 查看实例维度信息
SELECT * FROM polar_gawr_collection.dim_ins_info
WHERE logical_ins_name != 'others';

-- 最近数据的时间范围
SELECT
    to_timestamp(MIN(time)) AS earliest,
    to_timestamp(MAX(time)) AS latest,
    COUNT(*) AS total_rows
FROM polar_gawr_collection.view_fact_dbmetrics;
