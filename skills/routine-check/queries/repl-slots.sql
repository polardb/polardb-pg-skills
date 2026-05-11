-- 复制槽状态
-- 查看所有复制槽的状态
SELECT
    slot_name AS 槽名,
    slot_type AS 类型,
    active AS 是否活跃,
    restart_lsn AS 重启LSN,
    confirmed_flush_lsn AS 确认刷新LSN
FROM pg_replication_slots;
