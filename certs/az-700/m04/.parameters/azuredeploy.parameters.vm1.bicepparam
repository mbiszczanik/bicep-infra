using '../azuredeploy.bicep' /*TODO: Provide a path to a bicep template*/

param vmName = 'myVM1'

param nicName = 'myVMnic1'

param vmSize = 'Standard_B2ms'

param adminUsername = 'TestUser'

@secure()
param adminPassword = ''
