# PolarDB GAWR 本地实例数据分析技能

基于 PolarDB GAWR（Global AWR）系统的历史监控数据，分析 PolarDB 实例的性能与健康状态。

## 适用场景

- 历史趋势分析（CPU / 内存 / IO / 连接数等随时间变化）
- 性能问题定位（等待事件、慢 SQL、锁等待）
- 复制延迟监控（PolarDB 特有的 startup / 并行回放延迟）
- 容量规划（存储增长、表膨胀、事务 ID 年龄）
- 异常事件回溯（ERROR / FATAL / PANIC）

## 前置条件

- PolarDB PostgreSQL 版，PG14 及以上
- GAWR 功能已启用（`polar_gawr_collection.show_store_in_localdb()` 返回 true）
- 连接到 **postgres** 数据库（GAWR 数据在 `polar_gawr_collection` schema 下）

## 文件结构

```
polardb-gawr/
├── _meta.json       # 技能元数据
├── SKILL.md         # 技能文档（核心）
├── README.md        # 本文件
└── queries/         # 按分析主题组织的 SQL 查询模板
    ├── discover.sql
    ├── overview.sql
    ├── resource-cpu.sql
    ├── ...
    └── polar-internal.sql
```

## 使用方式

此技能供 PolarClaw agent 自动加载使用。agent 会根据 SKILL.md 中的说明和 queries/ 目录下的 SQL 模板，对 PolarDB 实例进行分析诊断。
