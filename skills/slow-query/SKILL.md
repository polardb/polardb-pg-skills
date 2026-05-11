---
name: slow-query
version: "1.0.0"
description: PolarDB PG 慢查询诊断与优化技能，基于实际案例提供系统性的慢SQL分析和优化方法
license: MIT
metadata:
  author: community
  date: March 2026
  status: draft
  references:
    - "PostgreSQL 慢SQL优化分享"
    - "Proceedings of ACM SIGMOD International Conference on Management of Data, 1998"
categories:
  - name: slow-query-detection
    title: 慢查询检测
    priority: HIGH
    description: 识别和监控慢查询，包括 pg_stat_statements 和 auto_explain 配置
    queries:
      - detect-slow-queries.sql
      - detect-expensive-queries.sql
      - detect-io-heavy-queries.sql
  - name: execution-plan-analysis
    title: 执行计划分析
    priority: HIGH
    description: EXPLAIN 分析，识别计划问题
    queries:
      - plan-cost-analysis.sql
      - plan-row-estimates.sql
  - name: statistics-analysis
    title: 统计信息分析
    priority: HIGH
    description: 分析统计信息准确性，识别估算偏差
    queries:
      - stats-accuracy.sql
      - stats-stale-tables.sql
      - stats-extended.sql
  - name: join-optimization
    title: Join 优化
    priority: MEDIUM
    description: 识别低效的 join 操作
    queries:
      - join-analysis.sql
      - nestloop-detection.sql
  - name: index-optimization
    title: 索引优化
    priority: MEDIUM
    description: 基于慢查询推荐索引
    queries:
      - index-candidates.sql
      - index-usage-by-query.sql
  - name: configuration-tuning
    title: 配置调优
    priority: LOW
    description: 影响查询性能的参数优化建议
    queries:
      - config-query-tuning.sql
prerequisites:
  - PolarDB PG (PostgreSQL 14 兼容)
  - pg_stat_statements 扩展 (必需)
  - auto_explain 扩展 (已预装)
  - 超级用户权限
---

# PolarDB PG 慢查询诊断与优化

## 概述

慢查询是数据库系统中最常见的性能问题之一。本技能提供系统性的方法来识别、分析和优化慢 SQL，涵盖以下六大类原因：

1. **估计误差大导致的慢 SQL** - 统计信息不准确
2. **误选 nestloop join 导致的慢 SQL** - Join 方式选择不当
3. **缺少必要索引导致的慢 SQL** - 索引设计问题
4. **内存不足导致的慢 SQL** - work_mem 等参数配置
5. **参数化查询导致的慢 SQL** - 参数类型推导问题
6. **缺少优化能力导致的慢 SQL** - 需要手动改写 SQL

## 使用场景

- 诊断生产环境慢查询
- 执行计划分析和优化
- 统计信息准确性检查
- 索引优化建议
- 配置参数调优

## 慢查询监控配置

### 方法一：pg_stat_statements

PolarDB PG 已内置 pg_stat_statements 扩展，创建后即可使用：

```sql
-- 创建扩展 (仅需执行一次)
CREATE EXTENSION IF NOT EXISTS pg_stat_statements;

-- 查询执行时间最长的 SQL
SELECT
    calls,
    ROUND(total_exec_time::numeric, 2) AS total_time_ms,
    ROUND(mean_exec_time::numeric, 2) AS avg_time_ms,
    query
FROM pg_stat_statements
ORDER BY total_exec_time DESC
LIMIT 20;
```

### 方法二：auto_explain (推荐)

PolarDB PG 已预装 auto_explain 模块，需通过 **PolarDB 控制台** 配置参数：

**配置步骤**：
1. 登录 PolarDB 控制台
2. 进入集群详情页 → 参数配置
3. 搜索并修改以下参数：

| 参数名 | 建议值 | 说明 |
|--------|--------|------|
| `auto_explain.log_min_duration` | `1000` | 记录执行时间超过 1 秒的查询 (单位: ms) |
| `auto_explain.log_analyze` | `true` | 记录实际执行统计 |
| `auto_explain.log_buffers` | `true` | 记录缓冲区使用情况 |
| `auto_explain.log_timing` | `true` | 记录各节点执行时间 |
| `auto_explain.log_nested_statements` | `true` | 记录嵌套语句 (存储过程/函数内) |

4. 点击「提交修改」，等待参数生效

**查看当前配置**：
```sql
SHOW auto_explain.log_min_duration;
```

**注意**: auto_explain 有额外开销，排查完成后建议在控制台将 `auto_explain.log_min_duration` 设为 `-1` 禁用。

## EXPLAIN 命令详解

### 基本用法

```sql
-- 查看执行计划
EXPLAIN SELECT * FROM table_name WHERE condition;

-- 实际执行并显示统计 (推荐)
EXPLAIN (ANALYZE, BUFFERS, TIMING) SELECT * FROM table_name WHERE condition;

-- 完整输出格式
EXPLAIN (ANALYZE, BUFFERS, TIMING, FORMAT JSON) SELECT * FROM table_name WHERE condition;
```

### 关键指标解读

| 指标 | 说明 | 关注点 |
|------|------|--------|
| `cost` | 估计代价 (startup..total) | 相对值，用于比较 |
| `rows` | 估计返回行数 | 与 actual rows 对比 |
| `actual time` | 实际执行时间 (ms) | 找出耗时节点 |
| `actual rows` | 实际返回行数 | 估计偏差说明统计问题 |
| `loops` | 循环次数 | 高 loops 说明 nestloop 问题 |
| `Buffers: shared hit/read` | 缓冲区命中/读取 | read 高说明缓存不足 |
| `Sort Method` | 排序方式 | disk 说明 work_mem 不足 |

### 在线执行计划分析工具

- **explain.dalibo.com** - PostgreSQL EXPLAIN 可视化
- **explain.depesz.com** - 执行计划分析

## 优化策略详解

### 策略一：更新统计信息

当 `rows` 估计与 `actual rows` 相差较大时：

```sql
-- 手动收集统计信息
ANALYZE table_name;

-- 针对特定列提高采样精度
ALTER TABLE table_name ALTER COLUMN column_name SET STATISTICS 1000;
ANALYZE table_name;

-- 临时提高全局采样精度
SET default_statistics_target = 1000;
ANALYZE table_name;
```

### 策略二：创建扩展统计信息

当多列之间存在关联时 (PG 10+)：

```sql
-- 创建函数依赖统计 (列之间有关联)
CREATE STATISTICS stat_name (dependencies) ON col1, col2 FROM table_name;

-- 创建多列 distinct 统计
CREATE STATISTICS stat_name (ndistinct) ON col1, col2 FROM table_name;

-- 创建表达式统计 (PG 14+)
CREATE STATISTICS stat_name ON (expression) FROM table_name;

-- 收集统计信息
ANALYZE table_name;

-- 查看扩展统计信息
SELECT * FROM pg_statistic_ext;
```

### 策略三：索引优化

```sql
-- 创建组合索引 (按选择性从高到低排列)
CREATE INDEX idx_name ON table_name (high_selectivity_col, low_selectivity_col);

-- 创建覆盖索引 (避免回表)
CREATE INDEX idx_name ON table_name (filter_col) INCLUDE (select_col1, select_col2);

-- 创建表达式索引
CREATE INDEX idx_name ON table_name (expression);
```

### 策略四：Join 优化

强制指定 Join 方式 (仅用于测试)：

```sql
-- 禁用 nestloop 测试
SET enable_nestloop = off;
EXPLAIN ANALYZE SELECT ...;

-- 禁用 hashjoin 测试
SET enable_hashjoin = off;
EXPLAIN ANALYZE SELECT ...;

-- 恢复默认
RESET enable_nestloop;
RESET enable_hashjoin;
```

### 策略五：SQL 改写

OR 条件改写为 UNION ALL：

```sql
-- 原始 SQL (可能无法使用索引)
SELECT * FROM t1 JOIN t2 ON t1.id = t2.id WHERE t1.a = 1 OR t2.b = 2;

-- 改写后 (可利用各表索引)
SELECT * FROM t1 JOIN t2 ON t1.id = t2.id WHERE t1.a = 1
UNION ALL
SELECT * FROM t1 JOIN t2 ON t1.id = t2.id WHERE t2.b = 2 AND NOT (t1.a = 1);
```

## 常见问题速查

| 问题现象 | 可能原因 | 解决方案 |
|----------|----------|----------|
| rows 估计偏小很多 | 统计信息不准 | ANALYZE + 提高采样率 |
| 多列条件估计不准 | 列间有关联 | 创建 dependencies 扩展统计 |
| nestloop loops 过高 | 外表行数估计偏小 | 检查统计信息，考虑改 hashjoin |
| 全表扫描 | 缺少索引或统计不准 | 创建索引，更新统计 |
| Sort 使用 disk | work_mem 不足 | 增大 work_mem |
| 大量 buffer read | shared_buffers 不足 | 增大缓冲区或检查查询 |
| 参数化查询慢 | 参数类型不匹配 | 使用 auto_explain 获取实际计划 |

## 阈值参考

| 指标 | 正常 | 警告 | 危险 | 说明 |
|------|------|------|------|------|
| 执行时间 | < 100ms | 100ms-1s | > 1s | 单次查询 |
| 估计偏差 | < 2x | 2x-10x | > 10x | rows/actual rows |
| nestloop loops | < 100 | 100-1000 | > 1000 | 可能需要改写 |
| 扫描行数/返回行数 | < 10x | 10x-100x | > 100x | 过滤效率 |
| work_mem 溢出 | 无 | 偶发 | 频繁 | Sort/Hash 溢出到磁盘 |

## 诊断工作流程

慢查询诊断遵循以下标准流程：

```
┌─────────────────────────────────────────────────────────────────┐
│                     慢查询诊断工作流程                            │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  Step 1: 慢查询检测 (slow-query-detection)                       │
│  ├─ 查询 pg_stat_statements 获取慢 SQL 列表                      │
│  ├─ 按平均执行时间、总执行时间排序                                  │
│  └─ 输出: 慢 SQL 概览表                                          │
│              ↓                                                  │
│  Step 2: 执行计划分析 (execution-plan-analysis)                  │
│  ├─ 对每个慢 SQL 执行 EXPLAIN ANALYZE                            │
│  ├─ 收集 actual time、buffers、rows 等实际数据                   │
│  └─ 输出: 执行计划详情                                           │
│              ↓                                                  │
│  Step 3: 慢 SQL 根因分析                                         │
│  ├─ 基于执行计划定位瓶颈节点                                       │
│  ├─ 分析 Seq Scan / Nested Loop / 高 IO 等问题                   │
│  ├─ 检查估计值与实际值偏差                                         │
│  └─ 输出: 问题根因 + 优化建议 + 可执行 SQL                         │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## 诊断规则

### 输出格式要求

诊断结果必须按以下顺序输出：

1. **慢 SQL 概览** - 列出 Top N 慢查询，包含调用次数、平均耗时、总耗时
2. **执行计划分析** - 每个慢 SQL 的 EXPLAIN ANALYZE 结果解读
3. **优化建议** - 具体可执行的优化方案

### 分析方法

- **基于 EXPLAIN ANALYZE 的实际执行数据分析**，而非 SQL 文本模式匹配
- 必须获取真实的执行计划，包含 `actual time`、`actual rows`、`buffers` 等信息
- 对比估计值 (rows) 与实际值 (actual rows) 识别统计信息问题

### 优化建议原则

| 原则 | 说明 |
|------|------|
| **瓶颈定位** | 根据执行计划中的实际耗时节点定位瓶颈 |
| **问题识别** | 重点关注 Seq Scan、Nested Loop、高 IO 耗时、估计值与实际值误差 |
| **可执行性** | 提供的建议要转化为可直接执行的 SQL 语句 |
| **最小影响** | 用最小化线上业务影响的方式给出建议 |
| **可量化** | 提供可量化的优化预期（如：预计提升 xx%） |
| **风险提示** | 说明执行风险，建议在流量低峰期操作 |

### 索引创建规则

**必须使用 CONCURRENTLY 选项创建索引**，避免锁表影响线上业务：

```sql
-- 正确: 使用 CONCURRENTLY 选项
CREATE INDEX CONCURRENTLY idx_orders_status ON orders(status);
CREATE INDEX CONCURRENTLY idx_orders_date ON orders(order_date);
CREATE INDEX CONCURRENTLY idx_orders_date_trunc ON orders(date_trunc('day', order_date));

-- 错误: 不带 CONCURRENTLY 会锁表
CREATE INDEX idx_orders_status ON orders(status);  -- 禁止
```

**CONCURRENTLY 注意事项**：
- 不会锁表，但构建时间较长
- 不能在事务块内执行
- 如果失败会留下 INVALID 索引，需要 `DROP INDEX CONCURRENTLY` 后重建
- 建议在流量低峰期执行

### 特殊情况处理

| 场景 | 处理方式 |
|------|----------|
| **EXPLAIN ANALYZE 超时** | 当执行时间超过该 SQL 历史最大执行时间仍无返回时，改用 `EXPLAIN` (不带 ANALYZE)，根据估计值推测问题并给出建议 |
| **EXPLAIN ANALYZE 无结果** | 输出时明确说明「此 SQL 的 EXPLAIN ANALYZE 未能在预期时间内返回结果」|
| **慢日志记录超过 30s 的 SQL** | 分析前先输出提示：「此 SQL 执行时间较长，分析过程可能需要等待，请耐心等候」|

### PostgreSQL 特性利用

充分利用 PostgreSQL 执行计划特有信息：

```
┌────────────────────┬─────────────────────────────────────────────┐
│ 指标               │ 诊断用途                                      │
├────────────────────┼─────────────────────────────────────────────┤
│ actual time        │ 定位真实耗时节点，识别性能瓶颈                   │
│ actual rows        │ 与 rows 对比，识别统计信息偏差                  │
│ buffers shared hit │ 评估缓存命中率                                 │
│ buffers shared read│ 识别 IO 瓶颈                                  │
│ loops              │ 识别 Nested Loop 问题                         │
│ Sort Method        │ 识别 work_mem 不足 (external sort)            │
│ Hash Batches       │ 识别 Hash Join 内存溢出                        │
│ Rows Removed by Filter │ 评估过滤效率                              │
└────────────────────┴─────────────────────────────────────────────┘
```

### 优化建议输出模板

每个优化建议必须包含以下内容：

```markdown
#### 问题 N: [问题标题]

**问题描述**: 
[基于执行计划的具体问题描述]

**根因分析**:
[导致该问题的根本原因]

**优化建议**:
```sql
-- 建议执行的 SQL
[可直接执行的优化 SQL]
```

**预期效果**:
- 执行时间预计从 xxx ms 降至 xxx ms
- 扫描行数预计减少 xx%

**风险提示**:
- 风险等级: [低/中/高]
- [具体风险说明]
- 建议在流量低峰期执行

**验证方法**:
```sql
-- 优化后验证 SQL
[验证执行计划的 SQL]
```
```

## 执行顺序

按工作流程执行: **slow-query-detection → execution-plan-analysis → 根因分析**

每个类别下的查询文件可独立执行，查询文件位于 `queries/` 目录。

## 参考资料

- https://www.postgresql.org/docs/current/performance-tips.html
- https://www.postgresql.org/docs/current/using-explain.html
- https://www.postgresql.org/docs/current/auto-explain.html
- https://www.postgresql.org/docs/current/planner-stats-details.html
- https://wiki.postgresql.org/wiki/Performance_Optimization
