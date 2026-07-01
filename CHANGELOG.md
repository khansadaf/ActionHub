# Changelog

All notable changes to this project are documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.1.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

### Added

- Open-source repository documentation (`README`, `Docs/`, GitHub templates, CI workflow)
- Copy buttons for deep link and universal link URLs on the action detail screen

### Changed

- Unified persistence through `ActionRepository.configure(with:)` shared across app and extensions
- Replaced placeholder detail view with `ActionDetailView` (run, favorite, links)

## [0.1.0] - 2026-06-30

Initial implementation.

### Added

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

[Unreleased]: https://github.com/YOUR_USERNAME/ActionHub/compare/v0.1.0...HEAD
[0.1.0]: https://github.com/YOUR_USERNAME/ActionHub/releases/tag/v0.1.0
