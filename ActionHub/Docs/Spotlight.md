# Spotlight

ActionHub indexes actions in **Core Spotlight** so users can find them from system search.

Implementation: `Shared/Services/Indexing/ActionIndexingService.swift`

## Index metadata

| Constant | Value |
|----------|-------|
| Domain identifier | `com.sadaf.ActionHub.actions` |
| Index name | `ActionHubActions` |
| Item identifier format | `{domain}.{actionUUID}` |

Each `CSSearchableItem` includes:

- **Title** — action title
- **Content description** — details or notes
- **Keywords** — title, details, notes, category name, “favorite” if applicable
- **URL** — universal link when buildable
- **Subject** — category name when present

## Indexing triggers

| Event | Method |
|-------|--------|
| App launch | `ContentView.task` → `reindexAll(actions:)` |
| Action saved/updated | `ActionRepository.saveContext` → `index(action:)` |
| Action deleted | `saveContext` → `remove(actionID:)` |

`reindexAll` clears the domain then bulk re-indexes all actions.

## Opening from Spotlight

`DeepLinkParser.destination(from: NSUserActivity)` handles `CSSearchableItemActionType`:

1. Reads `CSSearchableItemActivityIdentifier` from user info
2. Maps identifier → `UUID` via `ActionIndexingService.actionID(from:)`
3. Returns `.action(id)` destination
4. `DeepLinkRouterState` selects the action in the split view

Registered in `ActionHubApp`:

```swift
.onContinueUserActivity(CSSearchableItemActionType) { activity in
    deepLinkRouter.handle(userActivity: activity)
}
```

## App Entity indexing

`ActionEntity` conforms to `IndexedEntity` for App Intents system indexing (separate from Core Spotlight but complementary for Shortcuts discovery).

## Future work

- Throttle reindex on launch for large libraries
- Background indexing only when data changes
- Deletion of stale items when App Group store is reset

See [ROADMAP.md](../ROADMAP.md).
