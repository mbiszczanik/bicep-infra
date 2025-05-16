/*
SUMMARY: Linux Virtual Machine resource
DESCRIPTION: Deploys a simple Linux VM with optional Azure AD login and configurable disk, image, and network settings.
AUTHOR/S: Marcin Biszczanik
VERSION: 1.2
*/

/*******************
*   Target Scope   *
*******************/
targetScope = 'resourceGroup'

/*******************
*    Parameters    *
*******************/

@description('The name of the Virtual Machine.')
param parVmName string

@description('The Azure region for the Virtual Machine.')
param parLocation string = resourceGroup().location

@description('Tags to be applied to the Virtual Machine.')
param parTags object = {}

@description('The size of the Virtual Machine.')
param parVmSize string

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'StandardSSD_LRS'
  'StandardSSD_ZRS'
  'Standard_LRS'
  'UltraSSD_LRS'
])
@description('The SKU for the OS disk. Default is Premium_LRS.')
param parOsDiskSkuName string = 'Premium_LRS'

@description('The image reference for the Virtual Machine.')
param parImageReference object = {
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}

@description('The admin username for the Virtual Machine.')
param parAdminName string

@secure()
@description('The admin password for the Virtual Machine.')
param parAdminPassword string

@allowed([
  'ImageDefault'
  'AutomaticByPlatform'
])
@description('The patch mode for the Linux VM. Default is ImageDefault.')
param parPatchMode string = 'ImageDefault'

@description('Optional. The private IP address for the VM network interface.')
param parPrivateIpAddress string = ''

@description('The subnet resource ID for the VM network interface.')
param parSubnetId string

@description('Enable Azure AD login for the VM.')
param parAadLoginEnable bool = false

@description('The name of the Azure AD login extension.')
param parAadLoginExtensionName string = 'AADSSHLoginForLinux'

/*******************
*    Variables     *
*******************/

var varNicName = '${parVmName}-NIC'
var varNsgName = '${parVmName}-NSG'
var varOsDiskName = '${parVmName}-OSDisk'

/*******************
*    Resources     *
*******************/

resource resVmNsg 'Microsoft.Network/networkSecurityGroups@2024-05-01' = {
  name: varNsgName
  location: parLocation
  tags: parTags
}

module modVmNic '../network/networkInterface.bicep' = {
  name: varNicName
  params: {
    networkInterface_Name: varNicName
    networkInterface_NetworkSecurityGroupId: resVmNsg.id
    networkInterface_PrivateIpAddress: parPrivateIpAddress
    networkInterface_SubnetId: parSubnetId
    tags: parTags
    networkInterface_Location: parLocation
  }
}

resource resVm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: parVmName
  location: parLocation
  tags: parTags
  properties: {
    hardwareProfile: {
      vmSize: parVmSize
    }
    storageProfile: {
      osDisk: {
        name: varOsDiskName
        createOption: 'FromImage'
        osType: 'Linux'
        caching: 'ReadWrite'
        writeAcceleratorEnabled: false
        managedDisk: {
          storageAccountType: parOsDiskSkuName
        }
      }
      imageReference: parImageReference
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: modVmNic.outputs.networkInterface_Id
        }
      ]
    }
    osProfile: {
      computerName: parVmName
      adminUsername: parAdminName
      adminPassword: parAdminPassword
      linuxConfiguration: {
        patchSettings: {
          patchMode: parPatchMode
        }
      }
    }
  }
}

resource resVmAadExtension 'Microsoft.Compute/virtualMachines/extensions@2024-03-01' = if (parAadLoginEnable) {
  parent: resVm
  name: parAadLoginExtensionName
  location: parLocation
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: parAadLoginExtensionName
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

/*******************
*     Outputs      *
*******************/

output vmId string = resVm.id
output nicId string = modVmNic.outputs.networkInterface_Id
output nsgId string = resVmNsg.id


