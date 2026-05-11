---
name: routine-check
version: "1.0.0"
description: PostgreSQL/PolarDB 数据库日常巡检技能，用于执行健康检查、诊断问题、生成巡检报告
license: MIT
metadata:
  author: community
  date: March 2026
categories:
  - name: db-overview
    title: 数据库概览
    priority: HIGH
    description: 基本信息、版本、大小、事务ID年龄
    queries:
      - db-basic.sql
      - db-xid-age.sql
  - name: table-statistics
    title: 表统计
    priority: HIGH
    description: 表大小、死元组、Vacuum 状态
    queries:
      - table-stats.sql
      - table-xid-age.sql
  - name: index-analysis
    title: 索引分析
    priority: HIGH
    description: 索引使用、未使用索引、缺失索引
    queries:
      - index-usage.sql
      - index-unused.sql
      - index-missing-fk.sql
      - index-redundant.sql
  - name: conn-status
    title: 连接状态
    priority: MEDIUM
    description: 活跃连接、空闲事务、长查询
    queries:
      - conn-summary.sql
      - conn-idle-transaction.sql
      - conn-long-query.sql
      - conn-waiting.sql
  - name: repl-status
    title: 复制状态
    priority: MEDIUM
    description: 复制槽、复制延迟、WAL 状态
    queries:
      - repl-slots.sql
      - repl-status.sql
      - repl-inactive-slots.sql
  - name: config-review
    title: 配置审查
    priority: MEDIUM
    description: 关键参数、调优建议
    queries:
      - config-key-params.sql
      - config-non-default.sql
  - name: storage-health
    title: 存储健康
    priority: LOW
    description: 表空间使用、膨胀检测
    queries:
      - storage-tablespace.sql
      - storage-large-tables.sql
      - storage-bloat.sql
  - name: security-audit
    title: 安全审计
    priority: LOW
    description: 权限、角色审查
    queries:
      - security-roles.sql
      - security-permissions.sql
prerequisites:
  - PostgreSQL 12+ / PolarDB
  - 访问系统目录权限 (pg_stat_*, pg_catalog.*)
  - 超级用户或监控角色以获取完整结果
---

# PostgreSQL 日常巡检

## 使用场景

- 执行日常数据库健康检查
- 诊断性能问题
- 审查数据库配置
- 检查复制状态
- 审计索引使用情况
- 监控连接模式

## 执行顺序

按优先级执行: **HIGH → MEDIUM → LOW**

每个类别下的查询文件可独立执行，查询文件位于 `queries/` 目录。

## 阈值参考

| 指标 | 正常 | 警告 | 危险 |
|------|------|------|------|
| 事务ID年龄 | < 1.5亿 | 1.5-20亿 | > 20亿 |
| 死元组比例 | < 10% | 10-30% | > 30% |
| 索引扫描次数 | > 1000 | 100-1000 | 0 (未使用) |
| 空闲事务时长 | < 60秒 | 60-300秒 | > 300秒 |
| 复制延迟 | < 1MB | 1-100MB | > 100MB |

## 参考资料

- https://www.postgresql.org/docs/current/monitoring.html
- https://wiki.postgresql.org/wiki/Disk_Usage
- https://wiki.postgresql.org/wiki/Lock_Monitoring
