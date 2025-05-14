@description('Admin username for VMs')
param adminUsername string

@description('Admin password for VMs')
@secure()
param adminPassword string

@description('Primary location for resources')
param location string = resourceGroup().location

@description('Name prefix for all resources')
param prefix string = 'connmonlab'

// Log Analytics workspace for monitoring data
resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2022-10-01' = {
  name: '${prefix}-law'
  location: location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 30
    features: {
      enableLogAccessUsingOnlyResourcePermissions: true
    }
  }
}

// Network infrastructure - Hub VNet
resource hubVnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${prefix}-hub-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.0.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'GatewaySubnet'
        properties: {
          addressPrefix: '10.0.0.0/24'
        }
      }
      {
        name: 'AzureBastionSubnet'
        properties: {
          addressPrefix: '10.0.1.0/24'
        }
      }
      {
        name: 'JumpboxSubnet'
        properties: {
          addressPrefix: '10.0.2.0/24'
        }
      }
    ]
  }
}

// Network infrastructure - Spoke1 VNet
resource spoke1Vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${prefix}-spoke1-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.1.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'WebSubnet'
        properties: {
          addressPrefix: '10.1.0.0/24'
        }
      }
      {
        name: 'AppSubnet'
        properties: {
          addressPrefix: '10.1.1.0/24'
        }
      }
    ]
  }
}

// Network infrastructure - Spoke2 VNet
resource spoke2Vnet 'Microsoft.Network/virtualNetworks@2023-04-01' = {
  name: '${prefix}-spoke2-vnet'
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        '10.2.0.0/16'
      ]
    }
    subnets: [
      {
        name: 'DBSubnet'
        properties: {
          addressPrefix: '10.2.0.0/24'
        }
      }
    ]
  }
}

// VNet Peering - Hub to Spoke1
resource hubToSpoke1Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  parent: hubVnet
  name: 'HubToSpoke1'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: spoke1Vnet.id
    }
  }
}

// VNet Peering - Spoke1 to Hub
resource spoke1ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  name: '${spoke1Vnet.name}/Spoke1ToHub'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
  }
}

// VNet Peering - Hub to Spoke2
resource hubToSpoke2Peering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  parent: hubVnet
  name: 'HubToSpoke2'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: true
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: spoke2Vnet.id
    }
  }
}

// VNet Peering - Spoke2 to Hub
resource spoke2ToHubPeering 'Microsoft.Network/virtualNetworks/virtualNetworkPeerings@2023-04-01' = {
  parent: spoke2Vnet
  name: 'Spoke2ToHub'
  properties: {
    allowVirtualNetworkAccess: true
    allowForwardedTraffic: true
    allowGatewayTransit: false
    useRemoteGateways: false
    remoteVirtualNetwork: {
      id: hubVnet.id
    }
  }
}

// Public IPs for VMs
resource jumpboxPublicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${prefix}-jumpbox-pip'
  location: location
  properties: {
    publicIPAllocationMethod: 'Dynamic'
  }
}

resource bastionPublicIP 'Microsoft.Network/publicIPAddresses@2023-04-01' = {
  name: '${prefix}-bastion-pip'
  location: location
  sku: {
    name: 'Standard'
  }
  properties: {
    publicIPAllocationMethod: 'Static'
  }
}

// Bastion Host
resource bastionHost 'Microsoft.Network/bastionHosts@2023-04-01' = {
  name: '${prefix}-bastion'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'IpConf'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', hubVnet.name, 'AzureBastionSubnet')
          }
          publicIPAddress: {
            id: bastionPublicIP.id
          }
        }
      }
    ]
  }
}

// Network Interfaces for VMs
resource jumpboxNIC 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-jumpbox-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', hubVnet.name, 'JumpboxSubnet')
          }
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: jumpboxPublicIP.id
          }
        }
      }
    ]
  }
}

resource webVMNIC 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-webvm-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', spoke1Vnet.name, 'WebSubnet')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource appVMNIC 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-appvm-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', spoke1Vnet.name, 'AppSubnet')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

resource dbVMNIC 'Microsoft.Network/networkInterfaces@2023-04-01' = {
  name: '${prefix}-dbvm-nic'
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', spoke2Vnet.name, 'DBSubnet')
          }
          privateIPAllocationMethod: 'Dynamic'
        }
      }
    ]
  }
}

// Virtual Machines
resource jumpboxVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${prefix}-jumpbox'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'jumpbox'
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: '2019-Datacenter'
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
          id: jumpboxNIC.id
        }
      ]
    }
  }
}

resource webVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${prefix}-webvm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'webvm'
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
          id: webVMNIC.id
        }
      ]
    }
  }
}

resource appVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${prefix}-appvm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'appvm'
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
          id: appVMNIC.id
        }
      ]
    }
  }
}

resource dbVM 'Microsoft.Compute/virtualMachines@2023-03-01' = {
  name: '${prefix}-dbvm'
  location: location
  properties: {
    hardwareProfile: {
      vmSize: 'Standard_B2s'
    }
    osProfile: {
      computerName: 'dbvm'
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
          id: dbVMNIC.id
        }
      ]
    }
  }
}

// Enable Network Watcher in the region
resource networkWatcher 'Microsoft.Network/networkWatchers@2023-04-01' = {
  name: 'NetworkWatcher_${location}'
  location: location
  properties: {}
}

// Extension for monitoring agents - required for Connection Monitor
resource webVMNetworkWatcherExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: webVM
  name: 'NetworkWatcherAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
  }
}

resource appVMNetworkWatcherExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: appVM
  name: 'NetworkWatcherAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
  }
}

resource dbVMNetworkWatcherExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: dbVM
  name: 'NetworkWatcherAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentLinux'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
  }
}

resource jumpboxVMNetworkWatcherExtension 'Microsoft.Compute/virtualMachines/extensions@2023-03-01' = {
  parent: jumpboxVM
  name: 'NetworkWatcherAgent'
  location: location
  properties: {
    publisher: 'Microsoft.Azure.NetworkWatcher'
    type: 'NetworkWatcherAgentWindows'
    typeHandlerVersion: '1.4'
    autoUpgradeMinorVersion: true
  }
}

// Connection Monitor Resource
resource connectionMonitor 'Microsoft.Network/networkWatchers/connectionMonitors@2023-04-01' = {
  parent: networkWatcher
  name: 'AppTierConnectionMonitor'
  location: location
  properties: {
    endpoints: [
      {
        name: 'JumpboxEndpoint'
        resourceId: jumpboxVM.id
        type: 'AzureVM'
      }
      {
        name: 'WebVMEndpoint'
        resourceId: webVM.id
        type: 'AzureVM'
      }
      {
        name: 'AppVMEndpoint'
        resourceId: appVM.id
        type: 'AzureVM'
      }
      {
        name: 'DBVMEndpoint'
        resourceId: dbVM.id
        type: 'AzureVM'
      }
      {
        name: 'MicrosoftEndpoint'
        address: 'www.microsoft.com'
        type: 'ExternalAddress'
      }
    ]
    testConfigurations: [
      {
        name: 'HttpTestConfig'
        testFrequencySec: 30
        protocol: 'Http'
        successThreshold: {
          checksFailedPercent: 5
          roundTripTimeMs: 100
        }
        httpConfiguration: {
          port: 80
          method: 'Get'
          preferHTTPS: false
          validStatusCodeRanges: [
            '200-299'
          ]
        }
      }
      {
        name: 'TcpTestConfig'
        testFrequencySec: 30
        protocol: 'Tcp'
        successThreshold: {
          checksFailedPercent: 5
          roundTripTimeMs: 50
        }
        tcpConfiguration: {
          port: 22
          disableTraceRoute: false
        }
      }
      {
        name: 'IcmpTestConfig'
        testFrequencySec: 30
        protocol: 'Icmp'
        successThreshold: {
          checksFailedPercent: 5
          roundTripTimeMs: 50
        }
        icmpConfiguration: {
          disableTraceRoute: false
        }
      }
    ]
    testGroups: [
      {
        name: 'InterVMConnectivityTests'
        disable: false
        testConfigurations: [
          'TcpTestConfig'
          'IcmpTestConfig'
        ]
        sources: [
          'JumpboxEndpoint'
        ]
        destinations: [
          'WebVMEndpoint'
          'AppVMEndpoint'
          'DBVMEndpoint'
        ]
      }
      {
        name: 'WebConnectivityTests'
        disable: false
        testConfigurations: [
          'HttpTestConfig'
        ]
        sources: [
          'WebVMEndpoint'
          'AppVMEndpoint'
        ]
        destinations: [
          'MicrosoftEndpoint'
        ]
      }
      {
        name: 'AppToDBTests'
        disable: false
        testConfigurations: [
          'TcpTestConfig'
        ]
        sources: [
          'AppVMEndpoint'
        ]
        destinations: [
          'DBVMEndpoint'
        ]
      }
    ]
    outputs: [
      {
        type: 'Workspace'
        workspaceSettings: {
          workspaceResourceId: logAnalyticsWorkspace.id
        }
      }
    ]
  }
}

// Output values for reference
output jumpboxPublicIP string = jumpboxPublicIP.properties.ipAddress
output jumpboxPrivateIP string = jumpboxNIC.properties.ipConfigurations[0].properties.privateIPAddress
output webVMPrivateIP string = webVMNIC.properties.ipConfigurations[0].properties.privateIPAddress
output appVMPrivateIP string = appVMNIC.properties.ipConfigurations[0].properties.privateIPAddress
output dbVMPrivateIP string = dbVMNIC.properties.ipConfigurations[0].properties.privateIPAddress
output logAnalyticsWorkspaceId string = logAnalyticsWorkspace.id
output connectionMonitorName string = connectionMonitor.name
