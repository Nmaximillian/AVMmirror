#!/bin/bash

# === CONFIG ===
ACR_NAME=${ACR_NAME:-"avmmodulesbc"}
ACR_URL="$ACR_NAME.azurecr.io"
AVM_FOLDER="Verified-Modules/bicep"
AVM_REPO="https://$GITHUB_PAT@github.com/Azure/Verified-Modules.git"

# Login assumed handled by container context (use managed identity or service principal if needed)

echo "🌐 Cloning Azure Verified Modules..."
rm -rf Verified-Modules
git clone $AVM_REPO

echo "🚀 Publishing all Bicep AVMs to $ACR_URL..."
for dir in $AVM_FOLDER/*/; do
  MODULE_NAME=$(basename "$dir")
  MODULE_PATH="$dir/main.bicep"
  METADATA_FILE="$dir/metadata.json"

  if [[ -f "$MODULE_PATH" && -f "$METADATA_FILE" ]]; then
    VERSION=$(jq -r '.version' "$METADATA_FILE")

    if [[ "$VERSION" == "null" || -z "$VERSION" ]]; then
      echo "⚠️ Skipping $MODULE_NAME (version not found)"
      continue
    fi

    TARGET="br:$ACR_URL/modules/$MODULE_NAME:$VERSION"
    echo "📦 Publishing $MODULE_NAME @ $VERSION -> $TARGET"
    az bicep publish "$MODULE_PATH" --target "$TARGET"
  else
    echo "⚠️ Skipping $MODULE_NAME (missing files)"
  fi
done

echo "✅ Done publishing all available modules."
