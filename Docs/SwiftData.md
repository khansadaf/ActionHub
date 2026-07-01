# SwiftData

ActionHub persists all local data with **SwiftData**. Models live in `Shared/Models/SwiftData/` and are included in both the app and widget extension targets via the synchronized `Shared/` folder.

## Schema

Registered in `ModelContainerSetup`:

```swift
Schema([
    Category.self,
    Action.self,
    ExecutionHistory.self,
])
```

## Models

### `Action`

Primary entity representing a user-defined action.

| Property | Type | Notes |
|----------|------|-------|
| `id` | `UUID` | Stable identifier for deep links and intents |
| `title` | `String` | Display name |
| `details` | `String` | Short description |
| `notes` | `String?` | Optional long-form notes |
| `isEnabled` | `Bool` | Disabled actions cannot run |
| `isFavorite` | `Bool` | Shown in widget and favorites filter |
| `sortOrder` | `Int` | List ordering |
| `createdAt` / `updatedAt` | `Date` | Timestamps |
| `category` | `Category?` | Optional relationship |
| `executionHistory` | `[ExecutionHistory]` | Cascade delete |

### `Category`

Optional grouping for actions (displayed in list rows and detail when set).

| Property | Type |
|----------|------|
| `name` | `String` |
| `iconName` | `String` (SF Symbol) |
| `colorHex` | `String` |
| `sortOrder` | `Int` |

**Note:** Categories exist in the data model and preview sample data, but there is **no UI to create or assign categories** in the shipping app flows yet.

### `ExecutionHistory`

Records each run of an action.

| Property | Type |
|----------|------|
| `executedAt` | `Date` |
| `status` | `ExecutionStatus` |
| `action` | `Action` |

## Storage location

`ModelContainerSetup` stores data in the App Group container:

- App Group: `group.com.sadaf.ActionHub`
- File: `ActionHub.store`

This allows the main app and widget extension to read the same database.

## Access patterns

### SwiftUI (`@Query`)

Views such as `HomeView` and `ContentView` use `@Query(sort: \Action.sortOrder)` for reactive list display.

### Repository (`ActionRepository`)

All **writes** should go through `ActionRepository`:

| Method | Behavior |
|--------|----------|
| `create(title:details:notes:)` | Insert with next `sortOrder` |
| `createDefaultAction()` | Creates placeholder title/details |
| `delete(id:)` | Delete + remove from Spotlight |
| `duplicate(id:)` | Copy with unique title |
| `setFavorite(id:isFavorite:)` | Toggle favorite |
| `run(id:)` | Append history, Live Activity, donation |
| `fetchAll()` / `fetch(ids:)` / `fetchFavorites()` / `search(matching:)` | Reads |

`ActionRepository.configure(with:)` must be called at app launch (done in `ActionHubApp.init()`).

## Preview data

`PreviewSampleData` provides in-memory containers for SwiftUI previews with sample actions and categories.

## Future work

- Category management UI
- Schema versioning / migrations as the model evolves
- Optional iCloud `ModelConfiguration` (not implemented)

See [ROADMAP.md](../ROADMAP.md).
