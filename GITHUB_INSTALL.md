# GitHub-Hosted iOS Install

This project includes a Settings-installable configuration profile and a GitHub Pages installer.

## What the profile does

`Profiles/LocalLensTranslate-GitHubInstall.mobileconfig` installs a Home Screen web clip named `Install LocalLens`.

The profile does not bypass Apple app signing. It opens the GitHub Pages install page, which launches an `itms-services` install using `GitHubPages/manifest.plist`.

## Setup

1. Replace `IamFearlessAI` in:
   - `GitHubPages/index.html`
   - `GitHubPages/manifest.plist`
   - `Profiles/LocalLensTranslate-GitHubInstall.mobileconfig`
2. Replace `com.yourcompany.locallenstranslate` in `GitHubPages/manifest.plist` with the signed app bundle ID.
3. Enable GitHub Pages for the repository using GitHub Actions.
4. Build and sign the IPA on macOS:

```sh
TEAM_ID=YOUR_TEAM_ID APP_BUNDLE_ID=com.yourcompany.locallenstranslate sh Scripts/build_signed_ipa.sh
```

5. Upload the signed IPA to a GitHub release named:

```text
LocalLensTranslate.ipa
```

6. On iPhone, install:

```text
Profiles/LocalLensTranslate-GitHubInstall.mobileconfig
```

7. Open the new Home Screen installer link and tap `Install App`.


