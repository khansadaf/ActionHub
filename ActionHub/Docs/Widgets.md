# Widgets

ActionHub includes a **WidgetKit** extension that displays favorite actions and supports interactive App Intents.

Target: `ActionHubWidgetExtension`  
Code: `ActionHubWidget/`

## Favorite Actions Widget

| Property | Value |
|----------|-------|
| Kind | `WidgetReloadService.favoriteActionsWidgetKind` |
| Configuration | `AppIntentConfiguration` with `FavoriteActionsWidgetIntent` |
| Families | `.systemMedium`, `.systemLarge` |
| Provider | `FavoriteActionsProvider` |

### UI

`FavoriteActionsWidgetView` shows:

- **Empty state** when no favorites exist
- **Grid** (up to 4 actions) with title, details, run button, and unfavorite button

Each action row uses:

- `RunActionIntent` — runs the action via `ActionRepository`
- `FavoriteActionIntent(favorite: false)` — removes from favorites

### Data source

`FavoriteActionsProvider` loads favorites on the main actor:

```swift
ActionRepository.shared.fetchFavorites().map(ActionEntity.init)
```

The widget reads the same App Group SwiftData store as the main app.

### Reload

`ActionRepository` calls `WidgetReloadService.reloadFavoriteActions()` after saves so the widget timeline refreshes.

## Widget bundle

`ActionHubWidgetBundle` registers:

1. `FavoriteActionsWidget`
2. `ActionLiveActivity` (Live Activity — see [LiveActivities.md](LiveActivities.md))

## Adding the widget

1. Build and run the **ActionHub** scheme (embeds the extension).
2. Long-press Home Screen → **Edit Widgets** → search **ActionHub**.
3. Add **Favorite Actions**.

## Entitlements

Widget extension uses the same App Group: `group.com.sadaf.ActionHub`.

## Future work

- Configurable widget (pick which favorites to show)
- Small family widget
- Lock Screen widget variants

See [ROADMAP.md](../ROADMAP.md).
