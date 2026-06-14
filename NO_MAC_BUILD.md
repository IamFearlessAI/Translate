# Build Without Owning A Mac

You can build the installable iOS IPA using GitHub Actions. GitHub provides the macOS runner, so you do not need a personal Mac.

You still need Apple signing assets because iOS will not install unsigned apps.

## Required GitHub Secrets

In the GitHub repo, go to:

```text
Settings > Secrets and variables > Actions > New repository secret
```

Add these secrets:

```text
APPLE_TEAM_ID
APP_BUNDLE_ID
IOS_DISTRIBUTION_CERTIFICATE_P12_BASE64
IOS_CERTIFICATE_PASSWORD
IOS_APP_PROVISIONING_PROFILE_BASE64
IOS_EXTENSION_PROVISIONING_PROFILE_BASE64
```

`APP_BUNDLE_ID` should match the app ID you registered with Apple, for example:

```text
com.yourcompany.locallenstranslate
```

The share extension uses:

```text
com.yourcompany.locallenstranslate.ShareExtension
```

## Convert Signing Files To Base64

If you receive the signing files from Apple Developer, a teammate, or a CI signing service, convert them to Base64 before saving them as GitHub secrets.

Certificate:

```sh
base64 -i ios_distribution.p12 | pbcopy
```

Main app provisioning profile:

```sh
base64 -i LocalLensTranslate.mobileprovision | pbcopy
```

Share extension provisioning profile:

```sh
base64 -i LocalLensShareExtension.mobileprovision | pbcopy
```

On Windows PowerShell:

```powershell
[Convert]::ToBase64String([IO.File]::ReadAllBytes("ios_distribution.p12")) | Set-Clipboard
```

## Run The Build

In GitHub:

```text
Actions > Build signed IPA > Run workflow
```

Leave `publish_release` as `true` if you want the workflow to upload:

```text
LocalLensTranslate.ipa
```

to the `latest` GitHub release.

That release URL is what the iPhone install manifest uses:

```text
https://github.com/IamFearlessAI/Translate/releases/latest/download/LocalLensTranslate.ipa
```

The workflow uses GitHub's hosted `macos-latest` runner. That means Apple build tools run in the cloud; you do not need to own a Mac.

## Install From iPhone

1. Install `Profiles/LocalLensTranslate-GitHubInstall.mobileconfig` from the repo.
2. Open the `Install LocalLens` Home Screen icon.
3. Tap `Install App`.

The install works only when the IPA is signed for that device or distribution method.
