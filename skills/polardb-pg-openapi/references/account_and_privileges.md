# Account and Privileges (Agent-Ready Flow)

Goal: create accounts/databases, grant/revoke privileges, verify outcomes, and clean up.
Precondition: the cluster must be Running and Unlocked before any write operation.
Note: **Do not read or output any Alibaba Cloud credentials** (repo constraint).
Note: PolarDB PostgreSQL allows multiple high-privilege (Super) accounts; PolarDB MySQL allows only one.

## Prerequisites

Before starting this workflow, confirm the following parameters with the user:
- **region-id**: Target Alibaba Cloud region (e.g., cn-hangzhou)
- **db-cluster-id**: ID of the cluster (e.g., pc-xxxxxxxxxxxxx)
- **account-name**: Name for the account to create
- **account-password**: Strong password (8-32 chars, 3+ types)
- **account-type**: Account type (Super or Normal)
- **db-name**: Database name (if creating database)

## 0) Environment and common variables

```bash
export ALIYUN_CLI="${ALIYUN_CLI_PATH:-aliyun}"

export DBCLUSTER_ID="<cluster-id>"
export SUPER_ACCOUNT="superuser"
export SUPER_PASSWORD="<strong-password>"
export APP_ACCOUNT="appuser"
export APP_PASSWORD="<strong-password>"
export DB_NAME="appdb"
```

Strong password rule (safe superset): length 8–32 and includes **uppercase + lowercase + digit + special**.

## 1) Cluster status check (required)

```bash
$ALIYUN_CLI polardb describe-db-clusters --db-cluster-id "$DBCLUSTER_ID"
```

Require:
- `DBClusterStatus` == `Running`
- `LockMode` == `Unlock`

Otherwise stop and ask the user to fix the cluster state.

## 2) Account name pre-check (idempotency guard)

```bash
$ALIYUN_CLI polardb check-account-name --db-cluster-id "$DBCLUSTER_ID" --account-name "$SUPER_ACCOUNT"
$ALIYUN_CLI polardb check-account-name --db-cluster-id "$DBCLUSTER_ID" --account-name "$APP_ACCOUNT"
```

Account name rules:
- starts with lowercase letter
- only lowercase letters, digits, underscores
- length <= 16

## 3) Idempotent account creation

List accounts first:

```bash
$ALIYUN_CLI polardb describe-accounts --db-cluster-id "$DBCLUSTER_ID"
```

Create only if missing:

```bash
$ALIYUN_CLI polardb create-account \
  --db-cluster-id "$DBCLUSTER_ID" \
  --account-name "$SUPER_ACCOUNT" \
  --account-password "$SUPER_PASSWORD" \
  --account-type Super

$ALIYUN_CLI polardb create-account \
  --db-cluster-id "$DBCLUSTER_ID" \
  --account-name "$APP_ACCOUNT" \
  --account-password "$APP_PASSWORD" \
  --account-type Normal
```

Verify:

```bash
$ALIYUN_CLI polardb describe-accounts --db-cluster-id "$DBCLUSTER_ID"
```

## 4) Database name pre-check (idempotency guard)

```bash
$ALIYUN_CLI polardb check-db-name --db-cluster-id "$DBCLUSTER_ID" --db-name "$DB_NAME"
```

## 5) Idempotent database creation (PG requires owner + Collate/Ctype)

Create only if missing:

```bash
$ALIYUN_CLI polardb create-database \
  --db-cluster-id "$DBCLUSTER_ID" \
  --db-name "$DB_NAME" \
  --character-set-name UTF8 \
  --account-name "$SUPER_ACCOUNT" \
  --collate "C" \
  --ctype "C" \
  --db-description "app db for privilege test"
```

Verify:

```bash
$ALIYUN_CLI polardb describe-databases --db-cluster-id "$DBCLUSTER_ID"
```

## 6) Grant privileges (Normal accounts only)

```bash
$ALIYUN_CLI polardb grant-account-privilege \
  --db-cluster-id "$DBCLUSTER_ID" \
  --account-name "$APP_ACCOUNT" \
  --db-name "$DB_NAME" \
  --account-privilege ReadWrite
```

If this API fails for PolarDB PostgreSQL, fall back to in-database SQL GRANT (with user confirmation).

Verify grant via account listing:

```bash
$ALIYUN_CLI polardb describe-accounts --db-cluster-id "$DBCLUSTER_ID"
```

Check `DatabasePrivileges` for the target database.

## 7) Revoke privileges (Normal accounts only)

```bash
$ALIYUN_CLI polardb revoke-account-privilege \
  --db-cluster-id "$DBCLUSTER_ID" \
  --account-name "$APP_ACCOUNT" \
  --db-name "$DB_NAME"
```

Verify revoke:

```bash
$ALIYUN_CLI polardb describe-accounts --db-cluster-id "$DBCLUSTER_ID"
```

## 8) Reset password (choose one)

Recommended:

```bash
$ALIYUN_CLI polardb modify-account-password \
  --db-cluster-id "$DBCLUSTER_ID" \
  --account-name "$APP_ACCOUNT" \
  --new-account-password "<new-strong-password>"
```

Or:

```bash
$ALIYUN_CLI polardb reset-account-password \
  --db-cluster-id "$DBCLUSTER_ID" \
  --account-name "$APP_ACCOUNT" \
  --account-password "<new-strong-password>"
```

## 9) Delete database (async + poll)

```bash
$ALIYUN_CLI polardb delete-database --db-cluster-id "$DBCLUSTER_ID" --db-name "$DB_NAME"
```

Poll until the database is gone:

```bash
while $ALIYUN_CLI polardb describe-databases --db-cluster-id "$DBCLUSTER_ID" | grep -q "$DB_NAME"; do
  sleep 10
done
```

## 10) Delete accounts

```bash
$ALIYUN_CLI polardb delete-account --db-cluster-id "$DBCLUSTER_ID" --account-name "$APP_ACCOUNT"
$ALIYUN_CLI polardb delete-account --db-cluster-id "$DBCLUSTER_ID" --account-name "$SUPER_ACCOUNT"
```

Verify:

```bash
$ALIYUN_CLI polardb describe-accounts --db-cluster-id "$DBCLUSTER_ID"
```
