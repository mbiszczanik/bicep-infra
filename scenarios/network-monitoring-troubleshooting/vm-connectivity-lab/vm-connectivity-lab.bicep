@description('Username for the Virtual Machines')
param adminUsername string

@description('Password for the Virtual Machines')
@secure()
param adminPassword string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name prefix for all resources')
param prefix string = 'vmconnlab'

// Virtual Network and Subnets
resource vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${prefix}-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'subnet1'
        properties: {
          addressPrefix: '10.0.1.0/24'
          networkSecurityGroup: {
            id: nsg1.id
          }
        }
      }
      {
        name: 'subnet2'
        properties: {
          addressPrefix: '10.0.2.0/24'
          networkSecurityGroup: {
            id: nsg2.id
          }
        }
      }
    ]
  }
}

// Network Security Groups
resource nsg1 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: '${prefix}-nsg1'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-ssh'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
      {
        name: 'block-vm2'
        properties: {
          priority: 200
          protocol: '*'
          access: 'Deny'
          direction: 'Outbound'
          sourceAddressPrefix: '10.0.1.0/24'
          sourcePortRange: '*'
          destinationAddressPrefix: '10.0.2.0/24'
          destinationPortRange: '*'
        }
      }
    ]
  }
}

resource nsg2 'Microsoft.Network/networkSecurityGroups@2023-04-01' = {
  name: '${prefix}-nsg2'
  location: location
  properties: {
    securityRules: [
      {
        name: 'allow-ssh'
        properties: {
          priority: 100
          protocol: 'Tcp'
          access: 'Allow'
          direction: 'Inbound'
          sourceAddressPrefix: '*'
          sourcePortRange: '*'
          destinationAddressPrefix: '*'
          destinationPortRange: '22'
        }
      }
    ]
  }
}

// Public IPs for VMs
resource vm1PublicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${prefix}-vm1-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vm2PublicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${prefix}-vm2-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

// Network Interfaces
resource vm1NIC 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-vm1-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[0].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vm1PublicIP.id
          }
        }
      }
    ]
  }
}

resource vm2NIC 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-vm2-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[1].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vm2PublicIP.id
          }
        }
      }
    ]
  }
}

// Virtual Machines
resource vm1 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${prefix}-vm1'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'vm1'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm1NIC.id
        }
      ]
    }
  }
}

resource vm2 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${prefix}-vm2'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'vm2'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'Canonical'
        offer: 'UbuntuServer'
        sku: '18.04-LTS'
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'Standard_LRS'
        }
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: vm2NIC.id
        }
      ]
    }
  }
}

// Enable Network Watcher
resource networkWatcher 'Microsoft.Network/networkWatchers@2023-04-01' = {
  name: 'NetworkWatcher_${location}'
  location: location
  properties: {}
}

// Output values for troubleshooting
output vm1Name string = vm1.name
output vm1PrivateIP string = vm1NIC.properties.ipConfigurations[0].properties.privateIPAddress
output vm2Name string = vm2.name
output vm2PrivateIP string = vm2NIC.properties.ipConfigurations[0].properties.privateIPAddress
output vm1NicName string = vm1NIC.name
output vm2NicName string = vm2NIC.name
