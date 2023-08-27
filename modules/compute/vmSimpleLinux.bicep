/*
SUMMARY: Linux Virtual Machine resource
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
param virtualMachine_Name string
param virtualMachine_Location string = resourceGroup().location
param virtualMachine_Tags object
param virtualMachine_Size string

@allowed([
  'Premium_LRS'
  'Premium_ZRS'
  'StandardSSD_LRS'
  'StandardSSD_ZRS'
  'Standard_LRS'
  'UltraSSD_LRS'
  ])
@description(' ')
param virtualMachine_OsDiskSkuName string = 'Premium_LRS'

param virtualMachine_ImageReference object = {
  'Ubuntu-1804': {
    publisher: 'Canonical'
    offer: 'UbuntuServer'
    sku: '18_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2004': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-focal'
    sku: '20_04-lts-gen2'
    version: 'latest'
  }
  'Ubuntu-2204': {
    publisher: 'Canonical'
    offer: '0001-com-ubuntu-server-jammy'
    sku: '22_04-lts-gen2'
    version: 'latest'
  }
}

param virtualMachine_AdminName string
@secure()
param virtualMachine_AdminPassword string

@allowed([
  'ImageDefault'
  'AutomaticByPlatform'
])
@description('')
param virtualMachine_PatchMode string = 'ImageDefault'


param virtualMachine_PrivateIPAddress string = ''
param virtualMachine_SubnetId string

@description('Optional. Integration witch Azure AD RBAC login for VMs')
param virtualMachine_AADLoginEnable bool = false

param virtualMachine_AADLoginExtensionName string = 'AADSSHLoginForLinux'

////////////////////////////////// RESOURCES //////////////////////////////////
resource virtualMachine 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: virtualMachine_Name
  location: virtualMachine_Location
  tags: virtualMachine_Tags
  properties: {
    hardwareProfile: {
      vmSize: virtualMachine_Size
    }
    storageProfile:{
      osDisk:{
        name: '${virtualMachine_Name}-OSDisk'
        createOption: 'FromImage'
        osType:'Linux'
        caching:'ReadWrite'
        writeAcceleratorEnabled:false
        managedDisk:{
          storageAccountType: virtualMachine_OsDiskSkuName
        }
      }
      imageReference: virtualMachine_ImageReference
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: virtualMachine_NIC.outputs.networkInterface_Id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachine_Name
      adminUsername: virtualMachine_AdminName
      adminPassword: virtualMachine_AdminPassword
      linuxConfiguration: {
        patchSettings: {
          patchMode: virtualMachine_PatchMode
        }
        
      }
    }
  }
  dependsOn: [
    virtualMachine_NIC
  ]
}

resource virtualMachine_Extension 'Microsoft.Compute/virtualMachines/extensions@2021-11-01' = if (virtualMachine_AADLoginEnable == true) {
  parent: virtualMachine
  name: virtualMachine_AADLoginExtensionName
  location: virtualMachine_Location
  properties: {
    publisher: 'Microsoft.Azure.ActiveDirectory'
    type: virtualMachine_AADLoginExtensionName
    typeHandlerVersion: '1.0'
    autoUpgradeMinorVersion: true
  }
}

////////////////////////////////// MODULES //////////////////////////////////

module virtualMachine_NIC '../network/networkInterface.bicep' = {
  name: '${virtualMachine_Name}-NIC'
  params: {
    networkInterface_Name: '${virtualMachine_Name}-NIC'
    networkInterface_NetworkSecurityGroupId: virtualMachine_NSG.outputs.networkSecurityGroup_Id
    networkInterface_PrivateIpAddress: virtualMachine_PrivateIPAddress
    networkInterface_SubnetId: virtualMachine_SubnetId 
    tags: virtualMachine_Tags
    networkInterface_Location: virtualMachine_Location
  }
  dependsOn:[
    virtualMachine_NSG
  ]
}

module virtualMachine_NSG '../network/networkSecurityGroup.bicep' = {
  name: '${virtualMachine_Name}-NSG'
  params: {
    networkSecurityGroup_Name: '${virtualMachine_Name}-NSG'
    tags: virtualMachine_Tags
    networkSecurityGroup_Location: virtualMachine_Location
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////


