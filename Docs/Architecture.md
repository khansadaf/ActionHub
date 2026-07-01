# Architecture

This document describes how ActionHub is structured **as implemented in the repository**.

## Overview

ActionHub is a native iOS application with one widget extension. Both targets compile shared code from the `Shared/` directory and persist data through a single SwiftData store in an App Group container.

| Target | Product | Role |
|--------|---------|------|
| `ActionHub` | `ActionHub.app` | Main SwiftUI application |
| `ActionHubWidgetExtension` | `ActionHubWidgetExtension.appex` | Widgets + Live Activity UI |

**Bundle identifiers**

- App: `com.sadaf.ActionHub`
- Widget: `com.sadaf.ActionHub.ActionHubWidget`

**Deployment target:** iOS 18.0

## MVVM

The app follows Model–View–ViewModel:

```
Views (SwiftUI)
    ↕ bindings / callbacks
ViewModels (@Observable, @MainActor)
    ↕ calls
ActionRepository + SwiftData @Query
    ↕
Models (@Model)
```

### Views (`ActionHub/Views/`)

| View | Responsibility |
|------|----------------|
| `ContentView` | Root `NavigationSplitView`, Spotlight reindex on launch |
| `HomeView` | Action list, search, empty states, delete |
| `ActionDetailView` | Action metadata, run/favorite, copyable links |
| `ActionRowView` | Reusable list row |

Views use `@Query` for read-only list data where appropriate. **Mutations** go through `ActionRepository` to keep side effects consistent.

### ViewModels (`ActionHub/ViewModels/`)

| ViewModel | Responsibility |
|-----------|----------------|
| `HomeViewModel` | Search filtering, create/delete orchestration |
| `DeepLinkRouterState` | Selected action, favorites filter, URL routing |

ViewModels use the **Observation** framework (`@Observable`), not `ObservableObject`.

### Models (`Shared/Models/`)

- **SwiftData:** `Action`, `Category`, `ExecutionHistory`
- **Domain:** `ExecutionStatus` enum

## Data flow

### App launch

1. `ActionHubApp` creates `ModelContainer` via `ModelContainerSetup.makeShared()`
2. `ActionRepository.shared.configure(with:)` binds the repository to that container
3. SwiftUI scene receives `.modelContainer(sharedModelContainer)`
4. `ContentView.task` reindexes Spotlight and consumes pending deep links

### Mutation path

All create / delete / run / favorite / duplicate operations call `ActionRepository`, which:

1. Updates SwiftData via `ModelContext`
2. Saves context
3. Triggers side effects:
   - `WidgetReloadService.reloadFavoriteActions()`
   - `ActionIndexingService.index` or `remove`
   - `ShortcutDonationService` donations
   - `ActionLiveActivityManager` on run

This design prevents the UI, intents, and widget from diverging.

## Shared module (`Shared/`)

| Area | Key types |
|------|-----------|
| `Models/` | SwiftData entities |
| `Services/Persistence/` | `ActionRepository` |
| `Services/Indexing/` | `ActionIndexingService` |
| `Services/LiveActivity/` | `ActionLiveActivityManager` |
| `Intents/` | App Intents, `ActionEntity`, shortcuts |
| `LiveActivities/` | `ActionActivityAttributes`, phase styling |
| `Utilities/DeepLink/` | Parser, router, URL builder |
| `Utilities/Helpers/` | `ActionHubCopy`, `ActionSearchFilter`, widget reload |
| `App/` | `ModelContainerSetup` |

## Navigation and deep links

`DeepLinkRouterState` holds:

- `selectedActionID` — drives detail column selection
- `showFavoritesOnly` — filters home list

Entry points:

- `onOpenURL` — custom scheme and universal URLs
- `onContinueUserActivity` — Spotlight and browsing web
- `DeepLinkCenter` — intents opening the app

See [DeepLinks.md](DeepLinks.md).

## Configuration (`Config/`)

Plist fragments and templates merged at build time:

- `ActionHub-URLTypes.plist` — URL scheme, Live Activities flag
- `ActionHubWidget-Info.plist` — widget extension Info.plist
- `apple-app-site-association` — Universal Links template (replace `TEAMID`)

## What is not implemented

- Dedicated edit form or settings screens
- Category management UI
- Server backend or sync layer
- Unit test target in Xcode (folder scaffold only)

See [ROADMAP.md](../ROADMAP.md).

## Related docs

- [SwiftData.md](SwiftData.md)
- [AppIntents.md](AppIntents.md)
- [Widgets.md](Widgets.md)
- [LiveActivities.md](LiveActivities.md)
- [Spotlight.md](Spotlight.md)
- [DeepLinks.md](DeepLinks.md)
- [Siri.md](Siri.md)
