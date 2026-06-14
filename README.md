# LocalLens Translate

LocalLens Translate is an iOS SwiftUI app scaffold for local, on-device text translation with OCR from images.

Important iOS constraints:

- iOS apps cannot silently read the screen or content of other apps in the background.
- The supported Apple-native path for translating content from other apps is a Share Extension. Users share selected text or an image into LocalLens Translate, and the extension extracts/translates it.
- The directly transferable app file for iPhone is a signed `.ipa`. iOS will not install an unsigned app bundle copied from a computer.
- "Any language to any language" offline requires local translation models for those language pairs. This scaffold includes the app plumbing, OCR, extension flow, and a replaceable local translation engine. Add Core ML or other bundled on-device models under `Models/`.

## Project Layout

- `LocalLensTranslate.xcodeproj/` - Xcode project skeleton.
- `LocalLensTranslate/` - Main SwiftUI app.
- `LocalLensShareExtension/` - iOS Share Extension for text and images from other apps.
- `Models/` - Place bundled translation model files here.
- `Packaging/ExportOptions-AdHoc.plist` - Xcode export settings for a transferable `.ipa`.
- `Scripts/build_signed_ipa.sh` - macOS command-line build script that archives and exports a signed `.ipa`.
- `.github/workflows/build-signed-ipa.yml` - GitHub Actions cloud build for creating a signed `.ipa` without owning a Mac.
- `.github/workflows/build-sideload-ipa.yml` - GitHub Actions cloud build for creating a SideStore/AltStore IPA.
- `GitHubPages/` - GitHub Pages installer site and OTA manifest template.
- `Profiles/LocalLensTranslate-GitHubInstall.mobileconfig` - Settings-installable profile that adds a Home Screen installer link.
- `Profiles/LocalLensTranslate-SideStoreInstall.mobileconfig` - Settings-installable profile for SideStore/AltStore download links.
- `SIDELOADING.md` - SideStore and AltStore setup notes.
- `DIRECT_TRANSFER.md` - Steps to create and transfer the `.ipa` to an iPhone.

## Build

1. Open `LocalLensTranslate.xcodeproj` in Xcode.
2. Set your development team for both targets.
3. Update bundle identifiers if needed:
   - `com.example.locallenstranslate`
   - `com.example.locallenstranslate.ShareExtension`
4. Build and run on a physical iPhone.

The app is intentionally local-only. It uses Vision for OCR and never sends text or images to a server.

For direct file transfer, create a signed `.ipa` on macOS:

```sh
TEAM_ID=YOUR_TEAM_ID APP_BUNDLE_ID=com.yourcompany.locallenstranslate sh Scripts/build_signed_ipa.sh
```

Then copy the exported `.ipa` from `dist/` to the device with Apple Configurator, Finder device management, or Xcode's Devices window.

For GitHub-hosted installation, replace `IamFearlessAI` in `GitHubPages/` and `Profiles/`, publish GitHub Pages, upload the signed IPA to a GitHub release as `LocalLensTranslate.ipa`, then install the profile from Settings.

To avoid using your own Mac, configure the secrets in `NO_MAC_BUILD.md`, then run the `Build signed IPA` workflow in GitHub Actions.

For SideStore or AltStore, run the `Build sideload IPA` workflow and add `https://iamfearlessai.github.io/Translate/source.json` as a source.

## License

MIT. See `LICENSE`.

