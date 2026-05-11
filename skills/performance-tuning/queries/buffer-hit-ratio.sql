-- 缓冲区命中率
-- 检查整体缓存效率
-- 阈值: > 99% 正常, 95-99% 警告, < 95% 危险
SELECT
    ROUND(
        100.0 * SUM(blks_hit) / (SUM(blks_hit) + SUM(blks_read)),
        2
    ) AS 缓存命中率,
    SUM(blks_hit) AS 缓存命中次数,
    SUM(blks_read) AS 磁盘读取次数
FROM pg_stat_database;
