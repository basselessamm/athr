# Release Signing — Midrar

## Policy

Release builds are **never** signed with the debug keystore. The release
build type uses a dedicated `release` signing config that reads credentials
from `android/key.properties` (git-ignored) or CI environment variables.
If credentials are missing the build **fails fast** with:
`Keystore file not set for signing config release`.

## One-time local setup

```bash
keytool -genkey -v -keystore android/midrar-release.jks \
  -alias midrar -keyalg RSA -keysize 4096 -validity 10000
```

Then:

```bash
cp android/key.properties.example android/key.properties
# edit android/key.properties with your real passwords and alias
```

`android/key.properties` and `*.jks` are already covered by `.gitignore`.

## CI / other machines

Provide environment variables instead of the file:

```
MIDRAR_SIGNING_STOREFILE=/path/to/midrar-release.jks
MIDRAR_SIGNING_STOREPASSWORD=...
MIDRAR_SIGNING_KEYALIAS=midrar
MIDRAR_SIGNING_KEYPASSWORD=...
```

## Verify before every release

```bash
flutter build appbundle --release
# confirm signature:
jarsigner -verify -verbose -certs build/app/outputs/bundle/release/app-release.aab | head
```

The upload key must be registered in Google Play Console. Keep a secure,
offline backup of the keystore; losing it means losing the ability to update
the app under the same certificate.
