# Security and network operations

This note summarizes security and network related APIs for PolarDB (PostgreSQL). Always confirm
required parameters and constraints with the OpenAPI docs or Aliyun CLI help:

```bash
aliyun polardb <ApiName> --help
```

## Whitelist / Security IPs

- DescribeDBClusterAccessWhitelist
- ModifyDBClusterAccessWhitelist

Key parameters seen in metadata:
- DBClusterId
- SecurityIps
- DBClusterIPArrayName
- DBClusterIPArrayAttribute
- WhiteListType
- SecurityGroupIds
- ModifyMode

## Global security IP group

- CreateGlobalSecurityIPGroup
- DescribeGlobalSecurityIPGroup
- ModifyGlobalSecurityIPGroup
- ModifyGlobalSecurityIPGroupName
- DeleteGlobalSecurityIPGroup
- DescribeGlobalSecurityIPGroupRelation
- ModifyGlobalSecurityIPGroupRelation

Common parameters:
- RegionId
- GlobalSecurityGroupId / GlobalIgName
- GIpList
- DBClusterId
- ResourceGroupId

## Endpoint / connection address

- DescribeDBClusterNetInfo
- DescribeDBClusterEndpoints
- CreateDBClusterEndpoint
- ModifyDBClusterEndpoint
- DeleteDBClusterEndpoint
- CreateDBEndpointAddress
- ModifyDBEndpointAddress
- DeleteDBEndpointAddress
- DescribeDBClusterConnectivity

Common parameters:
- DBClusterId / DBEndpointId
- NetType / ConnectionStringPrefix
- VPCId / SecurityGroupId / ZoneInfo
- SourceIpAddress (connectivity test)

## SSL / TDE

- DescribeDBClusterSSL
- ModifyDBClusterSSL
- CheckKMSAuthorized
- DescribeDBClusterTDE
- ModifyDBClusterTDE

Common parameters:
- DBClusterId
- SSLEnabled / SSLAutoRotate
- TDEStatus / RoleArn / EncryptionKey / EncryptNewTables

## SQL firewall

- EnableFirewallRules
- DescribeFirewallRules
- AddFirewallRules
- ModifyFirewallRules
- DeleteFirewallRules

Common parameters:
- DBClusterId
- RuleName / RuleNameList
- RuleConfig

## Data masking rules

- DescribeMaskingRules
- ModifyMaskingRules
- DeleteMaskingRules

Common parameters:
- DBClusterId
- RuleName / RuleNameList
- RuleConfig
- InterfaceVersion
