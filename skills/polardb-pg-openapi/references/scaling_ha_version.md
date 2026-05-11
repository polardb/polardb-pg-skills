# Scaling, HA, and version management

Verify parameters and constraints with CLI help:

```bash
aliyun polardb <ApiName> --help
```

## Node scaling / class changes

- CreateDBNodes
- DeleteDBNodes
- ModifyDBNodeClass
- ModifyDBNodesClass
- TempModifyDBNode

Common parameters:
- DBClusterId
- DBNode / DBNodeId / DBNodeType
- ModifyType
- PlannedStartTime / PlannedEndTime

## Storage scaling

- ModifyDBClusterStorageSpace
- ModifyDBClusterStoragePerformance
- RefreshDBClusterStorageUsage

Common parameters:
- DBClusterId
- StorageSpace
- ProvisionedIops / StorageType

## Serverless

- DescribeDBClusterServerlessConf
- EnableDBClusterServerless
- DisableDBClusterServerless
- ModifyDBClusterServerlessConf
- CreateCronJobPolicyServerless
- ModifyCronJobPolicyServerless
- DescribeCronJobPolicyServerless
- CancelCronJobPolicyServerless

## HA architecture and failover

- ModifyDBClusterPrimaryZone
- FailoverDBCluster
- ModifyDBClusterArch

Common parameters:
- DBClusterId
- ZoneId / VSwitchId / VPCId
- PlannedStartTime / PlannedEndTime

## Version upgrade

- DescribeDBClusterVersion
- UpgradeDBClusterVersion
- DescribeUpgradeReport
- GenerateUpgradeReportForSyncClone

Common parameters:
- DBClusterId
- UpgradePolicy / UpgradeType
- PlannedStartTime / PlannedEndTime
