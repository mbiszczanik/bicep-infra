/*
SUMMARY: Cyan bird
DESCRIPTION: n/a
AUTHOR/S: Marcin Biszczanik
VERSION: 0.0.1
*/

//////////////////////////////////  PARAMETERS //////////////////////////////////
@description('Username for the Virtual Machine.')
param adminUsername string = '${virtualMachine_Windows_Name}Admin'

@description('Password for the Virtual Machine.')
@minLength(12)
@secure()
param adminPassword string

@description('Unique DNS Name for the Public IP used to access the Virtual Machine.')
param dnsLabelPrefix string = toLower('${virtualMachine_Windows_Name}-${uniqueString(resourceGroup().id, virtualMachine_Windows_Name)}')

@description('Name for the Public IP used to access the Virtual Machine.')
param publicIpName string = '${virtualMachine_Windows_Name}-PIP'

@description('Allocation method for the Public IP used to access the Virtual Machine.')
@allowed([
  'Dynamic'
  'Static'
])
param publicIPAllocationMethod string = 'Dynamic'

@description('SKU for the Public IP used to access the Virtual Machine.')
@allowed([
  'Basic'
  'Standard'
])
param publicIpSku string = 'Basic'

@description('The Windows version for the VM. This will pick a fully patched image of this given Windows version.')
@allowed([
  '2016-datacenter-gensecond'
  '2019-datacenter-core-g2'
  '2019-datacenter-gensecond'
  '2022-datacenter-azure-edition'
])
param OSVersion string = '2022-datacenter-azure-edition'

@description('Size of the virtual machine.')
param vmSize string = 'Standard_B2ms'

@description('Location for all resources.')
param location string = resourceGroup().location

@description('Name of the virtual machine.')
param virtualMachine_Windows_Name string = 'T-TB-WSVM-01'

param virtualMachine_Linux_Name string = 'T-TB-LXVM-01'

@description('Security Type of the Virtual Machine.')
@allowed([
  'Standard'
  'TrustedLaunch'
])
param securityType string = 'TrustedLaunch'

@description('SSH Key or password for the Virtual Machine. SSH key is recommended.')
@secure()
param adminPasswordOrKey string

@description('Type of authentication to use on the Virtual Machine. SSH key is recommended.')
@allowed([
  'sshPublicKey'
  'password'
])
param authenticationType string = 'password'

var linuxConfiguration = {
  disablePasswordAuthentication: true
  ssh: {
    publicKeys: [
      {
        path: '/home/${adminUsername}/.ssh/authorized_keys'
        keyData: adminPasswordOrKey
      }
    ]
  }
}

//////////////////////////////////  VARIABLES //////////////////////////////////

var tags = {
  Environment: 'Training'
  CostCenter: '00001'
  MSDN: 'MSDN'
}

var nicName = '${virtualMachine_Windows_Name}-NIC'
var addressPrefix = '10.0.0.0/16'
var subnetName = 'CoreSubnet'
var subnetPrefix = '10.0.0.0/24'
var virtualNetworkName = 'T-TB-VNET-01'
var networkSecurityGroupName = '${virtualMachine_Windows_Name}-NSG'
var securityProfileJson = {
  uefiSettings: {
    secureBootEnabled: true
    vTpmEnabled: true
  }
  securityType: securityType
}

////////////////////////////////// RESOURCES //////////////////////////////////
resource virtualNetwork 'Microsoft.Network/virtualNetworks@2022-05-01' = {
  name: virtualNetworkName
  tags: tags
  location: location
  properties: {
    addressSpace: {
      addressPrefixes: [
        addressPrefix
      ]
    }
    subnets: [
      {
        name: subnetName
        properties: {
          addressPrefix: subnetPrefix
          networkSecurityGroup: {
            id: networkSecurityGroup.id
          }
        }
      }
    ]
  }
}

resource networkSecurityGroup 'Microsoft.Network/networkSecurityGroups@2022-05-01' = {
  name: networkSecurityGroupName
  tags: tags
  location: location
  properties: {
    securityRules: [
      {
        name: 'default-allow-3389'
        properties: {
          priority: 1000
          access: 'Allow'
          direction: 'Inbound'
          destinationPortRange: '3389'
          protocol: 'Tcp'
          sourcePortRange: '*'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

resource publicIp_WS 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: publicIpName
  tags: tags
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}

resource publicIp_LX 'Microsoft.Network/publicIPAddresses@2022-05-01' = {
  name: publicIpName
  tags: tags
  location: location
  sku: {
    name: publicIpSku
  }
  properties: {
    publicIPAllocationMethod: publicIPAllocationMethod
    dnsSettings: {
      domainNameLabel: dnsLabelPrefix
    }
  }
}


resource nic_WS 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: nicName
  tags: tags
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
    ]
  }
  dependsOn: [
    virtualNetwork
  ]
}

resource nic_LX 'Microsoft.Network/networkInterfaces@2022-05-01' = {
  name: nicName
  tags: tags
  location: location
  properties: {
    ipConfigurations: [
      {
        name: 'ipconfig1'
        properties: {
          privateIPAllocationMethod: 'Dynamic'
          publicIPAddress: {
            id: publicIp.id
          }
          subnet: {
            id: resourceId('Microsoft.Network/virtualNetworks/subnets', virtualNetworkName, subnetName)
          }
        }
      }
    ]
  }
  dependsOn: [
    virtualNetwork
  ]
}

resource vm_Windows 'Microsoft.Compute/virtualMachines@2022-03-01' = {
  name: virtualMachine_Windows_Name
  tags: tags
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    osProfile: {
      computerName: virtualMachine_Windows_Name
      adminUsername: adminUsername
      adminPassword: adminPassword
    }
    storageProfile: {
      imageReference: {
        publisher: 'MicrosoftWindowsServer'
        offer: 'WindowsServer'
        sku: OSVersion
        version: 'latest'
      }
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      dataDisks: []
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic_WS.id
        }
      ]
    }
    securityProfile: ((securityType == 'TrustedLaunch') ? securityProfileJson : null)
  }
}

resource vm_Linux 'Microsoft.Compute/virtualMachines@2021-11-01' = {
  name: virtualMachine_Linux_Name
  location: location
  properties: {
    hardwareProfile: {
      vmSize: vmSize
    }
    storageProfile: {
      osDisk: {
        createOption: 'FromImage'
        managedDisk: {
          storageAccountType: 'StandardSSD_LRS'
        }
      }
      imageReference: {
        publisher: 'Cannonical'
        offer: '0001-com-ubuntu-server-jammy'
        sku: '22_04-lts-gen2'
        version: 'latest'
      }
    }
    networkProfile: {
      networkInterfaces: [
        {
          id: nic_LX.id
        }
      ]
    }
    osProfile: {
      computerName: virtualMachine_Linux_Name
      adminUsername: adminUsername
      adminPassword: adminPasswordOrKey
      linuxConfiguration: ((authenticationType == 'password') ? null : linuxConfiguration)
    }
  }
}

//////////////////////////////////  OUTPUT  //////////////////////////////////
