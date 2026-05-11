---
name: performance-tuning
version: "1.0.0"
description: PostgreSQL/PolarDB 性能调优技能，包含 SQL 优化、索引建议、配置调优等
license: MIT
metadata:
  author: community
  date: March 2026
  status: draft
categories:
  - name: query-analysis
    title: 查询分析
    priority: HIGH
    description: 慢查询识别、执行计划分析
    queries:
      - query-slow.sql
      - query-stats.sql
  - name: index-optimization
    title: 索引优化
    priority: HIGH
    description: 索引建议、索引效率分析
    queries:
      - index-suggestions.sql
      - index-efficiency.sql
  - name: buffer-cache
    title: 缓存分析
    priority: MEDIUM
    description: 缓冲区命中率、缓存效率
    queries:
      - buffer-hit-ratio.sql
      - cache-usage.sql
  - name: lock-analysis
    title: 锁分析
    priority: MEDIUM
    description: 锁等待、死锁检测
    queries:
      - lock-waiting.sql
      - lock-blocking.sql
  - name: memory-tuning
    title: 内存调优
    priority: LOW
    description: 内存使用分析、参数建议
    queries:
      - memory-usage.sql
prerequisites:
  - PostgreSQL 12+ / PolarDB
  - pg_stat_statements 扩展 (推荐)
  - 超级用户权限
---

# PostgreSQL 性能调优

## 使用场景

- 识别和优化慢查询
- 索引设计和优化
- 缓存和内存调优
- 锁问题诊断

## 执行顺序

按优先级执行: **HIGH → MEDIUM → LOW**

## 前置准备

推荐启用 `pg_stat_statements` 扩展:

```sql
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;
```

## 阈值参考

| 指标 | 正常 | 警告 | 危险 |
|------|------|------|------|
| 缓存命中率 | > 99% | 95-99% | < 95% |
| 慢查询阈值 | < 100ms | 100ms-1s | > 1s |
| 锁等待时间 | < 100ms | 100ms-1s | > 1s |

## 参考资料

- https://www.postgresql.org/docs/current/performance-tips.html
- https://wiki.postgresql.org/wiki/Performance_Optimization
