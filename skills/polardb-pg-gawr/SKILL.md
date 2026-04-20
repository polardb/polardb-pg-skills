---
name: polardb-pg-gawr
version: "1.0.0"
description: PolarDB GAWR 本地实例数据分析技能，基于 polar_gawr_collection schema 中的历史监控数据，分析 PolarDB 实例的性能与健康状态
license: MIT
metadata:
  author: community
  date: April 2026
categories:
  - name: discover
    title: 数据发现
    priority: HIGH
    description: 探索 GAWR 可用的表、视图、采集配置、数据时间范围
    queries:
      - discover.sql
  - name: overview
    title: 实例概览
    priority: HIGH
    description: 实例角色、版本、规格、节点列表
    queries:
      - overview.sql
  - name: resource
    title: 资源使用
    priority: HIGH
    description: CPU、内存、IO 吞吐、文件系统空间
    queries:
      - resource-cpu.sql
      - resource-memory.sql
      - resource-io.sql
      - resource-fs.sql
  - name: db-perf
    title: 数据库性能
    priority: HIGH
    description: TPS/QPS、连接数、缓存命中率、AAS 等待事件
    queries:
      - perf-tps-qps.sql
      - perf-connections.sql
      - perf-cache-hit.sql
      - perf-aas.sql
  - name: replication
    title: 复制与延迟
    priority: HIGH
    description: PolarDB RO/Standby 复制延迟、复制槽状态
    queries:
      - repl-delay.sql
      - repl-slots.sql
  - name: topsql
    title: SQL 分析
    priority: HIGH
    description: Top SQL（按执行时间/调用次数）、数据库级统计
    queries:
      - sql-top.sql
      - sql-database-stat.sql
  - name: storage
    title: 存储空间
    priority: MEDIUM
    description: WAL/Base/CSNLog 大小趋势、表大小、表年龄
    queries:
      - storage-space.sql
      - storage-tables.sql
  - name: memory-detail
    title: 内存分析
    priority: MEDIUM
    description: 按进程类型内存分布、大内存上下文、共享内存
    queries:
      - mem-process.sql
      - mem-context.sql
  - name: io-latency
    title: IO 延迟
    priority: MEDIUM
    description: IO 延迟分布统计
    queries:
      - io-latency.sql
  - name: events
    title: 异常事件
    priority: MEDIUM
    description: 数据库 ERROR/FATAL/OOM/Core dump 等事件
    queries:
      - event-log.sql
  - name: polar-internal
    title: PolarDB 内部指标
    priority: MEDIUM
    description: Checkpoint/WAL 延迟、LogIndex、复制延迟汇总
    queries:
      - polar-internal.sql
  - name: config
    title: 参数配置
    priority: MEDIUM
    description: 数据库参数快照、编码
    queries:
      - config-settings.sql
  - name: features
    title: 特性与扩展
    priority: LOW
    description: 已安装扩展、GPC、特性开关、维护窗口
    queries:
      - feature-status.sql
  - name: network
    title: 网络状态
    priority: LOW
    description: TCP 网络统计
    queries:
      - network-stat.sql
  - name: security
    title: 安全审计
    priority: LOW
    description: 超级用户、异常权限成员
    queries:
      - security-audit.sql
  - name: sys-info
    title: 系统信息
    priority: LOW
    description: 操作系统级信息
    queries:
      - sys-info.sql
prerequisites:
  - 已连接到 PolarDB 实例的 **postgres** 数据库（GAWR 数据仅存在于 postgres 库中）
  - 使用账号具有 polar_gawr_collection schema 的 SELECT 权限
  - GAWR 本地存储已启用（可通过 `SELECT polar_gawr_collection.show_store_in_localdb()` 确认，返回 true 表示已启用）
---

# PolarDB GAWR 本地实例数据分析

## GAWR 是什么

GAWR（Global AWR）是 PolarDB 内置的性能监控数据存储系统。由 **UniverseExplorer** 采集代理定期从数据库引擎采集各项运行指标（CPU、内存、IO、SQL、等待事件等），以时序形式存储在本地数据库的 `polar_gawr_collection` schema 下。

**此技能通过直连 PolarDB 实例数据库执行 SQL 查询来获取数据**，不依赖 AK/SK、OpenAPI 或任何云控制面接口。使用前需要用户提供实例的数据库连接信息（host、port、user、password），连接到实例的 **postgres** 库后即可查询 GAWR 数据。

**适用版本：** PolarDB PostgreSQL 版，PG14 及以上。部分视图仅 PG14 版本有数据（PG15+ 不采集），在下方各视图说明中已标注。通过 `SHOW server_version_num` 可查看当前版本。

---

## Schema 结构

所有 GAWR 数据存储在 **postgres 数据库** 的 **`polar_gawr_collection`** schema 下（必须连接 postgres 库才能查询）：

| 类别 | 命名规则 | 数量 | 说明 |
|---|---|---|---|
| fact 底表 | `fact_{name}` | 35 | 原始采集数据 |
| view_fact 视图 | `view_fact_{name}` | 35 | fact 表关联维度表后的视图，**推荐查询** |
| agg 聚合表 | `agg_{name}_{60\|3600}` | 10 | 1分钟/1小时自动聚合 |
| view_agg 视图 | `view_agg_{name}_{60\|3600}` | 10 | 聚合表的视图 |
| dim 维度表 | `dim_{name}` | 10 | queryid、wait_event、backend_type 等枚举映射 |
| meta 元数据 | `meta_{name}` | 6 | 采集配置、数据模型配置、快照 |

另有 `polar_gawr_report` schema，由 GAWR 系统初始化时创建，预留用于报表功能。当前该 schema 下为空（无表、无函数），分析时无需关注。

---

## 关键概念

### 时间字段

所有表的 `time` 字段为 **Unix timestamp（整数，秒级）**。转可读时间用 `to_timestamp(time)`。

### 实例标识

每条数据包含以下标识字段：

- **`logical_ins_name`**：逻辑实例名（集群名，如 `pc-2ze7m7njokdaga82y`）
- **`physical_ins_name`**：物理节点名，区分 RW 主节点和 RO 只读节点
- **`role`**：节点角色（`RW` / `RO` / `Standby`）
- **`version`**：数据库版本

> 在本地实例上通常只有一个 logical_ins_name，但可能有多个 physical_ins_name（RW + 多个 RO 的数据都会写入）。

### 查询推荐

**始终使用 `view_fact_*` 视图**而非直接查 `fact_*` 底表。视图自动关联维度表，字段名更易读。

### 辅助函数：自动选择数据粒度

当查询时间跨度较大时，可使用辅助函数自动选择合适的数据源（fact/agg_60/agg_3600）：

```sql
SELECT * FROM polar_gawr_collection.get_data_from_proper_table(
    NULL::polar_gawr_collection.view_fact_dbmetrics,
    EXTRACT(EPOCH FROM now() - interval '6 hours')::INTEGER,
    EXTRACT(EPOCH FROM now())::INTEGER,
    300  -- 期望粒度（秒）
);
```

此函数仅对有聚合表的 5 个数据模型有效：dbmetrics、polar_aas_history、polar_stat_io_info、polar_stat_io_latency、polar_stat_process。

### 数据保留周期

| 数据类型 | 保留时间 |
|---|---|
| fact 原始数据 | 3 天（259200 秒） |
| agg_60（1分钟聚合） | 7 天（604800 秒） |
| agg_3600（1小时聚合） | 15 天（1296000 秒） |

### 查询类管理函数（可直接执行）

```sql
-- 检查 GAWR 本地存储是否启用（true=已启用）
SELECT polar_gawr_collection.show_store_in_localdb();

-- 检查 GAWR 采集是否启用
SELECT polar_gawr_collection.is_enabled();

-- 列出所有采集项及其配置
SELECT * FROM polar_gawr_collection.list_collections();

-- 查看数据模型聚合配置
SELECT * FROM polar_gawr_collection.get_datamodel('dbmetrics');

-- 查看快照列表
SELECT * FROM polar_gawr_collection.list_snapshots();

-- 查看逻辑实例列表
SELECT * FROM polar_gawr_collection.list_logic_ins_name();

-- 查看数据模型列表
SELECT * FROM polar_gawr_collection.list_datamodels();
```

### 修改类管理函数（禁止执行，仅供告知用户）

> **重要：以下函数会修改数据库状态，不得自行执行。** 如需操作，应告知用户具体 SQL 并由用户自行决定执行。

```sql
-- 启用 GAWR 采集
SELECT polar_gawr_collection.enable();

-- 禁用 GAWR 采集
SELECT polar_gawr_collection.disable();

-- 启用 GAWR 本地存储
SELECT polar_gawr_collection.enable_store_in_localdb();

-- 禁用 GAWR 本地存储
SELECT polar_gawr_collection.disable_store_in_localdb();

-- 手动创建快照
SELECT polar_gawr_collection.snapshot();
```

### 当 GAWR 未启用时的处理

连接实例后应先检查 GAWR 状态，两个函数需要**都返回 true** 才能正常查询历史数据：

1. `SELECT polar_gawr_collection.is_enabled();` — 采集总开关（UE 是否在采集数据）
2. `SELECT polar_gawr_collection.show_store_in_localdb();` — 本地存储开关（采集的数据是否写入本地库）

**如果 `is_enabled()` 返回 false**：说明 GAWR 采集未启用，无历史数据。此时应：

1. **告知用户**：当前实例的 GAWR 采集未开启，无法查询历史监控数据
2. **教用户开启**：提示用户执行 `SELECT polar_gawr_collection.enable();`
3. **或请求授权**：如用户授权，可代为执行上述语句
4. **不得私自执行**启用或禁用操作

**如果 `show_store_in_localdb()` 返回 false**：说明采集可能在运行但数据未存到本地库。此时应：

1. **告知用户**：当前实例的 GAWR 本地存储未开启，无法查询历史监控数据
2. **教用户开启**：提示用户执行 `SELECT polar_gawr_collection.enable_store_in_localdb();`
3. **或请求授权**：如用户授权，可代为执行上述语句
4. **不得私自执行**启用或禁用操作

---

## 查询模式

### 基本原则

1. **先查结构再写 SQL**：对不熟悉的视图，先执行 `SELECT * FROM polar_gawr_collection.view_fact_xxx LIMIT 1` 了解实际字段名和数据格式，再编写分析查询
2. **空结果是正常的**：某些视图在特定实例/版本上可能无数据（未开启对应采集或无相关活动），查询返回空不代表 SQL 有误
3. **queries 目录下的 SQL 文件是可直接执行的查询模板**，按分析主题组织，可直接使用或根据需要调整时间范围和过滤条件

### 时间范围

```sql
-- 最近 1 小时
WHERE time > EXTRACT(EPOCH FROM now() - interval '1 hour')::INTEGER

-- 最近 6 小时
WHERE time > EXTRACT(EPOCH FROM now() - interval '6 hours')::INTEGER

-- 指定时间范围
WHERE time BETWEEN EXTRACT(EPOCH FROM '2026-04-16 04:00:00'::TIMESTAMP)::INTEGER
                AND EXTRACT(EPOCH FROM '2026-04-16 06:00:00'::TIMESTAMP)::INTEGER
```

### 时间聚合（5分钟粒度示例）

```sql
SELECT
    to_timestamp(time - time % 300) AS ts,
    AVG(metric) AS avg_metric
FROM polar_gawr_collection.view_fact_dbmetrics
WHERE time > EXTRACT(EPOCH FROM now() - interval '6 hours')::INTEGER
GROUP BY time - time % 300
ORDER BY ts;
```

---

## 执行顺序

建议按优先级 **HIGH → MEDIUM → LOW** 执行：

1. **数据发现**：确认 GAWR 已启用、有数据
2. **实例概览**：角色、版本、规格
3. **资源使用**：CPU / 内存 / IO / 文件系统
4. **数据库性能**：TPS / 连接 / 缓存命中 / 等待事件
5. **复制状态**：延迟 / 复制槽
6. **SQL 分析**：Top SQL / 数据库统计
7. **存储空间**：WAL / 表大小 / 表年龄
8. **内存详情**：进程内存 / 内存上下文
9. **IO 延迟**：延迟分布
10. **异常事件**：ERROR / FATAL / OOM / Core
11. **PolarDB 内部**：Checkpoint / LogIndex / DirtyPage
12. **参数配置** / **特性状态** / **网络** / **安全**

---

## 阈值参考

| 指标 | 正常 | 警告 | 危险 |
|---|---|---|---|
| CPU 使用率 | < 70% | 70-90% | > 90% |
| 内存使用率 | < 80% | 80-95% | > 95% |
| 缓存命中率 | > 99% | 95-99% | < 95% |
| 复制延迟 (RO) | < 100MB | 100MB-1GB | > 1GB |
| 事务 ID 年龄 (db_age) | < 14亿 | 14-20亿 | > 20亿 |
| 最长事务 (swell_time) | < 1小时 | 1-6小时 | > 6小时 |
| 文件系统使用率 | < 70% | 70-80% | > 80% |
| WAL 目录大小 | < 50GB | 50-100GB | > 100GB |
| IO 延迟 >100ms 占比 | < 1% | 1-5% | > 5% |
| Core dump | 0 | - | > 0 |
| OOM 事件 | 0 | - | > 0 |

---

## 核心 fact 表/视图说明

### view_fact_dbmetrics — 实例综合运行指标（最核心）

汇聚了大部分采集项的结果，约 300 个值字段，是使用最频繁的视图。字段随采集版本动态创建。agent 可直接 `SELECT * LIMIT 1` 查看所有列名，以下仅说明**查表无法得知的信息**。

**通用规则：**
- `*_delta` 后缀字段均为采集间隔内的增量（非累计值）
- 标识字段：time（Unix 时间戳）, logical_ins_name, physical_ins_name, role（RW/RO/Standby）, version, host, port

**非显而易见的单位/含义：**

| 字段 | 单位/含义 |
|---|---|
| cpu_user_usage / cpu_sys_usage / cpu_total_usage | 百分比 |
| mem_total_usage | 百分比 |
| mem_total_used / mem_total | MB |
| pls_throughput_read / pls_throughput_write | KB/s（PFS 层读写吞吐） |
| pls_iops_quota | PFS IOPS 配额上限 |
| fs_blocks_usage / fs_inodes_usage | 百分比 |
| fs_size_total / pls_pg_wal_dir_size / pls_pg_csnlog_dir_size / polar_base_dir_size | MB |
| connection_ratio | 连接使用率（总连接 / max_connections） |
| replay_lag | MB，startup 进程回放延迟（receive_lsn 与 replay_lsn 之差） |
| bg_replay_lag | MB，并行回放进程延迟（PolarDB 特有：startup 解析 WAL，并行回放进程实际回放，此字段反映后者） |
| min_used_lag | MB，RO 上所有后端和后台进程使用的最小 LSN 与 receive_lsn 之差 |
| logindex_mem_tbl_size | LogIndex 内存表已用**个数**（非字节） |
| max_slot_wal_delay_in_mb | MB，复制槽最大 WAL 滞后 |
| swell_time | 秒，最长未结束事务持续时间（含 prepared transactions） |
| db_age | 所有库中最大的事务 ID 年龄（`MAX(AGE(datfrozenxid))`） |
| core_file_num | 数据目录下 core 文件个数 |
| longest_sql_running_time / longest_tx_running_time | 毫秒 |
| oldest_active_xid_age | 最老活跃事务的 ID 年龄 |
| checkpoint_write_time_delta / checkpoint_sync_time_delta | 毫秒 |
| snapshot_no | UE 内部采集轮次编号，无业务含义 |

**字段命名规则（约 200 个未逐一列出的字段，可通过前缀推断含义）：**

| 前缀/模式 | 含义 |
|---|---|
| `engine_*` / `manager_*` / `pod_*` / `pfsd_*` / `pfsd_tool_*` / `pause_*` | 按组件拆分的 CPU/内存（`_cpu_user`, `_cpu_sys`, `_mem_rss`, `_mem_used`, `_kmem_used` 等） |
| `backend_*` / `bgwriter_*` / `checkpoint_*` / `startup_*` / `walreceiver_*` / `logger_*` / `pgstat_*` / `postmaster_*` | 按进程类型拆分的 CPU/内存/IOPS/IO吞吐/进程数 |
| `procs_*_sum` | 所有进程的聚合值（`procs_cpu_user_sum`, `procs_mem_rss_sum` 等） |
| `pls_*_dir_size` | PFS 各子目录大小（MB） |
| `local_*` | 本地存储 IO |
| `cgroup_*` | cgroup 级资源 |
| `pcu_*` | PCU 资源配额 |
| `*_seconds_*` | 按时长分桶的事务/SQL 计数（如 `one_second_transactions`, `five_seconds_executing_sqls`） |
| `fs_*` | 文件系统细分 |

---

### view_fact_polar_aas_history — 等待事件 AAS

Average Active Session 数据，每秒采集。wait_count 为采样周期内该等待事件的出现次数。

---

### view_fact_pg_stat_replication — 流复制状态

每 10 秒采集，仅 RW 节点（role=1）。延迟字段说明：
- `*_latency_in_bytes` — 字节（当前 WAL LSN 与对端 LSN 之差）
- `*_lag_in_ms` — 毫秒（PG 原生的 write_lag/flush_lag/replay_lag 转毫秒）

---

### view_fact_pg_replication_slots — 复制槽

每 10 秒采集，仅 RW 节点。xmin_age / catalog_xmin_age 为事务 ID 年龄；restart_latency_in_bytes / confirmed_flush_latency_in_bytes 为字节。

---

### view_fact_polar_stat_top_sql — Top SQL 历史快照

每 10 分钟从 `pg_stat_statements` 采集 Top 100 SQL 快照。字段有数据时才动态创建。此视图为历史采样数据，如需实时分析可直接查询 `pg_stat_statements`。

---

### view_fact_polar_stat_process — 后台进程资源

每 10 秒采集。按 backend_type 分组的 CPU/内存/IO。rss 单位取决于采集 SQL（通常为 MB）。

---

### view_fact_polar_event — 数据库事件日志

ERROR/FATAL/PANIC/RECOVER_START/RECOVER_END 等事件。通过日志采集器获取，非 SQL 采集。

---

### view_fact_polar_stat_io_latency — IO 延迟分布

每 10 秒采集。按 iotype 分桶，值字段为各延迟区间请求数的速率（<200us, <1ms, <10ms, <100ms, >100ms）。PG14 版本多一个 ioloc 维度。

---

### view_fact_polar_stat_io_info — IO 详细信息

每 10 秒采集。按 fileloc（本地/共享存储）和 filetype 分组。throughput 为速率，count 为速率。

---

### view_fact_pg_stat_database — 数据库级统计

每分钟采集。各字段为速率（每秒值），排除 template 和 polardb_admin 库。

---

### view_fact_polar_stat_mcxt — 内存上下文

进程级内存上下文详情。

---

### view_fact_polar_stat_shmem_allocation — 共享内存分配

每小时采集，PG14+。目前仅采集 `name IS NULL` 的浪费共享内存（wasted_shmem）。

---

### view_fact_polar_settings — 参数快照

每小时采集。name/source/setting 键值对，来自 `pg_settings`。

### view_fact_polar_extensions — 已安装扩展

每小时采集，遍历所有数据库。

---

### view_fact_polar_stat_gpc — Global Plan Cache 统计

每 10 秒采集。**需要实例开启 `polar_enable_gpc_level` 参数**，否则无数据。值字段均为速率（每秒增量）。

---

### view_fact_polar_feature_utils — 特性开关状态

每 5 分钟采集。**需要 `polar_feature_utils.polar_unique_feature_usage` 视图存在**，否则无数据。value 字段为使用计数速率。

---

### view_fact_polar_stat_network — 网络统计

每 10 秒采集。按网卡（devname）分组，值字段均为速率（字节/秒、包/秒）。

---

### view_fact_polar_abnormal_superusers / polar_abnormal_auth_members — 安全审计

每小时采集。

- **polar_abnormal_superusers** — 非白名单超级用户数（白名单：postgres, aurora, replicator, polardb_admin）
- **polar_abnormal_auth_members** — 拥有高危角色（pg_read_all_data, pg_write_all_data, pg_read_server_files 等）的成员数

---

### view_fact_sys_info — 操作系统信息

通过 shell 命令采集，存储为 name/value/type 键值对（如 kernel_version）。

---

### view_fact_polar_stat_relation_size — 表/索引大小 Top 100

每小时采集，遍历所有数据库，**仅保留最大的 100 个对象**。relsize_total 单位 MB（按 `relpages * block_size / 1024 / 1024` 计算）。relkind 含义：r=表, i=索引, m=物化视图。

---

### view_fact_polar_stat_table_age — 表事务 ID 年龄 Top 10

每小时采集，遍历所有数据库，**仅保留 AGE(relfrozenxid) 最大的 10 个对象**。

---

### view_fact_polar_active_conn_top_user — 连接 Top 用户

每秒采集。排除系统用户（postgres, aurora, polardb_admin），**仅保留活跃连接数 Top 5 的用户**。

---

### view_fact_polar_advisor_window — 维护窗口记录

每 10 分钟采集。**需要 polar_advisor 扩展**（需存在 polar_advisor schema 下的 advisor_window 等表），否则无数据。记录自动维护窗口的执行详情（vacuum 进度、age 变化、页面扫描等）。

---

### view_fact_polar_stat_qps — QPS 按 SQL 类型分类

> 注意：此数据模型在 UE 配置中 `values` 为空（无数值字段定义），视图只有维度列（sqltype、cmdtype），不含任何可聚合的指标，不可用于分析。如需 TPS/QPS 趋势，使用 `view_fact_dbmetrics` 中的 `qps_delta`（总 QPS）、`commits_delta`、`rollbacks_delta` 字段。

---

### view_fact_polar_db_encoding — 数据库编码

每小时采集。记录各数据库的编码、排序规则。

---

### view_fact_polar_max_memory_backend_memory_context — 大内存进程的内存上下文

每 10 秒采集。**仅针对 RSS 超过 1MB 的最大内存客户端进程**，按内存上下文名称分组，取 Top 5。totalspace/freespace 单位为字节。

---

### view_fact_polar_stat_bulk_io_latency — 批量 IO 延迟（仅 PG14）

每 10 秒采集，**仅 PG14 版本（PG15+ 不采集）**。按 IO 操作类型分桶，值字段为各延迟区间的请求数速率（<200us, <400us, <1ms, <10ms, <100ms, >100ms）。

---

### view_fact_polar_stat_gcc_grc — GCC/GRC 统计

每小时采集，PG14+。**需要同时开启 `polar_enable_global_relcache` 和 `polar_enable_global_catcache`**，否则无数据。local_hit/global_hit 字段为命中率（0~1 之间的小数）。

---

### view_fact_polar_rsc_stat_counters — RSC 计数器（仅 PG14）

每 10 秒采集，**仅 PG14 版本（PG15+ 不采集）**。值字段均为速率。

---

### view_fact_polar_stat_materialized_view — 物化视图统计（仅 PG14）

每小时采集，遍历所有数据库。**仅 PG14 版本（PG15+ 不采集）**。imv_count 为增量物化视图数。

---

### view_fact_polar_stat_user_functions — 用户函数调用统计

每小时采集，遍历所有数据库，**仅保留 calls Top 100 的函数**。值字段为增量，time 类字段单位 ms。

---

### view_fact_polar_stat_user_tables — 用户表扫描/读写统计

每小时采集，遍历所有数据库，**仅保留 (seq_tup_read+idx_tup_fetch) Top 100 的表**。`*_delta` 后缀字段为采集间隔增量；last_vacuum/last_autovacuum/last_analyze/last_autoanalyze 为 Unix 时间戳；dead_tup_ratio 为百分比。

---

### view_fact_polar_statio_user_indexes — 索引 IO 统计

每小时采集，遍历所有数据库，**仅保留 (idx_blks_read+idx_blks_hit) Top 100 的索引**。值字段为增量。

---

### view_fact_polar_statio_user_tables — 表 IO 统计

每小时采集，遍历所有数据库，**仅保留 (heap_blks_read+heap_blks_hit) Top 100 的表**。值字段为增量。
