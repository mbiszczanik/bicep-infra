/*=====================================================
SUMMARY: Azure Verified Modules - Main Bicep Template
DESCRIPTION: This Bicep template deploys a Windows Server virtual machine in Azure using Azure Verified Modules (AVM). 
             It includes a virtual network, network security group, and key vault for secure password storage. 
             The VM is configured to allow HTTP traffic and RDP access from a specified public IP address. 
EXAMPLE: .\Deploy-Infra.ps1
AUTHOR/S: Marcin Biszczanik
VERSION: 0.1.0
======================================================*/

/*******************
*    Parameters    *
*******************/
param parLocation string = resourceGroup().location
param parResourceGroupName string = resourceGroup().name
param parMyPublicIP string

/*******************
*    Variables     *
*******************/
var varVirtualNetworkName string = 'd-avm-swc-vnet-01'
var varKeyVaultName string = 'd-avm-swc-kv-01'
var varVirtualMachineName string = 'd-avm-swc-vm-01'
var varNetworkSecurityGroupName string = 'd-avm-swc-nsg-01'

/*******************
*    Resources     *
*******************/
/** Existing resources **/
resource resKeyVaultObject 'Microsoft.KeyVault/vaults@2025-05-01' existing = {
  name: varKeyVaultName
  scope: resourceGroup(subscription().subscriptionId, parResourceGroupName)
}

/** Deployed resources **/
module modVirtualNetwork 'br/public:avm/res/network/virtual-network:0.7.1' = {
  name: varVirtualNetworkName
  params: {
    name: varVirtualNetworkName
    addressPrefixes: [
      '10.0.0.0/16'
    ]
    subnets: [
      {
        name: 'AVMSubnet'
        addressPrefix: '10.0.100.0/24'
        networkSecurityGroupResourceId: modNetworkSecurityGroup.outputs.resourceId
      }
    ]
  }
}

module modNetworkSecurityGroup 'br/public:avm/res/network/network-security-group:0.5.2' = {
  params: {
    name: varNetworkSecurityGroupName
    securityRules: [
      {
        name: 'Allow-HTTP'
        properties: {
          priority: 100
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '80'
          sourceAddressPrefix: '*'
          destinationAddressPrefix: '*'
        }
      }
      {
        name: 'Allow-RDP-From-MyIP'
        properties: {
          priority: 110
          direction: 'Inbound'
          access: 'Allow'
          protocol: 'Tcp'
          sourcePortRange: '*'
          destinationPortRange: '3389'
          sourceAddressPrefix: parMyPublicIP
          destinationAddressPrefix: '*'
        }
      }
    ]
  }
}

module modKeyVault 'br/public:avm/res/key-vault/vault:0.13.3' = {
  name: varKeyVaultName
  params: {
    name: varKeyVaultName
    location: parLocation
  }
}

module modVirtualMachineWindowsServer 'br/public:avm/res/compute/virtual-machine:0.20.0' = {
  name: varVirtualMachineName
  params: {
    name: varVirtualMachineName
    location: parLocation
    vmSize: 'Standard_B2ms'
    adminUsername: 'azureadmin'
    adminPassword: resKeyVaultObject.getSecret('vm-admin-password')
    osType: 'Windows'
    imageReference: {
      publisher: 'MicrosoftWindowsServer'
      offer: 'WindowsServer'
      sku: '2022-datacenter-azure-edition'
      version: 'latest'
    }
    osDisk: {
      caching: 'ReadWrite'
      diskSizeGB: 128
      managedDisk: {
        storageAccountType: 'Standard_LRS'
      }
    }
    nicConfigurations: [
      {
        enableAcceleratedNetworking: false
        ipConfigurations: [
          {
            name: 'ipconfig01'
            pipConfiguration: {
              publicIpNameSuffix: '-pip-01'
              zones: [1]
              publicIPAllocationMethod: 'Static'
            }
            subnetResourceId: '${modVirtualNetwork.outputs.subnetResourceIds[0]}'
          }
        ]
        nicSuffix: '-nic-01'
      }
    ]
    availabilityZone: 1
    extensionCustomScriptConfig: {
      settings: {}
      protectedSettings: {
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "iex ([System.Text.Encoding]::UTF8.GetString([System.Convert]::FromBase64String(\'${base64(loadTextContent('../scripts/Install-WebServer.ps1'))}\')))"'
        // commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "${base64(loadTextContent('./Install-WebServer.ps1'))}"'
        // commandToExecute: 'powershell -ExecutionPolicy Unrestricted -Command "${loadTextContent('./Install-WebServer.ps1')}"'
        // commandToExecute: 'powershell -ExecutionPolicy Unrestricted -File install-iis.ps1'
      }
    }
  }
  dependsOn: [
    modKeyVault
  ]
}

/******************
*     Outputs     *
******************/
