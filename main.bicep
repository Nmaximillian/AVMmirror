module keyVault 'br/public:avm/res/key-vault/vault:0.3.2' = {
  name: 'vaultDeployment'
  params: {
    // Required parameters
    name: 'kvtestdeployment'
    // Non-required parameters
    enablePurgeProtection: false
    enableRbacAuthorization: true
    keys: [
      {
        attributes: {
          exp: 1725109032
          nbf: 10000
        }
        kty: 'EC'
        name: 'keyName'
        rotationPolicy: {
          attributes: {
            expiryTime: 'P2Y'
          }
          lifetimeActions: [
            {
              action: {
                type: 'Rotate'
              }
              trigger: {
                timeBeforeExpiry: 'P2M'
              }
            }
            {
              action: {
                type: 'Notify'
              }
              trigger: {
                timeBeforeExpiry: 'P30D'
              }
            }
          ]
        }
      }
    ]
  }
}
