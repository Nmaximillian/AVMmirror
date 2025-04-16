#!/bin/bash
set -euo pipefail
echo "🟢 Starting AVM mirror job..."
echo "💬 ACR Name: $ACR_NAME"

ACR_URL="$ACR_NAME.azurecr.io"

echo "🟢 Starting AVM module mirror from Microsoft public registry to $ACR_URL"

AVM_MODULES=(
  "res.authorization/roleassignment:0.1.2"
  "res.compute/virtualmachine:0.4.0"
  "res.compute/virtualmachinescaleset:0.2.2"
  "res.compute/availabilityset:0.1.1"
  "res.containers/containerregistry:0.1.1"
  "res.keyvault/keyvault:0.3.2"
  "res.monitor/diagnosticsetting:0.2.2"
  "res.network/bastionhost:0.3.2"
  "res.network/loadbalancer:0.3.0"
  "res.network/networkinterface:0.2.2"
  "res.network/networksecuritygroup:0.2.2"
  "res.network/privateendpoint:0.2.3"
  "res.network/publicipaddress:0.3.1"
  "res.network/virtualnetwork:0.3.1"
  "res.network/virtualnetworkpeering:0.1.2"
  "res.resources/deploymentscript:0.1.2"
  "res.resources/resourcegroup:0.1.1"
  "res.sql/servers:0.3.2"
  "res.storage/storageaccount:0.3.3"
  "res.web/serverfarm:0.2.1"
  "res.web/webapp:0.3.2"
)

for module in "${AVM_MODULES[@]}"; do
  NAME=$(echo "$module" | cut -d ':' -f1 | sed 's|.*/||')
  VERSION=$(echo "$module" | cut -d ':' -f2)
  SOURCE="br:avm/$module"
  TARGET="br:$ACR_URL/modules/$NAME:$VERSION"

  echo "📦 Publishing $SOURCE to $TARGET"
  az bicep publish --source "$SOURCE" --target "$TARGET"

  echo "✅ Published $NAME@$VERSION"
done

echo "🎉 All AVM modules mirrored successfully to $ACR_URL"
