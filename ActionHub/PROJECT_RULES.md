# Project Rules

ActionHub is a Swift 6, SwiftUI-first iOS app. All new code and refactors must follow these rules.

## Core Stack

| Rule | Requirement |
|------|-------------|
| **Swift 6** | Use Swift 6 language mode. Enable strict concurrency checking. Prefer `Sendable`, actors, and `@MainActor` where appropriate. |
| **SwiftUI only** | All UI is built with SwiftUI. No storyboards or XIBs. |
| **MVVM** | Views handle display and user input only. ViewModels hold presentation logic and state. Models hold data and persistence. |
| **SwiftData** | Use SwiftData for local persistence. Define models with `@Model`. Inject `ModelContext` via `@Environment` or pass explicitly in ViewModels. |
| **App Intents** | Expose user-facing actions through App Intents where the feature benefits from Shortcuts, Siri, or system integration. |
| **Observation framework** | ViewModels use `@Observable` (Observation). Do not use `ObservableObject` / `@Published` for new code. |
| **No UIKit unless required** | Avoid UIKit. Use it only when SwiftUI has no equivalent (e.g. certain document pickers, legacy APIs). Wrap UIKit in `UIViewRepresentable` / `UIViewControllerRepresentable` at the boundary. |

## Architecture

### MVVM layout

```
ActionHub/
├── App/                 # App entry, model container setup
├── Models/              # SwiftData @Model types
├── ViewModels/          # @Observable presentation logic
├── Views/               # SwiftUI views
│   └── Components/      # Small reusable UI pieces
├── Intents/             # App Intents definitions
└── Utilities/           # Shared helpers (no UI)
```

- **Views** — Declarative UI, bindings to ViewModel properties, minimal logic.
- **ViewModels** — `@Observable`, `@MainActor` when touching UI state. No SwiftUI imports unless unavoidable.
- **Models** — SwiftData entities and plain value types. No view or ViewModel references.

### Observation

```swift
@Observable
@MainActor
final class ExampleViewModel {
    var title = ""
    var isLoading = false
}
```

Views observe ViewModels with `@State private var viewModel = ExampleViewModel()` or `@Bindable var viewModel`.

## UI Guidelines

- **Small reusable components** — Extract repeated UI into `Views/Components/`. Each component gets a focused responsibility and a `#Preview`.
- **Production quality** — Meaningful accessibility labels, Dynamic Type support, light/dark mode, and sensible empty/error states.
- **No duplicated code** — Shared logic lives in one place: extensions, utilities, or base components. Do not copy-paste view or ViewModel code.

## Development Workflow

- **Build after every feature** — Run a successful build (`⌘B` or `xcodebuild`) before considering a feature done.
- **Don't break existing code** — Preserve current behavior unless the task explicitly changes it. Prefer incremental refactors over large rewrites.

## Checklist (new feature)

- [ ] Swift 6 / strict concurrency satisfied
- [ ] SwiftUI + MVVM + `@Observable` ViewModel
- [ ] SwiftData model changes migrated safely
- [ ] App Intent added if the action is user-exposed to the system
- [ ] Reusable components extracted where UI repeats
- [ ] No unnecessary UIKit
- [ ] No duplicated logic or views
- [ ] Project builds cleanly
- [ ] Existing features still work
