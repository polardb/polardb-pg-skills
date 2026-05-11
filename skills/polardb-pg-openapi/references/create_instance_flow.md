# Create PolarDB for PostgreSQL Instance Flow

This flow documents a practical, failure-tolerant path to create a PolarDB for PostgreSQL cluster via OpenAPI/CLI.

## Prerequisites

Before starting this workflow, confirm the following parameters with the user:
- **region-id**: Target Alibaba Cloud region (e.g., cn-hangzhou)
- **db-type**: Database type (PostgreSQL)
- **db-version**: PostgreSQL version (e.g., 14, 15)
- **pay-type**: Billing type (Postpaid or Prepaid)
- **vpc-id**: VPC ID for network configuration
- **vswitch-id**: vSwitch ID (must match the zone)
- **zone-id**: Availability zone

## 0) Preconditions

- Python: use Python 3.8+ for scripts in this skill.
- Credentials: one of the following:
  - Aliyun CLI configured via `aliyun configure` (recommended)
  - Environment variables: `ALICLOUD_ACCESS_KEY_ID`, `ALICLOUD_ACCESS_KEY_SECRET`

## 1) Discover API metadata (optional but recommended)

```bash
python scripts/list_openapi_meta_apis.py --product-code polardb --version 2017-08-01
```

## 2) Pick region, VPC, and vSwitch

List regions:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-regions --region-id <region-id>
```

List VPCs and choose a default or intended VPC:

```bash
${ALIYUN_CLI_PATH:-aliyun} vpc describe-vpcs --region-id <region-id> --page-size 50
```

List vSwitches for the chosen VPC and pick a zone/vSwitch pair:

```bash
${ALIYUN_CLI_PATH:-aliyun} vpc describe-vswitches --region-id <region-id> --vpc-id <vpc-id> --page-size 50
```

## 3) Check available resources (per zone)

Use this to decide the available specs per zone:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-available-resources \
  --region-id <region-id> \
  --zone-id <zone-id> \
  --db-type PostgreSQL \
  --db-version 14 \
  --pay-type Postpaid
```

Note: DBVersion can be `11`, `14`, or `15` depending on availability. PayType is required (`Postpaid` or `Prepaid`).

## 4) Decide creation mode and required parameters

PolarDB for PostgreSQL creation key parameters:

- **Required**:
  - `--db-type`: PostgreSQL
  - `--db-version`: PostgreSQL version (e.g., `11`, `14`, `15`)
  - `--pay-type`: Postpaid (pay-as-you-go) or Prepaid (subscription)
    - **Postpaid**: Subject to regional quota limits (typically 10-20 instances per region)
    - **Prepaid**: No quota limits, but requires upfront payment (minimum 1 month)
  - `--vpc-id`, `--vswitch-id`: Network configuration
- **Usually required for VPC**:
  - `--cluster-network-type`: VPC (if omitted, CLI may default; keep it explicit)
- **Optional / conditional**:
  - `--db-node-class`: e.g., `polar.pg.x4.medium` (for PostgreSQL this may be optional or ignored; follow CLI/API required list per region)

**Important**: `--zone-id` must match the zone of the specified `--vswitch-id`. Use `DescribeVSwitches` to verify the vSwitch's zone before creating the cluster.

## 5) Create cluster (minimal example)

```bash
CLIENT_TOKEN=codex-$(date -u +%Y%m%d%H%M%S)-$RANDOM
${ALIYUN_CLI_PATH:-aliyun} polardb create-db-cluster \
  --region-id <region-id> \
  --zone-id <zone-id> \
  --cluster-network-type VPC \
  --db-type PostgreSQL \
  --db-version 14 \
  --db-node-class polar.pg.x4.medium \
  --pay-type Postpaid \
  --vpc-id <vpc-id> \
  --vswitch-id <vsw-id> \
  --db-cluster-description "codex-pg-$(date -u +%Y%m%d%H%M%S)" \
  --client-token "$CLIENT_TOKEN"
```

**Note**:
- Cluster creation typically takes **5-10 minutes**. Status will be `Creating` during this period.
- `--client-token` ensures idempotency - retrying with the same token won't create duplicate clusters.
- If create-db-cluster reports that `--db-node-class` is not supported for PostgreSQL in your region, remove `--db-node-class` and retry.

## 6) Handle common failures

- `OperationDenied.PostpaidDBClusterNumber`:
  - Postpaid (pay-as-you-go) instance quota exceeded for this region.
  - Solutions:
    1. **Switch to another region** - Quota is calculated independently per region (e.g., try `cn-qingdao`, `cn-shenzhen`).
    2. **Use Prepaid** - Subscription mode has no quota limits, add `--pay-type Prepaid --period 1 --period-unit Month`.
    3. **Delete unused instances** - Free up quota by removing unnecessary clusters.
    4. **Request quota increase** - Submit a support ticket in Alibaba Cloud console.

- `InsufficientResourceCapacity`:
  - Try another zone in the same region.
  - Try a different db-node-class (use `describe-db-cluster-available-resources` to confirm).
  - If all zones fail, open a support ticket for capacity.

- `IncorrectDBInstanceState`:
  - Poll status until `Running`:

```bash
# Query all clusters and filter by ID
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-clusters --region-id <region-id> --db-type PostgreSQL

# Or query specific cluster IDs (comma-separated string)
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-clusters --region-id <region-id> --db-cluster-ids "<cluster-id>"
```

## 7) Create super account

Wait until cluster status is `Running`, then create an account:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb create-account \
  --db-cluster-id <id> \
  --account-name superuser \
  --account-password '<password>' \
  --account-type Super
```

Password rules:
- 8–32 chars
- include at least 3 of: upper / lower / digit / special (`!@#$%^&*()_+-=`)

## 8) Check network access / whitelist

Default whitelist may only include `127.0.0.1` (blocks external login). Check and update:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-access-whitelist --db-cluster-id <id>
```

Update whitelist if needed (example adds a single IP):

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-access-whitelist \
  --db-cluster-id <id> \
  --security-ips "<your-ip>"
```

## 9) Get connection info

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-net-info --db-cluster-id <id>
```

## 10) Cleanup (optional)

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb delete-db-cluster --db-cluster-id <id>
```

Note: Delete may fail if the instance is still `Creating`. Wait until `Running`.
