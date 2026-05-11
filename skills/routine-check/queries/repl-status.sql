-- 复制连接状态 (主库执行)
-- 查看复制延迟情况
-- 延迟阈值: < 1MB 正常, 1-100MB 警告, > 100MB 危险
SELECT
    client_addr AS 客户端地址,
    state AS 状态,
    sent_lsn AS 已发送LSN,
    write_lsn AS 已写入LSN,
    flush_lsn AS 已刷新LSN,
    replay_lsn AS 已回放LSN,
    pg_wal_lsn_diff(sent_lsn, replay_lsn) AS 延迟字节数
FROM pg_stat_replication;
