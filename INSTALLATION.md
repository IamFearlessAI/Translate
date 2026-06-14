# Direct App Installation

## What works on iOS

LocalLens Translate can be installed on an iPhone as a signed `.ipa` file. The app and share extension run locally on the device.

Direct transfer options:

- Xcode direct install to a connected iPhone.
- Export a signed `.ipa`, then transfer it with Apple Configurator.
- Export a signed `.ipa`, then install it from Xcode's Devices and Simulators window.
- Export an Ad Hoc `.ipa` for registered devices.
- Export an Enterprise `.ipa` if your Apple account supports enterprise signing.

## Important

iOS does not allow direct installation of an unsigned `.app` folder copied from a computer. The transferable file must be a signed `.ipa`.

## Development install

1. Open `LocalLensTranslate.xcodeproj`.
2. Select the `LocalLensTranslate` target.
3. Set `Signing & Capabilities` to your Apple development team.
4. Repeat for `LocalLensShareExtension`.
5. Connect an iPhone.
6. Build and run.

## Exporting a directly transferable IPA

Use the included script on macOS:

```sh
TEAM_ID=YOUR_TEAM_ID APP_BUNDLE_ID=com.yourcompany.locallenstranslate sh Scripts/build_signed_ipa.sh
```

The signed `.ipa` will be exported to `dist/`.

The included `Packaging/ExportOptions-AdHoc.plist` can be used with `xcodebuild -exportArchive` on macOS after you set your team ID and signing profile names.

## Transfer to device

After export, transfer the `.ipa` with one of these:

- Apple Configurator: add the app to a connected supervised or trusted device.
- Xcode: open `Window > Devices and Simulators`, select the device, and drag the `.ipa` into Installed Apps.
- Finder on macOS: select the connected iPhone and use app/file management where supported by your iOS/macOS combination.

## Background behavior

iOS does not allow this type of app to monitor other apps' visible text or images in the background. The app therefore supports the user-approved alternatives:

- Share selected text into the LocalLens share extension.
- Share images or screenshots into the extension for OCR and translation.
- Import images directly inside the app.

## Offline translation models

OCR is implemented with Apple's on-device Vision framework. Translation requires bundled on-device models.

To make production translation work:

1. Add model files under `Models/`.
2. Replace the demo implementation in `LocalLensTranslate/TranslationEngine.swift`.
3. Return translations from your Core ML or local model runner.
