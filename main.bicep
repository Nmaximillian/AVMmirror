param location string = resourceGroup().location
param vaultName string = 'testavmkeyvault'

module keyVault 'br/public:avm/res/key-vault/vault:0.3.2' = {
  name: 'keyVaultDeployment'
  params: {
    name: vaultName
    location: location
    tenantId: subscription().tenantId
    skuName: 'standard'
  }
}
