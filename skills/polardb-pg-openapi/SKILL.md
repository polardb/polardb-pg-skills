---
name: polardb-pg-openapi
description: Manage Alibaba Cloud PolarDB for PostgreSQL via OpenAPI/SDK. Use whenever the user needs PolarDB PostgreSQL resource lifecycle and configuration operations, status checks, or troubleshooting PolarDB API and cluster workflow issues.
---

Category: service

# PolarDB PostgreSQL

Use Alibaba Cloud OpenAPI (RPC) with official SDKs or OpenAPI Explorer to manage resources for PolarDB PostgreSQL.

## Parameter Confirmation

Before any workflow, confirm these parameters with the user:

| Category | Parameter | Required | Description | Example |
|----------|-----------|----------|-------------|---------|
| **Global** | region-id | Yes | Alibaba Cloud region | cn-hangzhou |
| **Global** | resource-group-id | No | Resource group for billing | rg-xxx |
| **Cluster** | db-type | Yes | Database type | PostgreSQL |
| **Cluster** | db-version | Yes | PostgreSQL version | 14, 15 |
| **Cluster** | pay-type | Yes | Billing type | Postpaid, Prepaid |
| **Cluster** | vpc-id | Yes | VPC ID | vpc-xxx |
| **Cluster** | vswitch-id | Yes | vSwitch ID | vsw-xxx |
| **Cluster** | zone-id | Yes | Availability zone | cn-hangzhou-b |
| **Cluster** | db-node-class | No | Instance spec | polar.pg.x4.medium |
| **Account** | account-name | Yes | Account name | superuser |
| **Account** | account-password | Yes | Password (8-32 chars, 3+ types) | Str0ng!Pass |
| **Account** | account-type | Yes | Account type | Super, Normal |
| **Database** | db-name | Yes | Database name | appdb |
| **Database** | character-set-name | No | Character set | UTF8 |
| **Network** | security-ips | Yes | IP whitelist | 192.168.0.0/16 |

## Workflow

1) Confirm region, resource identifiers, and desired action.
2) Discover API list and required parameters (see references).
3) Call API with SDK or OpenAPI Explorer.
4) Verify results with describe/list APIs.

## AccessKey priority (must follow)

1) Environment variables: `ALICLOUD_ACCESS_KEY_ID` / `ALICLOUD_ACCESS_KEY_SECRET` / `ALICLOUD_REGION_ID`
Region policy: `ALICLOUD_REGION_ID` is an optional default. If unset, decide the most reasonable region for the task; if unclear, ask the user.
2) Shared config file: `~/.alibabacloud/credentials`

## Aliyun CLI Configuration

The Aliyun CLI path is configurable via environment variable:

```bash
# Option 1: Set ALIYUN_CLI_PATH to your CLI location
export ALIYUN_CLI_PATH=/path/to/aliyun

# Option 2: If aliyun is already in your PATH, leave it unset
# Commands will use "aliyun" by default
```

In reference documents, commands use `${ALIYUN_CLI_PATH:-aliyun}` which:
- Uses `$ALIYUN_CLI_PATH` if set
- Falls back to `aliyun` (assumes it's in PATH) if not set

Install Aliyun CLI: https://help.aliyun.com/document_detail/139508.html

## API discovery

- Product code: `polardb`
- Default API version: `2017-08-01`
- Use OpenAPI metadata endpoints to list APIs and get schemas (see references).

## High-frequency operation patterns

1) Inventory/list: prefer `List*` / `Describe*` APIs to get current resources.
2) Change/configure: prefer `Create*` / `Update*` / `Modify*` / `Set*` APIs for mutations.
3) Status/troubleshoot: prefer `Get*` / `Query*` / `Describe*Status` APIs for diagnosis.

## Minimal executable quickstart

Use metadata-first discovery before calling business APIs:

```bash
python scripts/list_openapi_meta_apis.py
```

Optional overrides:

```bash
python scripts/list_openapi_meta_apis.py --product-code <ProductCode> --version <Version>
```

The script writes API inventory artifacts under the skill output directory.

## Output policy

If you need to save responses or generated artifacts, write them under:
`output/polardb/`

## Validation

```bash
mkdir -p output/polardb
for f in skills/polardb-pg-openapi/scripts/*.py; do
  python3 -m py_compile "$f"
done
echo "py_compile_ok" > output/polardb/validate.txt
```

Pass criteria: command exits 0 and `output/polardb/validate.txt` is generated.

## Output And Evidence

- Save artifacts, command outputs, and API response summaries under `output/polardb/`.
- Include key parameters (region/resource id/time range) in evidence files for reproducibility.

## Prerequisites

- Configure least-privilege Alibaba Cloud credentials before execution.
- Prefer environment variables: `ALICLOUD_ACCESS_KEY_ID`, `ALICLOUD_ACCESS_KEY_SECRET`, optional `ALICLOUD_REGION_ID`.
- If region is unclear, ask the user before running mutating operations.
- Python: use Python 3.8+ when running scripts in this skill.

## References

- Sources: `references/sources.md`
- API overview: `references/api_overview.md`
- High-frequency params: `references/api_reference.md`
- Create instance flow: `references/create_instance_flow.md`
- Modify whitelist: `references/modify_whitelist.md`
- Get connection info: `references/get_connection_info.md`
- Troubleshooting: `references/troubleshooting_common_errors.md`
- Account and privileges: `references/account_and_privileges.md`
- Delete instance: `references/delete_instance.md`
- Security and network: `references/security_network.md`
- Backup, restore, GDN: `references/backup_restore_gdn.md`
- Ops and monitoring: `references/ops_monitoring_tasks.md`
- Scaling and versioning: `references/scaling_ha_version.md`
