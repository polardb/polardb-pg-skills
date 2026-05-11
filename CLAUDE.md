# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

PolarDB PostgreSQL 技能库，包含数据库巡检、性能调优等技能。每个技能提供可直接执行的 SQL 查询和诊断建议。

## Directory Structure

```
polardb-pg-skills/
├── skills/                    # 技能目录
│   ├── routine-check/         # 日常巡检
│   │   ├── SKILL.md
│   │   └── queries/
│   └── performance-tuning/    # 性能调优
│       ├── SKILL.md
│       └── queries/
├── shared/                    # 共享资源
│   ├── thresholds.md          # 通用阈值定义
│   └── templates/             # SQL 模板
├── CLAUDE.md
└── README.md
```

## Skill Format

每个技能目录包含:

- `SKILL.md` - 技能定义文件 (YAML frontmatter + Markdown)
- `queries/` - SQL 查询文件，按类别组织

### SKILL.md 格式

```yaml
---
name: skill-name
version: "1.0.0"
description: 技能描述
categories:
  - name: category-1
    priority: HIGH
    queries:
      - query-1.sql
      - query-2.sql
prerequisites:
  - PostgreSQL 12+
  - 超级用户权限
---
```

## Usage

1. 读取目标技能的 `SKILL.md` 了解技能范围
2. 根据 categories 按优先级执行查询
3. 参考 `shared/thresholds.md` 判断结果

## Available Skills

| 技能 | 说明 | 状态 |
|------|------|------|
| routine-check | 日常巡检、健康检查 | ✅ 可用 |
| performance-tuning | 性能调优、SQL优化 | 🚧 开发中 |

## Adding New Skills

1. 在 `skills/` 下创建新目录
2. 创建 `SKILL.md` 文件
3. 创建 `queries/` 目录存放 SQL 文件
4. 更新本文件的 Available Skills 表格
