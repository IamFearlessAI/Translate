# SideStore / AltStore Sideloading

This project supports a no-paid-Apple-Developer route through SideStore or AltStore.

Important: this still uses Apple signing, but SideStore signs locally with your Apple ID. You do not need an Apple Developer Program membership.

## Build The Sideload IPA

In GitHub:

```text
Actions > Build sideload IPA > Run workflow
```

Leave `publish_release` as `true`.

The workflow builds:

```text
LocalLensTranslate-SideStore.ipa
```

and uploads it to the latest GitHub release:

```text
https://github.com/IamFearlessAI/Translate/releases/latest/download/LocalLensTranslate-SideStore.ipa
```

## Add The Source To SideStore

On iPhone, install and configure SideStore first.

Then add this source URL:

```text
https://iamfearlessai.github.io/Translate/source.json
```

SideStore should show:

```text
LocalLens Translate
```

Tap it to install. SideStore will sign the IPA locally using your Apple ID.

## Direct IPA Install

If you prefer direct IPA import from your iPhone, open this URL in Safari:

```text
https://github.com/IamFearlessAI/Translate/releases/latest/download/LocalLensTranslate-SideStore.ipa
```

Open it with SideStore or AltStore from the iOS share sheet.

You can also use the GitHub Pages installer page:

```text
https://iamfearlessai.github.io/Translate/
```

## Limits

- Free Apple ID sideloaded apps usually need refresh every 7 days.
- SideStore needs its normal pairing/VPN setup.
- iOS still will not allow silent monitoring of other apps.
- This build is for local sideload signing, not App Store distribution.
