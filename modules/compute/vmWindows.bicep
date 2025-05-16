/*
SUMMARY: Windows Server Virtual Machine deployment
DESCRIPTION: Deploys a Windows Server VM with associated networking and security resources
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0
*/

//////////////////////////////////  TARGET SCOPE //////////////////////////////////

targetScope = 'resourceGroup'

//////////////////////////////////  PARAMETERS //////////////////////////////////

@description('Base name for all resources')
param parBaseName string

@description('Environment prefix, e.g. DEV, TST, PRD')
param parEnvironmentPrefix string = 'T'

@description('Location prefix, e.g. WEu')
param parLocationPrefix string = 'WEu'

@description('Azure region for deployment')
param parLocation string = resourceGroup().location

@description('Instance number for resource uniqueness')
param parInstanceNumber string = '01'

@description('Tags to apply to all resources')
param parTags object = {}

@description('VM size')
param parVmSize string = 'Standard_B2ms'

@description('VM admin username')
param parAdminUsername string

@secure()
@description('VM admin password')
param parAdminPassword string

@description('Windows Server version SKU')
@allowed(['2016-Datacenter','2019-Datacenter','2022-Datacenter'])
param parOsVersion string = '2019-Datacenter'

@description('OS disk type')
@allowed(['Standard_LRS','StandardSSD_LRS','Premium_LRS'])
param parOsDiskType string = 'StandardSSD_LRS'

@description('Subnet resource ID for the VM NIC')
param parSubnetId string

@description('Private IP address for the VM NIC (optional)')
param parPrivateIpAddress string = ''

@description('Array of NSG rules')
param parNsgRules array = []

//////////////////////////////////  VARIABLES //////////////////////////////////

var varVmName = '${parEnvironmentPrefix}-${parBaseName}-${parLocationPrefix}-VM${parInstanceNumber}'
var varNsgName = '${parEnvironmentPrefix}-${parBaseName}-${parLocationPrefix}-NSG${parInstanceNumber}'
var varNicName = '${parEnvironmentPrefix}-${parBaseName}-${parLocationPrefix}-NIC${parInstanceNumber}'
var varPipName = '${parEnvironmentPrefix}-${parBaseName}-${parLocationPrefix}-PIP${parInstanceNumber}'
var varOsDiskName = '${varVmName}-OSDisk'

////////////////////////////////// RESOURCES //////////////////////////////////

module modNsg '../network/networkSecurityGroup.bicep' = {
  name: varNsgName
  params: {
    tags: parTags
    networkSecurityGroup_Name: varNsgName
    networkSecurityGroup_Location: parLocation
    networkSecurityGroup_Rules: parNsgRules
  }
}

module modNic '../network/networkInterface.bicep' = {
  name: varNicName
  params: {
    tags: parTags
    networkInterface_Name: varNicName
    networkInterface_NetworkSecurityGroupId: modNsg.outputs.networkSecurityGroup_Id
    networkInterface_PrivateIpAddress: parPrivateIpAddress
    networkInterface_SubnetId: parSubnetId
    networkInterface_Location: parLocation
  }
}

module modPip '../network/publicIPaddress.bicep' = {
  name: varPipName
  params: {
    tags: parTags
    publicIpAddress_Name: varPipName
  }
}

resource resVm 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: varVmName
  location: parLocation
  tags: parTags
  properties: {
    hardwareProfile: {
      vmSize: parVmSize
    }
    osProfile: {
      computerName: varVmName
      adminUsername: parAdminUsername
      adminPassword: parAdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: parOsVersion
        version: 'latest'
      }
      osDisk: {
        name: varOsDiskName
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: parOsDiskType
        }
      }
      dataDisks: [
        {
          diskSizeGB: 128
          lun: 0
          createOption: 'Empty'
        }
      ]
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: modNic.outputs.networkInterface_Id
        }
      ]
    }
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output virtualMachine_Name string = resVm.name
output virtualMachine_Id string = resVm.id
