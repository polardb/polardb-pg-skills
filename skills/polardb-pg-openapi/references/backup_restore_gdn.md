# Backup, restore, and GDN

Always validate parameter requirements with OpenAPI docs or CLI help:

```bash
aliyun polardb <ApiName> --help
```

## Backups

- CreateBackup
- DescribeBackups
- DescribeBackupTasks
- DescribeBackupLogs
- DescribeDetachedBackups
- DeleteBackup
- ReactivateDBClusterBackup
- DescribeDBClustersWithBackups

Typical parameters:
- DBClusterId
- BackupId / BackupStatus / BackupMode
- StartTime / EndTime
- PageNumber / PageSize

## Backup policies

- DescribeBackupPolicy
- ModifyBackupPolicy
- DescribeLogBackupPolicy
- ModifyLogBackupPolicy

Common parameters:
- DBClusterId
- PreferredBackupTime / PreferredBackupPeriod
- BackupRetentionPolicyOnClusterDeletion
- LogBackupRetentionPeriod

## Table restore

- DescribeMetaList
- RestoreTable
- DescribeLocalAvailableRecoveryTime

Common parameters:
- DBClusterId
- BackupId / RestoreTime
- TableMeta

## Global Database Network (GDN)

- CreateGlobalDatabaseNetwork
- DescribeGlobalDatabaseNetwork
- DescribeGlobalDatabaseNetworks
- ModifyGlobalDatabaseNetwork
- RemoveDBClusterFromGDN
- SwitchOverGlobalDatabaseNetwork
- ResetGlobalDatabaseNetwork

Common parameters:
- GDNId
- DBClusterId
- ResourceGroupId
- RegionId
