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
param virtualMachine_Size string = 'Standard_B2ms'
param virtualMachine_AdminUsername string = '${virtualMachine_Name}Admin'
@secure()
param virtualMachine_AdminPassword string
param virtualMachine_OSVersion string = '2019-Datacenter'
param virtualMachine_DiskType string = 'StandardSSD_LRS'

param networkSecurityGroup_name string = '${virtualMachine_Name}-NSG'
param networkInterface_Name string = '${virtualMachine_Name}-NIC'
param networkInterface_NetworkSecurityGroupId string
param networkInterface_PrivateIpAddress string
param networkInterface_SubnetId string
param publicIpAddress_Name string = '${virtualMachine_Name}-PIP'

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

module publicIpAddress '../network/publicIPaddress.bicep' = {
  name: publicIpAddress_Name
  params: {
    tags: tags
    publicIpAddress_Name: publicIpAddress_Name
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
output virtualMachine_Name string = virtualMachine.name
output virtualMachine_Id string = virtualMachine.id
