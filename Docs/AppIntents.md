# App Intents

ActionHub exposes user actions through **App Intents**, enabling Shortcuts, the widget, and system discovery.

Implementation lives in `Shared/Intents/`.

## Intents

| Intent | File | `openAppWhenRun` | Returns |
|--------|------|------------------|---------|
| **Create Action** | `CreateActionIntent.swift` | `true` | `ActionEntity` |
| **Run Action** | `RunActionIntent.swift` | `false` | Dialog |
| **Delete Action** | `DeleteActionIntent.swift` | `false` | Dialog |
| **Duplicate Action** | `DuplicateActionIntent.swift` | `true` | `ActionEntity` |
| **Favorite Action** | `FavoriteActionIntent.swift` | `false` | `ActionEntity` |
| **Open Action** | `OpenActionIntent.swift` | `true` | — |

All mutating intents delegate to `ActionRepository` on the main actor.

## ActionEntity

`ActionEntity` conforms to:

- `AppEntity` — picker and parameter display
- `IndexedEntity` — system indexing for entity search

Properties exposed to the system:

- `id`, `title`, `details`, `isFavorite`, `isEnabled`

Initialized from SwiftData `Action` via `ActionEntity(_ action:)`.

## ActionEntityQuery

`ActionEntityQuery` implements:

- `EntityQuery` — `entities(for:)` and `suggestedEntities()`
- `EntityStringQuery` — `entities(matching:)` for text search

Backed by `ActionRepository` fetch and search methods.

## App Shortcuts

`ActionHubAppShortcuts` (`AppShortcuts.swift`) registers phrases for each intent (e.g. “Run an action in ActionHub”). See [Siri.md](Siri.md).

## Shortcut donation

`ShortcutDonationService` donates intents after repository operations so the system can suggest relevant shortcuts:

- Create → `CreateActionIntent`
- Run → `RunActionIntent`
- Delete → `DeleteActionIntent`
- Duplicate → `DuplicateActionIntent`
- Favorite → `FavoriteActionIntent`

## Widget integration

The Favorite Actions widget uses `RunActionIntent` and `FavoriteActionIntent` as interactive `Button(intent:)` actions.

## Testing intents

1. Build and run the app on device or simulator.
2. Open the **Shortcuts** app → **App Shortcuts** → ActionHub.
3. Or add actions from the Shortcuts editor using the ActionHub app entity.

## Future work

- Additional intents (toggle enabled, reorder actions)
- Intent parameters for category selection
- Localized intent titles and phrases

See [ROADMAP.md](../ROADMAP.md).
