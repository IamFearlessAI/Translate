# Direct Transfer Package

The iPhone-installable file for this app is:

```text
LocalLensTranslate.ipa
```

This repository contains the project and script needed to produce that file. A signed `.ipa` must be generated on macOS with Apple's iOS SDK and a valid signing identity.

## Create the IPA with the included script

On macOS, from this folder:

```sh
TEAM_ID=YOUR_TEAM_ID APP_BUNDLE_ID=com.yourcompany.locallenstranslate sh Scripts/build_signed_ipa.sh
```

The signed output will be written to:

```text
dist/LocalLensTranslate.ipa
```

## Create the IPA on macOS

1. Open `LocalLensTranslate.xcodeproj` in Xcode.
2. Select the `LocalLensTranslate` target and set your Apple development team.
3. Select the `LocalLensShareExtension` target and set the same team.
4. Connect the destination iPhone at least once if you are using Development or Ad Hoc signing.
5. Choose `Product > Archive`.
6. In Organizer, choose `Distribute App`.
7. Export as Development, Ad Hoc, or Enterprise.
8. Save the exported file as `LocalLensTranslate.ipa`.

## Transfer the IPA to the iPhone

Use one of these direct transfer methods:

- Xcode: `Window > Devices and Simulators`, select the iPhone, then drag `LocalLensTranslate.ipa` into Installed Apps.
- Apple Configurator: connect the iPhone, choose Add App, and select `LocalLensTranslate.ipa`.
- Enterprise or Ad Hoc deployment tools, if your signing account supports them.

## Why this is required

iOS requires app code signing. A raw `.app` folder or unsigned `.ipa` copied to the device will not launch. The `.ipa` has to be compiled and signed for the target device or distribution method.
