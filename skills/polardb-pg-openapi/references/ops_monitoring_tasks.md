# Ops, monitoring, and tasks

Use CLI to validate required params:

```bash
aliyun polardb <ApiName> --help
```

## Monitoring

- DescribeDBClusterPerformance
- DescribeDBNodePerformance
- DescribeDBProxyPerformance
- DescribeDBClusterMonitor
- ModifyDBClusterMonitor

Common parameters:
- DBClusterId / DBNodeId / DBEndpointId
- Type / Key
- StartTime / EndTime / Interval

## Logs

- DescribeSlowLogs
- DescribeSlowLogRecords
- DescribeDBClusterAuditLogCollector
- ModifyDBClusterAuditLogCollector
- DescribeDBLogFiles
- DescribeHALogs

Common parameters:
- DBClusterId
- StartTime / EndTime
- PageNumber / PageSize

## Tasks and maintenance

- DescribeTasks
- DescribeScheduleTasks
- CancelScheduleTasks
- DescribePendingMaintenanceAction
- DescribePendingMaintenanceActions
- ModifyPendingMaintenanceAction
- DescribeActiveOperationTasks
- ModifyActiveOperationTasks
- CancelActiveOperationTasks
- DescribeHistoryTasks
- DescribeHistoryTasksStat
- DescribeHistoryEvents
- DescribeActiveOperationMaintainConf
- ModifyActiveOperationMaintainConf

Common parameters:
- RegionId
- DBClusterId
- TaskId / TaskIds
- PlannedStartTime / PlannedEndTime
- Status
- PageNumber / PageSize
