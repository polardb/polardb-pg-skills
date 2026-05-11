High-frequency API parameter quick reference
==========================================

Source: OpenAPI metadata (2017-08-01). Always verify with official docs or CLI help output.

CLI check example:

```bash
aliyun polardb <ApiName> --help
```

Global common parameters (appear across many APIs):
- RegionId
- DBClusterId / DBNodeId / DBEndpointId
- PageNumber / PageSize / NextToken
- ResourceGroupId / Tag
- ClientToken

Common / inventory
------------------
DescribeRegions: (no parameters)
DescribeZones:
  Engine, RegionId, Extra
DescribeVpcs:
  ZoneId, Product, PageSize, PageNumber, ResourceGroupId, VpcId
DescribeVSwitches:
  RegionId, VpcId, ZoneId, DedicatedHostGroupId, PageNumber, PageSize, ResourceGroupId
DescribeDBClusters:
  RegionId, DBClusterIds, DBClusterDescription, ConnectionString, DBClusterStatus, DBType,
  DescribeType, DBVersion, RecentCreationInterval, RecentExpirationInterval, Expired, PageSize,
  PageNumber, ResourceGroupId, Tag, PayType, DBNodeIds
DescribeDBClusterAttribute:
  DBClusterId, DescribeType
DescribeDBClusterAvailableResources:
  PayType, DBType, DBVersion, DBNodeClass, RegionId, ZoneId

Cluster lifecycle
-----------------
CreateDBCluster:
  RegionId, ZoneId, Architecture, DBType, DBVersion, DBNodeClass, ClusterNetworkType,
  DBClusterDescription, PayType, AutoRenew, Period, UsedTime, VPCId, VSwitchId, CreationOption,
  SourceResourceId, CloneDataPoint, ClientToken, ResourceGroupId, SecurityIPList, TDEStatus, GDNId,
  CreationCategory, DefaultTimeZone, LowerCaseTableNames, BackupRetentionPolicyOnClusterDeletion,
  StorageSpace, DBMinorVersion, ParameterGroupId, Tag, ServerlessType, ScaleMin, ScaleMax,
  AllowShutDown, ScaleRoNumMin, ScaleRoNumMax, StorageType, DBNodeNum, HotStandbyCluster,
  StrictConsistency, StandbyAZ, ProxyType, ProxyClass, LoosePolarLogBin, LooseXEngine,
  LooseXEngineUseMemoryPct, StoragePayType, StorageAutoScale, StorageUpperBound, ProvisionedIops,
  BurstingEnabled, TargetMinorVersion, StorageEncryption, StorageEncryptionKey, SourceUid,
  CloudProvider, EnsRegionId, AutoUseCoupon, PromotionCode
ModifyDBCluster:
  DBClusterId, StandbyHAMode, DataSyncMode, FaultSimulateMode, StorageAutoScale, CompressStorage,
  StorageUpperBound, DBNodeCrashList, FaultInjectionType, ImciAutoIndex, TableMeta,
  ModifyRowCompression
DeleteDBCluster:
  CloudProvider, DBClusterId, BackupRetentionPolicyOnClusterDeletion
ModifyDBClusterDescription:
  DBClusterId, DBClusterDescription
ModifyDBClusterMaintainTime:
  DBClusterId, MaintainTime
ModifyDBClusterStorageSpace:
  DBClusterId, StorageSpace, ClientToken, PlannedStartTime, PlannedEndTime, SubCategory,
  CloudProvider, AutoUseCoupon, PromotionCode
ModifyDBClusterStoragePerformance:
  DBClusterId, ClientToken, ProvisionedIops, StorageType, BurstingEnabled, ModifyType, AutoUseCoupon,
  PromotionCode
RefreshDBClusterStorageUsage:
  SyncRealTime

Serverless
----------
DescribeDBClusterServerlessConf:
  DBClusterId
EnableDBClusterServerless:
  DBClusterId, ScaleMin, ScaleMax, ScaleRoNumMin, ScaleRoNumMax, ScaleApRoNumMin, ScaleApRoNumMax
DisableDBClusterServerless:
  DBClusterId
ModifyDBClusterServerlessConf:
  DBClusterId, ScaleMin, ScaleMax, ScaleRoNumMin, ScaleRoNumMax, AllowShutDown, SecondsUntilAutoPause,
  ScaleApRoNumMin, ScaleApRoNumMax, PlannedStartTime, PlannedEndTime, FromTimeService,
  ServerlessRuleCpuShrinkThreshold, ServerlessRuleCpuEnlargeThreshold, ServerlessRuleMode, TaskId,
  CrontabJobId
CreateCronJobPolicyServerless:
  DBClusterId, RegionId, CronExpression, ScaleMin, ScaleMax, ScaleRoNumMin, ScaleRoNumMax,
  AllowShutDown, SecondsUntilAutoPause, ScaleApRoNumMin, ScaleApRoNumMax,
  ServerlessRuleCpuEnlargeThreshold, ServerlessRuleCpuShrinkThreshold, ServerlessRuleMode,
  StartTime, EndTime
ModifyCronJobPolicyServerless:
  DBClusterId, RegionId, CronExpression, ScaleMin, ScaleMax, ScaleRoNumMin, ScaleRoNumMax,
  AllowShutDown, SecondsUntilAutoPause, ScaleApRoNumMin, ScaleApRoNumMax,
  ServerlessRuleCpuEnlargeThreshold, ServerlessRuleCpuShrinkThreshold, ServerlessRuleMode,
  StartTime, EndTime, JobId
DescribeCronJobPolicyServerless:
  DBClusterId, RegionId, JobId, PageSize, PageNumber
CancelCronJobPolicyServerless:
  DBClusterId, RegionId, JobId

Nodes
-----
CreateDBNodes:
  ResourceGroupId, DBClusterId, ClientToken, EndpointBindList, PlannedStartTime, PlannedEndTime,
  DBNode, DBNodeType, ImciSwitch, CloudProvider, AutoUseCoupon, PromotionCode
DeleteDBNodes:
  DBClusterId, ClientToken, DBNodeType, DBNodeId, CloudProvider
ModifyDBNodeClass:
  DBClusterId, ModifyType, DBNodeTargetClass, ClientToken, PlannedStartTime, PlannedEndTime,
  SubCategory, DBNodeType, PlannedFlashingOffTime, CloudProvider, AutoUseCoupon, PromotionCode
ModifyDBNodesClass:
  DBClusterId, ModifyType, DBNode, ClientToken, PlannedStartTime, PlannedEndTime, SubCategory,
  PlannedFlashingOffTime, CloudProvider, AutoUseCoupon, PromotionCode
ModifyDBNodeHotReplicaMode:
  DBClusterId, DBNodeId, HotReplicaMode
RestartDBNode:
  DBNodeId, PlannedStartTime, PlannedEndTime, FromTimeService, RegionId
TempModifyDBNode:
  ClientToken, DBClusterId, OperationType, ModifyType, DBNode, RestoreTime, AutoUseCoupon,
  PromotionCode
ModifyDBNodeDescription:
  DBClusterId, DBNodeDescription, DBNodeId
ModifyDBNodeConfig:
  DBClusterId, DBNodeId, ConfigName, ConfigValue
ModifyDBNodeSccMode:
  DBClusterId, DBNodeId, SccMode

Endpoint / connection
---------------------
DescribeDBClusterNetInfo:
  DBClusterId, ConnectionStringType
DescribeDBClusterEndpoints:
  DBClusterId, DBEndpointId, DescribeType, PolarFsInstanceId
CreateDBClusterEndpoint:
  DBClusterId, EndpointType, Nodes, ReadWriteMode, AutoAddNewNodes, EndpointConfig, ClientToken,
  DBEndpointDescription, SccMode, PolarSccWaitTimeout, PolarSccTimeoutAction, PolarFsInstanceId
ModifyDBClusterEndpoint:
  DBClusterId, DBEndpointId, Nodes, ReadWriteMode, AutoAddNewNodes, EndpointConfig,
  DBEndpointDescription, SccMode, PolarSccWaitTimeout, PolarSccTimeoutAction
DeleteDBClusterEndpoint:
  DBClusterId, DBEndpointId, PolarFsInstanceId
CreateDBEndpointAddress:
  DBClusterId, DBEndpointId, ConnectionStringPrefix, NetType, VPCId, SecurityGroupId, ZoneInfo
ModifyDBEndpointAddress:
  DBClusterId, DBEndpointId, NetType, ConnectionStringPrefix, PrivateZoneAddressPrefix,
  PrivateZoneName, Port
DeleteDBEndpointAddress:
  DBClusterId, DBEndpointId, NetType
DescribeDBClusterConnectivity:
  ResourceGroupId, DBClusterId, SourceIpAddress

Whitelist / security groups
---------------------------
DescribeDBClusterAccessWhitelist:
  DBClusterId
ModifyDBClusterAccessWhitelist:
  DBClusterId, SecurityIps, DBClusterIPArrayName, DBClusterIPArrayAttribute, WhiteListType,
  SecurityGroupIds, ModifyMode
CreateGlobalSecurityIPGroup:
  ResourceGroupId, RegionId, GlobalIgName, GIpList
DescribeGlobalSecurityIPGroup:
  ResourceGroupId, RegionId, GlobalSecurityGroupId
ModifyGlobalSecurityIPGroup:
  ResourceGroupId, RegionId, GlobalIgName, GlobalSecurityGroupId, GIpList
ModifyGlobalSecurityIPGroupName:
  RegionId, GlobalIgName, GlobalSecurityGroupId, ResourceGroupId
DeleteGlobalSecurityIPGroup:
  RegionId, GlobalIgName, GlobalSecurityGroupId, ResourceGroupId
DescribeGlobalSecurityIPGroupRelation:
  RegionId, DBClusterId, ResourceGroupId
ModifyGlobalSecurityIPGroupRelation:
  RegionId, DBClusterId, GlobalSecurityGroupId, ResourceGroupId

SSL / TDE / Firewall / Masking
------------------------------
DescribeDBClusterSSL:
  DBClusterId
ModifyDBClusterSSL:
  DBClusterId, SSLEnabled, DBEndpointId, NetType, SSLAutoRotate
CheckKMSAuthorized:
  RegionId, DBClusterId, TDERegion
DescribeDBClusterTDE:
  DBClusterId
ModifyDBClusterTDE:
  DBClusterId, TDEStatus, RoleArn, EncryptionKey, EncryptNewTables, EnableAutomaticRotation
EnableFirewallRules:
  DBClusterId, RuleNameList, Enable
DescribeFirewallRules:
  DBClusterId, RuleNameList
AddFirewallRules:
  DBClusterId, RuleName, RuleConfig, ResourceGroupId
ModifyFirewallRules:
  DBClusterId, RuleName, RuleConfig
DeleteFirewallRules:
  DBClusterId, RuleNameList
DescribeMaskingRules:
  DBClusterId, RuleNameList, InterfaceVersion
ModifyMaskingRules:
  DBClusterId, RuleName, RuleConfig, RuleNameList, Enable, RuleVersion, InterfaceVersion, MaskingAlgo,
  DefaultAlgo
DeleteMaskingRules:
  RuleNameList, DBClusterId, InterfaceVersion

Accounts & privileges
---------------------
CheckAccountName:
  DBClusterId, AccountName
CreateAccount:
  DBClusterId, AccountName, AccountPassword, AccountType, AccountDescription, DBName,
  AccountPrivilege, ClientToken, PrivForAllDB, NodeType
DescribeAccounts:
  DBClusterId, AccountName, NodeType, PageNumber, PageSize
ModifyAccountDescription:
  DBClusterId, AccountName, AccountDescription
ModifyAccountPassword:
  DBClusterId, AccountName, NewAccountPassword, PasswordType
ResetAccount:
  DBClusterId, AccountName, AccountPassword
ResetAccountPassword:
  DBClusterId, AccountName, AccountPassword
GrantAccountPrivilege:
  DBClusterId, AccountName, DBName, AccountPrivilege
RevokeAccountPrivilege:
  DBClusterId, AccountName, DBName
DeleteAccount:
  DBClusterId, AccountName
ModifyAccountLockState:
  DBClusterId, AccountName, AccountLockState, AccountPasswordValidTime

Databases & extensions
----------------------
CheckDBName:
  DBClusterId, DBName
CreateDatabase:
  DBClusterId, DBName, CharacterSetName, DBDescription, AccountName, AccountPrivilege, Collate, Ctype
DescribeDatabases:
  DBClusterId, DBName, PageNumber, PageSize
ModifyDBDescription:
  DBClusterId, DBName, DBDescription
DeleteDatabase:
  DBClusterId, DBName
CreateExtensions:
  ResourceGroupId, DBClusterId, Extensions, DBNames, AccountName, SourceDBName, VpcId, RegionId,
  ClientToken
DescribeExtensions:
  DBClusterId, DBName, ExtensionName
UpdateExtensions:
  ResourceGroupId, DBClusterId, Extensions, DBNames, VpcId, RegionId, ClientToken
DeleteExtensions:
  ResourceGroupId, DBClusterId, Extensions, DBNames, VpcId, RegionId, ClientToken

Parameters
----------
DescribeDBClusterParameters:
  DBClusterId, DescribeType
DescribeDBNodesParameters:
  DBClusterId, DBNodeIds
ModifyDBClusterParameters:
  DBClusterId, Parameters, ParameterGroupId, PlannedStartTime, PlannedEndTime, FromTimeService,
  ClearBinlog
ModifyDBNodesParameters:
  DBClusterId, DBNodeIds, Parameters, ParameterGroupId, PlannedStartTime, PlannedEndTime,
  FromTimeService
ModifyDBClusterAndNodesParameters:
  DBClusterId, DBNodeIds, Parameters, ParameterGroupId, PlannedStartTime, PlannedEndTime,
  FromTimeService, ClearBinlog, StandbyClusterIdListNeedToSync
CreateParameterGroup:
  RegionId, DBType, DBVersion, ParameterGroupName, ParameterGroupDesc, Parameters, ResourceGroupId
DescribeParameterGroups:
  RegionId, DBType, DBVersion, ResourceGroupId
DescribeParameterGroup:
  RegionId, DBType, ParameterGroupId, ResourceGroupId
DescribeParameterTemplates:
  DBType, DBVersion, RegionId, ResourceGroupId
DeleteParameterGroup:
  RegionId, ParameterGroupId, ResourceGroupId
DescribeModifyParameterLog:
  DBClusterId, EndTime, StartTime

Backup & restore
----------------
CreateBackup:
  DBClusterId, ClientToken
DescribeBackups:
  DBClusterId, BackupId, BackupStatus, BackupMode, StartTime, EndTime, BackupRegion, PageSize,
  PageNumber
DescribeBackupTasks:
  DBClusterId, BackupJobId, BackupMode
DescribeBackupLogs:
  DBClusterId, StartTime, EndTime, BackupRegion, PageSize, PageNumber
DescribeDetachedBackups:
  DBClusterId, BackupId, BackupStatus, BackupMode, BackupRegion, StartTime, EndTime, PageSize,
  PageNumber
DeleteBackup:
  DBClusterId, BackupId
DescribeBackupPolicy:
  DBClusterId
ModifyBackupPolicy:
  DBClusterId, PreferredBackupTime, PreferredBackupPeriod, DataLevel1BackupRetentionPeriod,
  DataLevel2BackupRetentionPeriod, BackupRetentionPolicyOnClusterDeletion, BackupFrequency,
  DataLevel1BackupFrequency, DataLevel1BackupTime, DataLevel1BackupPeriod, DataLevel2BackupPeriod,
  DataLevel2BackupAnotherRegionRegion, DataLevel2BackupAnotherRegionRetentionPeriod,
  BackupPolicyLevel, AdvancedDataPolicies
DescribeLogBackupPolicy:
  DBClusterId
ModifyLogBackupPolicy:
  DBClusterId, LogBackupRetentionPeriod, LogBackupAnotherRegionRegion,
  LogBackupAnotherRegionRetentionPeriod, AdvancedLogPolicies
DescribeLocalAvailableRecoveryTime:
  DBClusterId
RestoreTable:
  DBClusterId, TableMeta, BackupId, RestoreTime
DescribeMetaList:
  DBClusterId, BackupId, RestoreTime, GetDbName, PageSize, PageNumber, RegionCode
ReactivateDBClusterBackup:
  DBClusterId
DescribeDBClustersWithBackups:
  ResourceGroupId, RegionId, DBClusterIds, DBClusterDescription, DBType, IsDeleted, PageSize,
  PageNumber, DBVersion

GDN / global network
--------------------
CreateGlobalDatabaseNetwork:
  DBClusterId, GDNDescription, ResourceGroupId, GDNVersion, EnableGlobalDomainName
DescribeGlobalDatabaseNetwork:
  GDNId, ResourceGroupId
DescribeGlobalDatabaseNetworks:
  FilterRegion, DBClusterId, PageSize, PageNumber, GDNDescription, GDNId, ResourceGroupId
ModifyGlobalDatabaseNetwork:
  GDNId, GDNDescription, EnableGlobalDomainName, ResourceGroupId
RemoveDBClusterFromGDN:
  DBClusterId, GDNId, Force, TargetDBClusterId
SwitchOverGlobalDatabaseNetwork:
  RegionId, DBClusterId, GDNId, Forced, ResourceGroupId
ResetGlobalDatabaseNetwork:
  RegionId, GDNId, DBClusterId

Monitoring & logs
-----------------
DescribeDBClusterPerformance:
  DBClusterId, Type, Key, StartTime, EndTime, Interval, SubGroupName
DescribeDBNodePerformance:
  DBNodeId, Interval, Type, Key, StartTime, EndTime, DBClusterId
DescribeDBProxyPerformance:
  DBClusterId, DBEndpointId, Interval, Type, Key, StartTime, EndTime, DBNodeId
DescribeDBClusterMonitor:
  DBClusterId
ModifyDBClusterMonitor:
  DBClusterId, Period
DescribeSlowLogs:
  RegionId, DBClusterId, StartTime, EndTime, DBName, PageSize, PageNumber
DescribeSlowLogRecords:
  RegionId, DBClusterId, NodeId, StartTime, EndTime, DBName, PageSize, PageNumber, SQLHASH
DescribeDBClusterAuditLogCollector:
  DBClusterId
ModifyDBClusterAuditLogCollector:
  DBClusterId, CollectorStatus
DescribeHALogs:
  DBClusterId, DBNodeId, PageNumber, PageSize, StartTime, EndTime, LogType
DescribeDBLogFiles:
  DBClusterId, DBNodeId, PageNumber, PageSize, StartTime, EndTime, LogType,
  DescribeSimulateSwitchMode, SimulateListId, SimulateStatusList, SimulateModeList
DescribeDBInstancePerformance:
  DBInstanceId, Key, StartTime, EndTime

Tasks & maintenance
-------------------
DescribeTasks:
  DBClusterId, DBNodeId, StartTime, EndTime, Status, PageSize, PageNumber
DescribeScheduleTasks:
  Status, DBClusterId, RegionId, PageNumber, PageSize, TaskAction, DBClusterDescription, OrderId,
  PlannedStartTime, PlannedEndTime, ResourceGroupId
CancelScheduleTasks:
  DBClusterId, TaskId, ResourceGroupId
DescribePendingMaintenanceAction:
  Region, TaskType, IsHistory, PageSize, PageNumber, ResourceGroupId
DescribePendingMaintenanceActions:
  RegionId, IsHistory, ResourceGroupId
ModifyPendingMaintenanceAction:
  RegionId, Ids, SwitchTime, ResourceGroupId
DescribeActiveOperationTasks:
  RegionId, TaskType, PageSize, PageNumber, DBType, Status, DBClusterId, AllowChange, AllowCancel,
  ChangeLevel
ModifyActiveOperationTasks:
  RegionId, TaskIds, SwitchTime, ImmediateStart
CancelActiveOperationTasks:
  RegionId, TaskIds
ModifyScheduleTask:
  DBClusterId, TaskId, ResourceGroupId, PlannedStartTime, PlannedEndTime
DescribeHistoryTasks:
  RegionId, PageSize, PageNumber, InstanceType, Status, InstanceId, TaskId, TaskType, FromStartTime,
  ToStartTime, FromExecTime, ToExecTime, ResourceGroupId
DescribeHistoryTasksStat:
  RegionId, Status, InstanceId, TaskId, TaskType, FromStartTime, ToStartTime, FromExecTime,
  ToExecTime, ResourceGroupId
DescribeHistoryEvents:
  PageSize, PageNumber, ArchiveStatus, EventCategory, EventType, EventLevel, EventStatus,
  ResourceType, InstanceId, EventId, TaskId, FromStartTime, ToStartTime, ResourceGroupId, RegionId
DescribeActiveOperationMaintainConf:
  RegionId, ResourceGroupId
ModifyActiveOperationMaintainConf:
  RegionId, CycleType, CycleTime, MaintainStartTime, MaintainEndTime, Status, Comment, ResourceGroupId

HA / version / arch
-------------------
ModifyDBClusterPrimaryZone:
  DBClusterId, ZoneId, ZoneType, VSwitchId, IsSwitchOverForDisaster, PlannedStartTime, PlannedEndTime,
  FromTimeService, VPCId
FailoverDBCluster:
  DBClusterId, TargetDBNodeId, RollBackForDisaster, ClientToken, TargetZoneType
ModifyDBClusterArch:
  DBClusterId, HotStandbyCluster, RegionId, StandbyAZ, AutoUseCoupon, PromotionCode
DescribeDBClusterVersion:
  DBClusterId, DescribeType
UpgradeDBClusterVersion:
  DBClusterId, UpgradePolicy, UpgradeLabel, PlannedStartTime, PlannedEndTime, FromTimeService,
  UpgradeType, TargetDBRevisionVersionCode, TargetProxyRevisionVersionCode
DescribeUpgradeReport:
  RegionId, SourceDBClusterId, DBType, DBVersion, TaskId, PageNumber, PageSize, Status, Type,
  CreationCategory
GenerateUpgradeReportForSyncClone:
  DBType, DBName, RegionId, SourceDBClusterId, DBVersion, CreationOption, CreationCategory, Reserve

Tags / resource group
---------------------
TagResources:
  RegionId, ResourceType, ResourceId, Tag
UntagResources:
  RegionId, ResourceType, All, ResourceId, TagKey
ListTagResources:
  RegionId, ResourceType, NextToken, ResourceId, Tag
ListTagResourcesForRegion:
  RegionId, NextToken, ResourceType
ModifyDBClusterResourceGroup:
  ResourceGroupId, DBClusterId, NewResourceGroupId

DBLink
------
CreateDBLink:
  ResourceGroupId, DBClusterId, DBLinkName, TargetDBInstanceName, TargetDBAccount, TargetDBPasswd,
  TargetDBName, SourceDBName, TargetIp, TargetPort, VpcId, RegionId, ClientToken
RestartDBLink:
  DBClusterId
DeleteDBLink:
  DBClusterId, DBLinkName
DescribeDBLinks:
  DBClusterId, DBLinkName

Cold storage
------------
CreateColdStorageInstance:
  ResourceGroupId, DBClusterId, ColdStorageInstanceDescription, ClientToken
DescribeColdStorageInstance:
  DBClusterId, NextToken, TableName, DBName, EngineType, RegionId, MaxResults, ExpireTime, PageNumber,
  PageSize, ObjectType

PolarDB for AI
--------------
OpenAITask:
  ResourceGroupId, DBClusterId, Username, Password, NodeType, RegionId
CloseAITask:
  RegionId, DBClusterId
DescribeAITaskStatus:
  RegionId, DBClusterId
DescribeAIDBClusters:
  DBClusterIds, PageSize, PageNumber, DBClusterDescription, DBClusterStatus, PayType, RegionId,
  AiNodeType, Tag
DescribeAIDBClusterAttribute:
  DBClusterId
DescribeAIDBClusterPerformance:
  DBClusterId, Key, StartTime, EndTime, Interval
CreateAINodes:
  DBClusterId, DBNodes
DeleteAINodes:
  DBClusterId, DBNodeId
DescribeAIDBClusterTaskLogFiles:
  DBClusterId, RelativeDBClusterId, PageSize, PageNumber, StartTime, EndTime, Reverse, LogType
DescribeAIDBClusterTaskMetrics:
  DBClusterId, RelativeDBClusterId, PageSize, PageNumber, StartTime, EndTime, Reverse, MetricType

Applications
------------
DescribeApplications:
  RegionId, ApplicationIds, PageSize, PageNumber, DBClusterId, ApplicationTypes, Tag
CreateApplication:
  Description, ApplicationType, DBClusterId, RegionId, ZoneId, VSwitchId, Architecture, Endpoints,
  Components, PayType, AutoRenew, Period, UsedTime, ResourceGroupId, DryRun, PolarFSInstanceId,
  VpcId, AutoCreatePolarFs, AutoUseCoupon, PromotionCode, SecurityGroupId, MemApplicationSpec
DescribeApplicationAttribute:
  ApplicationId
DescribeApplicationParameters:
  ApplicationId, ComponentIdList
ModifyApplicationParameter:
  ApplicationId, ParameterName, ParameterValue, Parameters
ModifyApplicationDescription:
  ApplicationId, Description
ModifyApplicationWhitelist:
  ApplicationId, ComponentId, SecurityIPList, SecurityIPArrayName, SecurityGroups, ModifyMode
CreateApplicationEndpointAddress:
  ApplicationId, EndpointId, NetType
DeleteApplicationEndpointAddress:
  ApplicationId, EndpointId, NetType
AttachApplicationPolarFS:
  ApplicationId, PolarFSInstanceId, PolarFSAccessKeyId, PolarFSAccessKeySecret
DeleteApplication:
  ApplicationId
DescribeApplicationServerlessConf:
  ApplicationId
ModifyApplicationServerlessConf:
  ApplicationId, ServerlessConfList
