/*
SUMMARY: Az-700 hands-on labs
DESCRIPTION: M01 - Unit 6 Configure DNS settings in Azure
AUTHOR/S: Marcin Biszczanik
VERSION: 1.0.0
URI: https://learn.microsoft.com/en-us/training/modules/introduction-to-azure-virtual-networks/6-exercise-configure-domain-name-servers-configuration-azure
     https://microsoftlearning.github.io/AZ-700-Designing-and-Implementing-Microsoft-Azure-Networking-Solutions/Instructions/Exercises/M01-Unit%206%20Configure%20DNS%20settings%20in%20Azure.html

Task 1: Create a private DNS Zone
Task 2: Link subnet for auto registration
Task 3: Create Virtual Machines to test the configuration
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////

param location string = resourceGroup().location

param virtualMachine_1_Name string = 'TestVM1'
param virtualMachine_2_Name string = 'TestVM2'
param virtualMachine_AdminUsername string = 'TestUser'
@secure()
param virtualMachine_AdminPassword string

param networkInterface_1_Name string = '${virtualMachine_1_Name}-NIC'
param networkInterface_2_Name string = '${virtualMachine_2_Name}-NIC'
param networkSecurityGroup_1_Name string = '${virtualMachine_1_Name}-NSG'
param networkSecurityGroup_2_Name string = '${virtualMachine_2_Name}-NSG'
param publicIPAdress_1_Name string = '${virtualMachine_1_Name}-PIP'
param publicIPAdress_2_Name string = '${virtualMachine_2_Name}-PIP'

param privateDNSZone_Name string = 'contoso.com'
param virtualNetworkLink_Name string = 'CoreServicesVnetLink'
param virtualNetworkLink_AutoVmRegistration bool = true

//////////////////////////////////  VARIABLES //////////////////////////////////

var tags = {
  Environment: 'Training'
}

var virtualNetwork_CoreServicesVnet_Name = 'CoreServicesVnet'
var virtualNetwork_Subnet_Name = 'DatabaseSubnet'

var virtualNetworkLink_VnetId = '/subscriptions/033dd423-eb29-4416-90cd-a47c6bebf420/resourceGroups/ContosoResourceGroup/providers/Microsoft.Network/virtualNetworks/CoreServicesVnet' // resourceId('MicrosoftNetwork/virtualNetworks', virtualNetwork_CoreServicesVnet_Name)
var virtualNetworkLink_SubnetRef = resourceId(
  'MicrosoftNetwork/virtualNetworks/subnets',
  virtualNetwork_CoreServicesVnet_Name,
  virtualNetwork_Subnet_Name
)

////////////////////////////////// RESOURCES //////////////////////////////////

resource privateDnsZone 'Microsoft.Network/privateDnsZones@2020-06-01' = {
  name: privateDNSZone_Name
  location: 'global'
}

resource virtualNetworkLink 'Microsoft.Network/privateDnsZones/virtualNetworkLinks@2020-06-01' = {
  parent: privateDnsZone
  name: virtualNetworkLink_Name
  location: 'global'
  properties: {
    registrationEnabled: virtualNetworkLink_AutoVmRegistration
    virtualNetwork: {
      id: virtualNetworkLink_VnetId
    }
  }
  tags: tags
}

resource virtualMachine_TestVM1 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: virtualMachine_1_Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      computerName: virtualMachine_1_Name
      adminUsername: virtualMachine_AdminUsername
      adminPassword: virtualMachine_AdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: networkInterface_1.id
        }
      ]
    }
  }
}

resource networkInterface_1 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterface_1_Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: networkInterface_1_Name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworkLink_SubnetRef
          }
          publicIPAddress: {
            id: publicIPAdress_1.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup_1.id
    }
  }
}

resource networkSecurityGroup_1 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: networkSecurityGroup_1_Name
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-rdp'
        properties: {
          description: 'Allow to RDP connection'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource publicIPAdress_1 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: publicIPAdress_1_Name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource virtualMachine_TestVM2 'Microsoft.Compute/virtualMachines@2023-07-01' = {
  name: virtualMachine_2_Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2ms'
    }
    osProfile: {
      computerName: virtualMachine_2_Name
      adminUsername: virtualMachine_AdminUsername
      adminPassword: virtualMachine_AdminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2022-datacenter-azure-edition'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          properties: {
            primary: true
          }
          id: networkInterface_2.id
        }
      ]
    }
  }
}

resource networkInterface_2 'Microsoft.Network/networkInterfaces@2020-11-01' = {
  name: networkInterface_2_Name
  location: location
  properties: {
    ipConfigurations: [
      {
        name: networkInterface_2_Name
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          subnet: {
            id: virtualNetworkLink_SubnetRef
          }
          publicIPAddress: {
            id: publicIPAdress_2.id
          }
        }
      }
    ]
    networkSecurityGroup: {
      id: networkSecurityGroup_2.id
    }
  }
}

resource networkSecurityGroup_2 'Microsoft.Network/networkSecurityGroups@2023-05-01' = {
  name: networkSecurityGroup_2_Name
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-rdp'
        properties: {
          description: 'Allow to RDP connection'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
          access: 'Allow'
          priority: 1000
          direction: 'Inbound'
        }
      }
    ]
  }
}

resource publicIPAdress_2 'Microsoft.Network/publicIPAddresses@2023-05-01' = {
  name: publicIPAdress_2_Name
  location: location
  sku: {
    name: 'Basic'
    tier: 'Regional'
  }
  properties: {
    publicIPAddressVersion: 'IPv4'
    publicIPAllocationMethod: 'Dynamic'
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
