API overview (PolarDB 2017-08-01)
=================================

Source: OpenAPI metadata (api-docs.json). This is a quick index of API groups and names.

Directories
-----------
售卖管理
----
- CreateStoragePlan
- DescribeAutoRenewAttribute
- DescribeClassList
- DescribeDBClusterAvailableResources
- EvaluateRegionResource
- ModifyAutoRenewAttribute
- TransformDBClusterPayType

集群管理
----
- CreateDBCluster
- DeleteDBCluster
- DescribeDBClusters
- DescribeDBClusterAttribute
- DescribeDBClusterServerlessConf
- DescribePolarSQLCollectorPolicy
- DescribeRegions
- DescribeTasks
- DescribeVSwitches
- ModifyDBCluster
- ModifyDBClusterDescription
- ModifyDBClusterDeletion
- ModifyDBClusterMaintainTime
- EnableDBClusterServerless
- DisableDBClusterServerless
- ModifyDBClusterServerlessConf
- ModifyDBClusterStorageSpace
- ManuallyStartDBCluster
- ModifyDBClusterStoragePerformance
- RefreshDBClusterStorageUsage
- ModifyDBClusterResourceGroup
- DescribeDasConfig

高可用部署架构
-------
- ModifyDBClusterPrimaryZone
- FailoverDBCluster
- ModifyDBClusterArch

内核版本管理
------
- DescribeDBClusterVersion
- UpgradeDBClusterVersion

白名单管理
-----
- DescribeDBClusterAccessWhitelist
- ModifyDBClusterAccessWhitelist

全局IP白名单模板管理
-----------
- CreateGlobalSecurityIPGroup
- DeleteGlobalSecurityIPGroup
- DescribeGlobalSecurityIPGroup
- DescribeGlobalSecurityIPGroupRelation
- ModifyGlobalSecurityIPGroup
- ModifyGlobalSecurityIPGroupName
- ModifyGlobalSecurityIPGroupRelation

SSL 加密
------
- DescribeDBClusterSSL
- ModifyDBClusterSSL

TDE加密
-----
- CheckKMSAuthorized
- DescribeDBClusterTDE
- DescribeUserEncryptionKeyList
- ModifyDBClusterTDE

SQL防火墙
------
- EnableFirewallRules

节点管理
----
- CreateDBNodes
- DeleteDBNodes
- ModifyDBNodeClass
- ModifyDBNodesClass
- ModifyDBNodeHotReplicaMode
- RestartDBNode
- TempModifyDBNode
- TempModifyDBNode

参数管理
----
- CreateParameterGroup
- DescribeDBClusterParameters
- DescribeDBNodesParameters
- DescribeParameterTemplates
- DescribeParameterGroups
- DescribeParameterGroup
- DeleteParameterGroup
- ModifyDBClusterAndNodesParameters
- ModifyDBClusterParameters
- ModifyDBNodesParameters

访问地址管理
------
- CreateDBClusterEndpoint
- CreateDBEndpointAddress
- DescribeDBClusterEndpoints
- ModifyDBClusterEndpoint
- ModifyDBEndpointAddress
- DeleteDBClusterEndpoint
- DeleteDBEndpointAddress

日志管理
----
- DescribeSlowLogRecords
- DescribeSlowLogs
- DescribeDBClusterAuditLogCollector
- ModifyDBClusterAuditLogCollector

账号管理
----
- CreateAccount
- CheckAccountName
- DescribeAccounts
- ModifyAccountDescription
- GrantAccountPrivilege
- RevokeAccountPrivilege
- ResetAccount
- DeleteAccount
- ModifyAccountPassword

数据库管理
-----
- CreateDatabase
- DeleteDatabase
- DescribeDatabases
- DescribeCharacterSetName
- CheckDBName
- DescribeDBInitializeVariable
- ModifyDBDescription

全球数据库网络（GDN）
------------
- CreateGlobalDatabaseNetwork
- DeleteGlobalDatabaseNetwork
- DescribeGlobalDatabaseNetwork
- DescribeGlobalDatabaseNetworks
- ModifyGlobalDatabaseNetwork
- RemoveDBClusterFromGDN
- SwitchOverGlobalDatabaseNetwork
- ResetGlobalDatabaseNetwork

备份管理
----
- CreateBackup
- DescribeBackups
- DescribeBackupTasks
- DescribeBackupLogs
- DescribeDetachedBackups
- DescribeDBClustersWithBackups
- DeleteBackup
- ReactivateDBClusterBackup
- DescribeBackupPolicy
- DescribeLogBackupPolicy
- ModifyBackupPolicy
- ModifyLogBackupPolicy

库表恢复
----
- DescribeMetaList
- RestoreTable

从RDS迁移
------
- DescribeDBClusterMigration
- ModifyDBClusterMigration
- CloseDBClusterMigration

标签管理
----
- TagResources
- UntagResources
- ListTagResources

待处理事件管理
-------
- DescribePendingMaintenanceAction
- DescribePendingMaintenanceActions
- ModifyPendingMaintenanceAction
- ModifyActiveOperationTasks
- DescribeActiveOperationTasks
- CancelActiveOperationTasks

计划任务管理
------
- DescribeScheduleTasks
- CancelScheduleTasks

脱敏规则管理
------
- DescribeMaskingRules
- ModifyMaskingRules
- DeleteMaskingRules

监控管理
----
- DescribeDBNodePerformance
- DescribeDBClusterPerformance
- DescribeDBProxyPerformance
- DescribeDBClusterMonitor
- ModifyDBClusterMonitor

PolarDB for AI
--------------
- DescribeAITaskStatus
- OpenAITask
- CloseAITask

DBLink
------
- CreateDBLink
- RestartDBLink
- DeleteDBLink
- DescribeDBLinks

连接诊断
----
- DescribeDBClusterConnectivity

冷数据归档
-----
- CreateColdStorageInstance

PolarDB应用
---------
- DescribeApplications
- CreateApplication
- DescribeApplicationAttribute
- DescribeApplicationParameters
- ModifyApplicationParameter
- ModifyApplicationDescription
- ModifyApplicationWhitelist
- CreateApplicationEndpointAddress
- DeleteApplicationEndpointAddress
- AttachApplicationPolarFS
- DeleteApplication

边缘集群
----
- UpgradeDBClusterVersionZonal
- CreateAccountZonal
- RestartDBNodeZonal
- DescribeAccountsZonal
- DeleteDBClusterEndpointZonal
- CreateDatabaseZonal
- GrantAccountPrivilegeZonal
- ModifyDBDescriptionZonal
- CheckDBNameZonal
- DescribeDBClusterVersionZonal
- ModifyDBClusterEndpointZonal
- ModifyAccountPasswordZonal
- DeleteAccountZonal
- ModifyAccountDescriptionZonal
- ResetAccountZonal
- CreateDBClusterEndpointZonal
- RevokeAccountPrivilegeZonal
- ModifyDBClusterDescriptionZonal
- DescribeDatabasesZonal
- DescribeDBClusterEndpointsZonal
- DeleteDatabaseZonal
- FailoverDBClusterZonal
- DescribeDbClusterAttributeZonal
- CheckAccountNameZonal
- DescribeDBClustersZonal

其他
--
- DescribeActivationCodes
- AddPolarFsQuota
- DescribeLicenseOrderDetails
- CancelPolarFsFileQuota
- DescribeLicenseOrders
- DeletePolarFsQuota
- AbortDBClusterMigration
- DescribeApplicationServerlessConf
- CreateOrGetVirtualLicenseOrder
- DescribePolarFsAttribute
- CreateActivationCode
- DescribePolarFsQuota
- DescribeActivationCodeDetails
- ModifyApplicationServerlessConf
- AddEncryptionDBRolePrivilege
- SetPolarFsFileQuota
- CreateGlobalDataNetwork
- AddFirewallRules
- DescribeGlobalDataNetworkList
- DeleteGlobalDataNetwork
- DescribeHistoryTasks
- AddSQLRateLimitingRules
- DescribeHALogs
- DescribeAIDBClusterPerformance
- CreateServiceLinkedRole
- CheckServiceLinkedRole
- ModifyDBNodeDescription
- DescribeBackupRegions
- CancelCronJobPolicyServerless
- CheckConnectionString
- ContinueDBClusterMigration
- CreateCronJobPolicyServerless
- CreateExtensions
- CreateNetworkChannel
- DeleteAIDBCluster
- DeleteEncryptionDBRolePrivilege
- DeleteExtensions
- DeleteFirewallRules
- DeleteNetworkChannel
- DeleteSQLRateLimitingRules
- DescribeAIDBClusterAttribute
- DescribeAIDBClusters
- DescribeActiveOperationMaintainConf
- DescribeAvailableCrossRegions
- DescribeColdStorageInstance
- DescribeCronJobPolicyServerless
- DescribeCrossCloudLevels
- DescribeCrossCloudRegion
- DescribeCrossCloudRegionMappingToAliyun
- DescribeDBClusterEncryptionKey
- DescribeDBClusterNetInfo
- DescribeDBClusterProxy
- DescribeDBInstancePerformance
- DescribeDBLogFiles
- DescribeDBMiniEngineVersions
- DescribeEncryptionDBRolePrivilege
- DescribeEncryptionDBSecret
- DescribeExtensions
- DescribeFirewallRules
- DescribeHistoryTasksStat
- DescribeLocalAvailableRecoveryTime
- DescribeModifyParameterLog
- DescribeNetworkChannel
- DescribeRdsVSwitchs
- DescribeRdsVpcs
- DescribeResourcePackages
- DescribeSQLRateLimitingRules
- DescribeUpgradeReport
- DescribeVSwitchList
- DescribeVpcs
- DescribeZones
- DisableDBClusterOrca
- EnableDBClusterOrca
- EnableSQLRateLimitingRules
- ExecuteCrossCloudOpenAPI
- GenerateUpgradeReportForSyncClone
- ListOrders
- ListTagResourcesForRegion
- ModifyAIDBClusterDescription
- ModifyAccountLockState
- ModifyActiveOperationMaintainConf
- ModifyCronJobPolicyServerless
- ModifyDBClusterMigrationEndpoint
- ModifyDBClusterVpc
- ModifyDBNodeConfig
- ModifyDBNodeSccMode
- ModifyEncryptionDBRolePrivilege
- ModifyEncryptionDBSecret
- ModifyFirewallRules
- ModifyResourcePackage
- ModifySQLRateLimitingRules
- ModifyScheduleTask
- ResetAccountPassword
- UpdateExtensions
- DisableDBClusterDynamoDB
- EnableDBClusterDynamoDB

其它
--
- DescribeHistoryEvents
- DeleteAINodes
- CreateAINodes
- ClonePolarFsBasicSnapshot
- DescribeAIDBClusterTaskLogFiles
- DescribeAIDBClusterTaskMetrics
- DescribePolarAgentUserSessions
- DescribePolarAgentChatRecords
- GetPolarAgent
- DescribePolarAgentSessionStatus
