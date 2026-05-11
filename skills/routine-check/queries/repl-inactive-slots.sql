-- 未激活的复制槽
-- 检查可能导致 WAL 堆积的未激活复制槽
SELECT
    slot_name AS 槽名,
    slot_type AS 类型,
    active AS 是否活跃,
    pg_size_pretty(pg_wal_lsn_diff(pg_current_wal_lsn(), restart_lsn)) AS WAL堆积大小
FROM pg_replication_slots
WHERE active = false;
