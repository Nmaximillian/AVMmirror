param location string = resourceGroup().location
param vaultName string = 'myavmkeyvault'

module keyvault 'br:avmmodulesbc.azurecr.io/modules/key-vault:0.3.2' = {
  name: 'keyVaultDeployment'
  params: {
    name: testavmkv
    location: location
    tenantId: subscription().tenantId
    skuName: 'standard'
  }
}
