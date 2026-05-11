# Get Connection Info

This flow retrieves connection strings and shows a basic psql client command.

## Prerequisites

Before starting this workflow, confirm the following parameters with the user:
- **region-id**: Target Alibaba Cloud region (e.g., cn-hangzhou)
- **db-cluster-id**: ID of the cluster (e.g., pc-xxxxxxxxxxxxx)

## 1) Get net info

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-net-info --db-cluster-id <id>
```

Key fields in the response:
- `ConnectionString`
- `IPAddress`
- `Port` (default: 5432 for PostgreSQL)
- `NetType` (VPC or Public)

## 2) psql client example (VPC)

```bash
psql -h <connection-string> -p 5432 -U <user> -d postgres
```

If login is blocked, verify the whitelist:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-access-whitelist --db-cluster-id <id>
```

## 3) Connection string formats

PolarDB for PostgreSQL provides different endpoint types:
- Cluster endpoint: Read-write access (primary node)
- Custom cluster endpoint: Load balancing across read-write or read-only nodes
- Primary endpoint: Direct connection to primary node

Use `describe-db-cluster-endpoints` to list all endpoints:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-endpoints --db-cluster-id <id>
```
