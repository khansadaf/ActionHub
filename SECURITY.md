# Security Policy

## Supported versions

| Version | Supported |
|---------|-----------|
| `main` branch (latest) | ✅ |
| Older tags | ❌ |

## Reporting a vulnerability

**Please do not report security vulnerabilities through public GitHub issues.**

If you discover a security issue, report it privately:

1. Email the maintainers (replace before publishing): **security@actionhub.app**
2. Include a clear description, steps to reproduce, and impact assessment.
3. Allow reasonable time for a fix before public disclosure.

We aim to acknowledge reports within **5 business days**.

## Scope

In scope:

- ActionHub iOS app and widget extension source in this repository
- Deep link / Universal Link handling
- App Group data storage (`group.com.sadaf.ActionHub`)
- App Intents exposed to the system

Out of scope:

- Third-party services not operated by this project
- Universal Links on `actionhub.app` unless you operate that domain
- Apple platform vulnerabilities (report those to [Apple Product Security](https://security.apple.com/))

## Security considerations for contributors

- Do not commit signing certificates, provisioning profiles, or API keys.
- Do not commit real Team IDs in the AASA file; use the template in `Config/apple-app-site-association`.
- Review App Intent parameters for unintended data exposure.
- SwiftData stores action data locally in the App Group container; there is no server-side sync in the current implementation.

## Dependency policy

ActionHub uses Apple system frameworks only (SwiftUI, SwiftData, WidgetKit, ActivityKit, AppIntents, CoreSpotlight). No third-party package dependencies are declared in the Xcode project at this time.
