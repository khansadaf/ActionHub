# Contributing to ActionHub

Thank you for your interest in contributing. ActionHub is a SwiftUI iOS app with a widget extension and shared SwiftData layer.

## Before you start

1. Read [PROJECT_RULES.md](PROJECT_RULES.md) for coding conventions.
2. Read [Docs/Architecture.md](Docs/Architecture.md) to understand the project layout.
3. Check [ROADMAP.md](ROADMAP.md) and open issues to avoid duplicate work.

## Development setup

1. Fork and clone the repository.
2. Open `ActionHub.xcodeproj` in Xcode 16+.
3. Configure signing for your Apple Developer team on both targets:
   - **ActionHub**
   - **ActionHubWidgetExtension**
4. Select the **ActionHub** scheme and run on an iOS 18+ simulator.

## Branch naming

| Prefix | Use |
|--------|-----|
| `feature/` | New functionality |
| `fix/` | Bug fixes |
| `docs/` | Documentation only |
| `chore/` | Tooling, CI, housekeeping |

Example: `feature/action-edit-form`

## Pull request process

1. Create a focused branch from `main`.
2. Make incremental changes; avoid large unrelated refactors.
3. Ensure the project **builds cleanly** (`⌘B` or `xcodebuild`).
4. Update documentation if you add or change user-facing behavior.
5. Fill out the [pull request](https://github.com/khansadaf/ActionHub/pulls).
6. Link related issues when applicable.

## Code guidelines

- **SwiftUI** for all UI; avoid UIKit unless required.
- **MVVM** with `@Observable` ViewModels.
- **SwiftData** for persistence; route mutations through `ActionRepository`.
- **No duplicated logic** — prefer `Shared/` utilities.
- **App Intents** for actions exposed to Shortcuts, Siri, or widgets.
- Build after every feature; do not break existing behavior without discussion.

## Testing

The `ActionHubTests/` folder is a scaffold. There is **no Xcode unit test target** wired yet (see [ROADMAP.md](ROADMAP.md)).

Until tests are added:

- Manually verify affected flows in the simulator.
- Run a command-line build before submitting:

```bash
xcodebuild -scheme ActionHub \
  -destination 'platform=iOS Simulator,name=iPhone 16' \
  build
```

## Documentation

If your change affects architecture, intents, widgets, or system integration, update the relevant file under `Docs/`.

Do **not** document features that are not implemented.

## Reporting bugs

Use the [bug report](https://github.com/khansadaf/ActionHub/issues).

Include:

- iOS version and device/simulator
- Xcode version
- Steps to reproduce
- Expected vs actual behavior
- Screenshots or logs if relevant

## Feature requests

Use the [feature request](https://github.com/khansadaf/ActionHub/issues).

## Questions

Open a [GitHub Discussion](https://github.com/khansadaf/ActionHub/discussions) (enable Discussions in repository settings) or file an issue labeled `question`.

## License

By contributing, you agree that your contributions will be licensed under the [MIT License](LICENSE).
