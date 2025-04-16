#!/bin/bash
set -euo pipefail

echo "🟢 Starting AVM mirror job..."
echo "💬 ACR Name: $ACR_NAME"
echo "💬 Cloning Azure Verified Modules..."

rm -rf Verified-Modules
git clone "https://$GITHUB_PAT@github.com/Azure/Verified-Modules.git" || {
  echo "❌ Git clone failed"
  exit 1
}

echo "📁 Repo cloned successfully"

AVM_FOLDER="Verified-Modules/bicep"
ACR_URL="$ACR_NAME.azurecr.io"

echo "🚀 Publishing modules to $ACR_URL"

for dir in $AVM_FOLDER/*/; do
  MODULE_NAME=$(basename "$dir")
  MODULE_PATH="$dir/main.bicep"
  METADATA_FILE="$dir/metadata.json"

  if [[ -f "$MODULE_PATH" && -f "$METADATA_FILE" ]]; then
    VERSION=$(jq -r '.version' "$METADATA_FILE")

    if [[ "$VERSION" == "null" || -z "$VERSION" ]]; then
      echo "⚠️ Skipping $MODULE_NAME (missing version)"
      continue
    fi

    TARGET="br:$ACR_URL/modules/$MODULE_NAME:$VERSION"
    echo "📦 Publishing $MODULE_NAME@$VERSION -> $TARGET"

    az bicep publish "$MODULE_PATH" --target "$TARGET" || {
      echo "❌ Failed to publish $MODULE_NAME"
      exit 1
    }

  else
    echo "⚠️ Skipping $MODULE_NAME (missing main.bicep or metadata.json)"
  fi
done

echo "✅ All modules published successfully"
