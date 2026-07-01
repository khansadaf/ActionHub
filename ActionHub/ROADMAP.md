# Roadmap

This roadmap reflects the **actual state of the codebase**. Items are not marked complete unless implemented.

---

## Completed

### Core app

- [x] SwiftUI `NavigationSplitView` shell (`ContentView`)
- [x] Home screen with action list, search, and empty states (`HomeView`, `HomeViewModel`)
- [x] Action row component with category icon and metadata (`ActionRowView`)
- [x] Action detail screen with run, favorite, status, and links (`ActionDetailView`)
- [x] Copy deep link / universal link URLs from detail screen

### Data layer

- [x] SwiftData models: `Action`, `Category`, `ExecutionHistory`
- [x] App Group shared store (`ModelContainerSetup`, `group.com.sadaf.ActionHub`)
- [x] Centralized `ActionRepository` with Spotlight, widget, shortcut, and Live Activity side effects

### System integration

- [x] App Intents: create, run, delete, duplicate, favorite, open
- [x] `ActionEntity` + `ActionEntityQuery` (entity search for Shortcuts)
- [x] App Shortcuts provider with Siri phrases (`ActionHubAppShortcuts`)
- [x] Shortcut donation on repository mutations (`ShortcutDonationService`)
- [x] Favorite Actions interactive widget (medium + large)
- [x] Live Activities on action run (Lock Screen + Dynamic Island)
- [x] Core Spotlight indexing (`ActionIndexingService`)
- [x] Custom URL scheme deep links (`actionhub://`)
- [x] Universal Link URL parsing + associated domains entitlement
- [x] AASA template in `Config/apple-app-site-association`
- [x] Deep link routing (`DeepLinkRouterState`, `DeepLinkCenter`, `DeepLinkParser`)

### Project infrastructure

- [x] Widget extension target embedded in main app
- [x] Shared code folder synchronized across targets
- [x] Xcode shared schemes (`ActionHub`, `ActionHubWidgetExtension`)
- [x] Open-source documentation and GitHub templates

---

## In Progress

- [ ] Repository publication (GitHub remote, screenshots, maintainer contact emails)
- [ ] Replace `YOUR_USERNAME` placeholders in README and CHANGELOG

---

## Planned

### App features

- [ ] Action editing UI (title, details, notes, enabled state)
- [ ] Category creation and assignment UI
- [ ] Onboarding / first-run experience
- [ ] Settings screen (App Group diagnostics, reindex Spotlight, about)

### Quality

- [ ] Wire `ActionHubTests` to an Xcode unit test target
- [ ] Unit tests for `DeepLinkParser`, `ActionSearchFilter`, `ActionRepository`
- [ ] UI tests for home and detail flows
- [ ] Swift 6 language mode migration (project currently uses Swift 5.0)

### Distribution

- [ ] Host `apple-app-site-association` on `actionhub.app` for production Universal Links
- [ ] App Store metadata and screenshots
- [ ] TestFlight beta channel

### Future work (not started)

- [ ] iCloud sync across devices
- [ ] Action templates / import-export
- [ ] macOS or watchOS companions
- [ ] Localization (strings currently inline / `ActionHubCopy`)

---

## How to propose changes

Open a [feature request](.github/ISSUE_TEMPLATE/feature_request.md) or comment on an existing issue before starting large features.

See [CONTRIBUTING.md](CONTRIBUTING.md) for development guidelines.
