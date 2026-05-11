# Troubleshooting Common Errors

Applies to: Aliyun CLI (polardb). The same symptoms may appear via OpenAPI/SDK with equivalent error codes.

## InsufficientResourceCapacity

Symptoms:
- create-db-cluster returns `InsufficientResourceCapacity`.

Actions:
- Try another zone in the same region.
- Try a different db-node-class (use `describe-db-cluster-available-resources` to confirm available specs).
- If all zones fail, open a support ticket for capacity.

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-available-resources \
  --region-id <region-id> \
  --zone-id <zone-id> \
  --db-type PostgreSQL
```

## Instance Not Ready (IncorrectDBInstanceState)

Symptoms:
- Account operations (create-account, delete-account, modify-account) fail with `IncorrectDBInstanceState`.
- Operations fail during cluster state changes.

Actions:
- Check the `Status` field in the cluster attributes:
- Poll status until `Running` before retrying:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-attribute --db-cluster-id <id>
```

Common status values:
- `Running`: Normal operation (ready for operations)
- `Creating`: Still being created
- `Rebooting`: Restarting
- `DBNodeClassChanging`: Scaling in progress
- `NetAddressModifying`: Network address being modified
- `Deleting`: Being deleted (operations not allowed)
- `Restoring`: Restoring from backup

## Missing or invalid parameters

Symptoms:
- create-db-cluster fails with missing required params.

Actions:
- Ensure required parameters are provided:
  - `--cluster-network-type`: VPC
  - `--db-type`: PostgreSQL
  - `--db-version`: e.g., `14.0`
  - `--db-node-class`: e.g., `polar.pg.x4.medium` (required in most cases; follow CLI/API required list)
  - `--vpc-id`, `--vswitch-id`: Network configuration
- If the CLI says a parameter is required, check the CLI help output:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb create-db-cluster --help
```

## Invalid API name

Symptoms:
- CLI reports `is not a valid api`.

Actions:
- Use the CLI help to find the exact API name:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb --help
```

## Login blocked

Symptoms:
- Connection timeout or access denied from client.

Actions:
- Check whitelist; default often `127.0.0.1` only:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-db-cluster-access-whitelist --db-cluster-id <id>
```

- Update whitelist to include your IP:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-access-whitelist \
  --db-cluster-id <id> \
  --security-ips "<your-ip>"

- If whitelist is correct, also check endpoint type (VPC vs public), VPC routing/security groups, and SSL settings.
```

## Region or credentials missing

Symptoms:
- CLI reports `region can't be empty` or requires configure.

Actions:
- Set `ALICLOUD_REGION_ID` or pass `--region-id` explicitly.
- Ensure `ALICLOUD_ACCESS_KEY_ID` and `ALICLOUD_ACCESS_KEY_SECRET` are set.

## Throttling (Rate limit)

Symptoms:
- API returns `Throttling.User` or similar throttling errors.

Actions:
- Add retries with exponential backoff.
- Reduce request rate (especially in loops).
- If using multiple tools, stagger calls across regions.
- If throttling persists, open a support ticket and request quota increase.

Example retry policy:
- Max attempts: 5
- Backoff: 1s, 2s, 4s, 8s, 16s (with jitter)

## Deletion protection enabled

Symptoms:
- delete-db-cluster fails with deletion protection error.

Actions:
- Disable deletion protection first:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb modify-db-cluster-deletion \
  --db-cluster-id <id> \
  --deletion-lock 0
```

## Database already exists

Symptoms:
- create-database fails with `Database already exists`.

Actions:
- List existing databases first:

```bash
${ALIYUN_CLI_PATH:-aliyun} polardb describe-databases --db-cluster-id <id>
```
