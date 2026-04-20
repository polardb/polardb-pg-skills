-- 数据发现：确认 GAWR 状态和可用数据
-- 第一步：确认 GAWR 本地存储是否启用
SELECT polar_gawr_collection.show_store_in_localdb() AS gawr_local_storage_enabled;

-- 第二步：确认 GAWR 采集是否启用
SELECT polar_gawr_collection.is_enabled() AS gawr_enabled;

-- 第三步：查看数据时间范围（fact_dbmetrics 是最核心的表）
SELECT
    COUNT(*) AS total_rows,
    to_timestamp(MIN(time)) AS earliest,
    to_timestamp(MAX(time)) AS latest
FROM polar_gawr_collection.fact_dbmetrics;

-- 第四步：列出所有 fact 底表
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'polar_gawr_collection'
  AND table_name LIKE 'fact_%'
ORDER BY table_name;

-- 第五步：列出所有 view（含 view_fact 和 view_agg）
SELECT table_name
FROM information_schema.tables
WHERE table_schema = 'polar_gawr_collection'
  AND table_name LIKE 'view_%'
ORDER BY table_name;

-- 第六步：查看采集配置（哪些指标正在被采集、采集周期）
SELECT * FROM polar_gawr_collection.list_collections();

-- 第七步：查看数据模型的聚合和保留配置
SELECT * FROM polar_gawr_collection.meta_data_model_config
ORDER BY name;

-- 第八步：查看逻辑实例名
SELECT * FROM polar_gawr_collection.list_logic_ins_name();

-- 第九步：快速浏览某张 view 的字段（替换 view 名即可）
SELECT column_name, data_type
FROM information_schema.columns
WHERE table_schema = 'polar_gawr_collection'
  AND table_name = 'view_fact_dbmetrics'
ORDER BY ordinal_position;
