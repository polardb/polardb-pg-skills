# Modify Access Whitelist

This flow shows how to view and update the access whitelist for a PolarDB for PostgreSQL cluster.

## Prerequisites

Before starting this workflow, confirm the following parameters with the user:
- **region-id**: Target Alibaba Cloud region (e.g., cn-hangzhou)
- **db-cluster-id**: ID of the cluster (e.g., pc-xxxxxxxxxxxxx)
- **security-ips**: IP addresses or CIDR ranges to whitelist

## 1) View current whitelist

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-access-whitelist --db-cluster-id <id>
```

Key fields in response:
- `DBClusterIPArrayName`: Name of the IP group
- `SecurityIPList`: Comma-separated list of IPs/CIDRs
- `WhitelistNetworkType`: VPC or Classic

## 2) Update whitelist (replace list)

Replace the whitelist with your IP or CIDR:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-access-whitelist \
  --db-cluster-id <id> \
  --security-ips "<ip-or-cidr>"
```

Examples:
- Single IP: `203.0.113.10`
- Multiple IPs: `203.0.113.10,203.0.113.11`
- CIDR range: `192.168.0.0/16`
- Allow all (not recommended for production): `0.0.0.0/0`

## 3) ModifyMode (Append / Delete)

PolarDB supports `--modify-mode` parameter for incremental updates:

Append a new IP without replacing existing entries:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-access-whitelist \
  --db-cluster-id <id> \
  --modify-mode Append \
  --security-ips "<ip-or-cidr>"
```

Delete an IP from the whitelist:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-access-whitelist \
  --db-cluster-id <id> \
  --modify-mode Delete \
  --security-ips "<ip-or-cidr>"
```

Notes:
- `Append` fails if the IP already exists.
- `Delete` fails when the IP does not exist.
- `Delete` may fail if it would leave the list empty; keep at least one IP.
- Default `--modify-mode` is `Cover` (replace the list).

## 4) Work with multiple IP groups

List all IP groups:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-access-whitelist --db-cluster-id <id>
```

Modify a specific group by name:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-access-whitelist \
  --db-cluster-id <id> \
  --db-cluster-ip-array-name <group-name> \
  --security-ips "<ip-or-cidr>"
```

## 5) Confirm update

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-access-whitelist --db-cluster-id <id>
```

Notes:
- Default whitelist often starts as `127.0.0.1` only.
- If you only connect from VPC, use the ECS private IP or VPC CIDR.
- For security, avoid using `0.0.0.0/0` in production environments.
- Changes take effect immediately.
