param location string = resourceGroup().location
param vaultName string = 'testavmkeyvault'

module keyvault 'br:avmmodulesbc.azurecr.io/modules/key-vault:0.3.2' = {
  name: 'keyVaultDeployment'
  params: {
    name: vaultName
    location: location
    tenantId: subscription().tenantId
    skuName: 'standard'
  }
}
