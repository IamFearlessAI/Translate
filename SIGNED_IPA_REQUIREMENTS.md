# Signed IPA Requirements

To create an iPhone-installable IPA, the build machine must have:

- macOS.
- Xcode or Apple's command line tools with the iOS SDK.
- An Apple Developer account.
- A valid signing certificate in Keychain.
- A provisioning profile that includes:
  - The app bundle ID, for example `com.yourcompany.locallenstranslate`.
  - The extension bundle ID, for example `com.yourcompany.locallenstranslate.ShareExtension`.
  - The target device UDID for Development or Ad Hoc exports.

This project now includes:

- A shared Xcode scheme for command-line archiving.
- Build settings that accept `TEAM_ID` and `APP_BUNDLE_ID`.
- Empty entitlements to avoid unnecessary App Group provisioning requirements.
- A script that produces `dist/*.ipa` when run on macOS with valid signing credentials.

