using '../azuredeploy.bicep' /*TODO: Provide a path to a bicep template*/

param vmName = 'myVM2'

param nicName = 'myMV2nic2'

param vmSize = 'Standard_B2ms'

param adminUsername = 'TestUser'

@secure()
param adminPassword = ''
