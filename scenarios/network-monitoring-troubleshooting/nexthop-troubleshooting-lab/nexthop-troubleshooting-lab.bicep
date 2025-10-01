@description('Username for the Virtual Machines')
param adminUsername string

@description('Password for the Virtual Machines')
@secure()
param adminPassword string

@description('Location for all resources')
param location string = resourceGroup().location

@description('Name prefix for all resources')
param prefix string = 'nexthoplab'

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
        }
      }
      {
        name: 'subnet2'
        properties: {
          addressPrefix: '10.0.2.0/24'
          routeTable: {
            id: customRouteTable.id
          }
        }
      }
      {
        name: 'subnet3'
        properties: {
          addressPrefix: '10.0.3.0/24'
        }
      }
    ]
  }
}

// Custom Route Table with Problematic Route
resource customRouteTable 'Microsoft.Network/routeTables@2023-04-01' = {
  name: '${prefix}-routetable'
  location: location
  properties: {
    disableBgpRoutePropagation: false
    routes: [
      {
        name: 'route-to-blackhole'
        properties: {
          addressPrefix: '10.0.3.0/24'
          nextHopType: 'None'
          nextHopIpAddress: null
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

// Third VM in Subnet3 (optional for testing directly)
resource vm3PublicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${prefix}-vm3-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource vm3NIC 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-vm3-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: vnet.properties.subnets[2].id
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: vm3PublicIP.id
          }
        }
      }
    ]
  }
}

resource vm3 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${prefix}-vm3'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'vm3'
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
          id: vm3NIC.id
        }
      ]
    }
  }
}

// // Enable Network Watcher
// resource networkWatcher 'Microsoft.Network/networkWatchers@2023-04-01' = {
//   name: 'NetworkWatcher_${location}'
//   location: location
//   properties: {}
// }

// Output values for troubleshooting
output vm1Name string = vm1.name
output vm1PrivateIP string = vm1NIC.properties.ipConfigurations[0].properties.privateIPAddress
output vm2Name string = vm2.name
output vm2PrivateIP string = vm2NIC.properties.ipConfigurations[0].properties.privateIPAddress
output vm3Name string = vm3.name
output vm3PrivateIP string = vm3NIC.properties.ipConfigurations[0].properties.privateIPAddress
output routeTableName string = customRouteTable.name
