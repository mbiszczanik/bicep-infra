using '../azuredeploy.bicep' /*TODO: Provide a path to a bicep template*/

param vmName = 'myVM3'

param nicName = 'myVMnic3'

param vmSize = 'Standard_B2ms'

param adminUsername = 'TestUser'

@secure()
param adminPassword = ''
