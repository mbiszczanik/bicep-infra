/*######################################################
SUMMARY:
DESCRIPTION: 
AUTHOR/S: Marcin Biszczanik
VERSION:

######################################################*/

/*******************
*    Parameters    *
*******************/
param parLocation string = resourceGroup().location
param parResourceGroupName string = resourceGroup().name

/*******************
*    Variables     *
*******************/
var varVirtualNetworkName string = 'd-avm-swc-vnet-01'
var varKeyVaultName string = 'd-avm-swc-kv-01'
var varVirtualMachineName string = 'd-avm-swc-vm-01'

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
    vmSize: 'Standard_D2s_v5'
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
        commandToExecute: 'powershell -ExecutionPolicy Unrestricted -EncodedCommand "${base64(loadTextContent('./Install-WebServer.ps1'))}"'
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
