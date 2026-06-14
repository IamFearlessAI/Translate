#!/bin/sh
set -eu

ROOT_DIR="$(cd "$(dirname "$0")/.." && pwd)"
PROJECT="$ROOT_DIR/LocalLensTranslate.xcodeproj"
SCHEME="LocalLensTranslate"
BUILD_DIR="$ROOT_DIR/build"
ARCHIVE_PATH="$BUILD_DIR/LocalLensTranslate.xcarchive"
EXPORT_PATH="$ROOT_DIR/dist"
EXPORT_OPTIONS="$ROOT_DIR/Packaging/ExportOptions-AdHoc.plist"
GENERATED_EXPORT_OPTIONS="$BUILD_DIR/ExportOptions-AdHoc.generated.plist"

TEAM_ID="${TEAM_ID:-}"
APP_BUNDLE_ID="${APP_BUNDLE_ID:-}"

if [ -z "$TEAM_ID" ]; then
  echo "Set TEAM_ID to your Apple Developer Team ID."
  echo "Example: TEAM_ID=ABCDE12345 APP_BUNDLE_ID=com.example.locallens ./Scripts/build_signed_ipa.sh"
  exit 1
fi

if [ -z "$APP_BUNDLE_ID" ]; then
  echo "Set APP_BUNDLE_ID to a bundle identifier registered to your Apple Developer account."
  echo "Example: TEAM_ID=ABCDE12345 APP_BUNDLE_ID=com.example.locallens ./Scripts/build_signed_ipa.sh"
  exit 1
fi

rm -rf "$BUILD_DIR" "$EXPORT_PATH"
mkdir -p "$BUILD_DIR" "$EXPORT_PATH"

sed "s/YOUR_TEAM_ID/$TEAM_ID/g" "$EXPORT_OPTIONS" > "$GENERATED_EXPORT_OPTIONS"

xcodebuild \
  -project "$PROJECT" \
  -scheme "$SCHEME" \
  -configuration Release \
  -destination "generic/platform=iOS" \
  -archivePath "$ARCHIVE_PATH" \
  DEVELOPMENT_TEAM_ID="$TEAM_ID" \
  APP_BUNDLE_ID="$APP_BUNDLE_ID" \
  CODE_SIGN_STYLE=Automatic \
  -allowProvisioningUpdates \
  clean archive

xcodebuild \
  -exportArchive \
  -archivePath "$ARCHIVE_PATH" \
  -exportPath "$EXPORT_PATH" \
  -exportOptionsPlist "$GENERATED_EXPORT_OPTIONS" \
  -allowProvisioningUpdates \
  DEVELOPMENT_TEAM_ID="$TEAM_ID" \
  APP_BUNDLE_ID="$APP_BUNDLE_ID"

echo "Signed IPA export complete:"
find "$EXPORT_PATH" -name "*.ipa" -print
