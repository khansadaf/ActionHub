# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## ActionHub v0.1.0 - 2026-06-30

First public release of ActionHub — an iOS action library built with SwiftUI, SwiftData, and MVVM.


### What's included

- SwiftUI home screen with search, empty states, and favorites filter
- SwiftData models: `Action`, `Category`, `ExecutionHistory`
- `ActionRepository` for centralized data mutations and side effects
- App Intents: create, run, delete, duplicate, favorite, open
- `ActionEntity` with `EntityQuery` and `EntityStringQuery`
- App Shortcuts provider with Siri phrases
- Favorite Actions interactive widget (run, unfavorite)
- Live Activities for action execution (Lock Screen + Dynamic Island)
- Core Spotlight indexing and reindex on launch
- Custom deep links (`actionhub://`) and Universal Link parsing
- Associated domains entitlement and AASA template in `Config/`
- App Group shared SwiftData store
- `NavigationSplitView` root with deep link routing

**Requires:** iOS 18+, Xcode 16+

### Not in this release
Action editing UI, category management UI, unit tests — see [ROADMAP.md](ROADMAP.md).

[MIT License](LICENSE)

[Unreleased]: https://github.com/khansadaf/ActionHub/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/khansadaf/ActionHub/releases/tag/v0.1.0
