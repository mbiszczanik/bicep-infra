/*
SUMMARY: Key Vault resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param keyVault_Name string
param keyVault_Location string = resourceGroup().location
param tags object
param keyVault_EnabledForDeployment bool = true
param keyVault_EnabledForTemplateDeployment bool = true
param keyVault_EnabledForDiskEncryption bool = true
param keyVault_TenantId string = tenant().tenantId


param keyVault_SkuName string = 'standard'
param keyVault_SkuFamily string = 'A'

@allowed([
  'AzureServices'
  'None'
])
param keyVault_NetworkAclsBypass string = 'AzureServices'

param keyVault_ObjectId string
param keyVault_KeysPermissions array = []
param keyVault_SecretsPermissions array = []


//////////////////////////////////  RESOURCES //////////////////////////////////
resource keyVault 'Microsoft.KeyVault/vaults@2023-02-01' = {
  name: keyVault_Name
  location: keyVault_Location
  tags: tags
  properties: {
    enabledForDeployment: keyVault_EnabledForDeployment
    enabledForTemplateDeployment: keyVault_EnabledForTemplateDeployment
    enabledForDiskEncryption: keyVault_EnabledForDiskEncryption
    tenantId: keyVault_TenantId
    sku: {
      name: keyVault_SkuName
      family: keyVault_SkuFamily
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: keyVault_NetworkAclsBypass
    }
    accessPolicies: [
      {
        tenantId: keyVault_TenantId
        objectId: keyVault_ObjectId
        permissions: {
          keys: keyVault_KeysPermissions
          secrets: keyVault_SecretsPermissions
        }
      }
    ]
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////

