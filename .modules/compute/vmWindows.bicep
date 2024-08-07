/*
SUMMARY: 
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION:
URI: 
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param virtualMachine_Name string
param virtualMachine_Location string = resourceGroup().location
param tags object
param virtualMachine_Size string
param virtualMachine_AdminUsername string
@secure()
param virtualMachine_AdminPassword string
param virtualMachine_OSVersion string
param virtualMachine_DiskType string = 'StandardSSD_LRS'

param networkSecurityGroup_name string
param networkInterface_Name string
param networkInterface_NetworkSecurityGroupId string
param networkInterface_PrivateIpAddress string
param networkInterface_SubnetId string

//////////////////////////////////  VARIABLES //////////////////////////////////

////////////////////////////////// RESOURCES //////////////////////////////////

resource virtualMachine 'Microsoft.Compute/virtualMachines@2024-03-01' = {
  name: virtualMachine_Name
  location: virtualMachine_Location
  tags: tags
  properties: {
    hardwareProfile: {
      vmSize: virtualMachine_Size
    }
    osProfile: {
      computerName: virtualMachine_Name
      adminUsername: virtualMachine_AdminUsername
      adminPassword: virtualMachine_AdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: virtualMachine_OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: virtualMachine_DiskType
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
          id: networkInterface.outputs.networkInterface_Id
        }
      ]
    }
  }
}

module networkSecurityGroup '../network/networkSecurityGroup.bicep' = {
  name: networkSecurityGroup_name
  params: {
    tags: tags
    networkSecurityGroup_Name: networkSecurityGroup_name
  }
}

module networkInterface '../network/networkInterface.bicep' = {
  name: networkInterface_Name
  params: {
    tags: tags
    networkInterface_Name: networkInterface_Name
    networkInterface_NetworkSecurityGroupId: networkInterface_NetworkSecurityGroupId
    networkInterface_PrivateIpAddress: networkInterface_PrivateIpAddress
    networkInterface_SubnetId: networkInterface_SubnetId
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output virtualMachine_Name string = virtualMachine.name
output virtualMachine_Id string = virtualMachine.id
