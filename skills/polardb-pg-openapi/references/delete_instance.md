# Delete / Release Instance

This flow deletes a PolarDB for PostgreSQL cluster and handles common state errors.

## Prerequisites

Before starting this workflow, confirm the following parameters with the user:
- **region-id**: Target Alibaba Cloud region (e.g., cn-hangzhou)
- **db-cluster-id**: ID of the cluster to delete (e.g., pc-xxxxxxxxxxxxx)

## 1) Check status and deletion protection

**Recommended**: Use `describe-db-cluster-attribute` to get single cluster details:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-attribute \
  --db-cluster-id <id>
```

**Key fields to check**:
- `DBClusterStatus`: Must be `Running` before delete
- `DeletionLock`: `0` = no protection (can delete), `1` = protection enabled (must disable first)
- `PayType`: `Postpaid` (immediate release) or `Prepaid` (requires `--release-cluster true`)

**Alternative**: List all clusters and filter:

```bash
# List all PostgreSQL clusters in the region
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-clusters \
  --region-id <region-id> \
  --db-type PostgreSQL

# Or query specific cluster IDs (comma-separated string)
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-clusters \
  --region-id <region-id> \
  --db-cluster-ids "<id>"
```

## 2) Check deletion protection

If `DeletionLock` is `1`, disable it first:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-deletion \
  --db-cluster-id <id> \
  --deletion-lock 0
```

## 3) Delete the cluster

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb delete-db-cluster \
  --db-cluster-id <id>
```

**For Prepaid (subscription) clusters**, add `--release-cluster true`:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb delete-db-cluster \
  --db-cluster-id <id> \
  --release-cluster true
```

**Note**:
- Delete request returns only `RequestId` on success (no cluster ID in response)
- Deletion is **asynchronous** - cluster enters `Deleting` status, then disappears from list
- Postpaid clusters: resources released immediately after deletion
- Prepaid clusters: released at end of billing period unless `--release-cluster true`

## 4) Handle IncorrectDBInstanceState

If delete fails with `IncorrectDBInstanceState`:
- Wait until status becomes `Running`
- Retry delete

**Common status values that block deletion**:
| Status | Meaning | Action |
|--------|---------|--------|
| `Creating` | Still being created | Wait 5-10 minutes |
| `Deleting` | Already being deleted | Wait for completion |
| `Rebooting` | Restarting | Wait a few minutes |
| `DBNodeClassChanging` | Scaling in progress | Wait for completion |
| `NetAddressModifying` | Network change in progress | Wait for completion |

**Only `Running` status allows deletion.**

## 5) Verify deletion

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-clusters \
  --region-id <region-id> \
  --db-type PostgreSQL
```

**Deletion lifecycle**:
1. After `delete-db-cluster` call succeeds: status changes to `Deleting`
2. After a few minutes: cluster disappears from the list entirely
3. If cluster still appears with `Deleting` status: wait longer

**Success indicator**: Cluster no longer appears in the list, or `TotalRecordCount` decreases.

## 6) Complete workflow example

```bash
# Step 1: Check cluster status and deletion lock
CLUSTER_ID="pc-xxxxxxxxxxxxx"
REGION="<region-id>"

STATUS=$(${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-attribute \
  --db-cluster-id $CLUSTER_ID | jq -r '.DBClusterStatus')

DELETION_LOCK=$(${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-attribute \
  --db-cluster-id $CLUSTER_ID | jq -r '.DeletionLock')

echo "Status: $STATUS, DeletionLock: $DELETION_LOCK"

# Step 2: Disable deletion lock if needed
if [ "$DELETION_LOCK" = "1" ]; then
  ${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-deletion \
    --db-cluster-id $CLUSTER_ID \
    --deletion-lock 0
  echo "Deletion lock disabled"
fi

# Step 3: Delete (only if Running)
if [ "$STATUS" = "Running" ]; then
  ${ALIYUN_CLI_PATH:-aliyun} polardb delete-db-cluster \
    --db-cluster-id $CLUSTER_ID
  echo "Delete request submitted"
else
  echo "Cannot delete: status is $STATUS (must be Running)"
fi

# Step 4: Verify deletion
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-clusters \
  --region-id $REGION \
  --db-type PostgreSQL
```
