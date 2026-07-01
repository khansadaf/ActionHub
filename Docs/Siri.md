# Siri and App Shortcuts

ActionHub does **not** implement a legacy SiriKit intent extension. Siri integration is provided through the **App Intents** framework and **App Shortcuts** provider.

## What is implemented

### App Shortcuts provider

`ActionHubAppShortcuts` in `Shared/Intents/AppShortcuts.swift` registers six shortcuts:

| Shortcut | Intent | Example phrase |
|----------|--------|----------------|
| Create Action | `CreateActionIntent` | “Create an action in ActionHub” |
| Run Action | `RunActionIntent` | “Run an action in ActionHub” |
| Duplicate Action | `DuplicateActionIntent` | “Duplicate an action in ActionHub” |
| Favorite Action | `FavoriteActionIntent` | “Favorite an action in ActionHub” |
| Open Action | `OpenActionIntent` | “Open an action in ActionHub” |
| Delete Action | `DeleteActionIntent` | “Delete an action in ActionHub” |

Phrases use `\(.applicationName)` so Siri substitutes the app name.

### Shortcut discovery

`ShortcutDonationService` donates intents when users perform actions in the app, improving system suggestions.

### Entity pickers

When a shortcut requires an action parameter, Siri and Shortcuts use `ActionEntity` with `ActionEntityQuery` for suggestions and string search.

## How users access shortcuts

1. **Settings → Siri & Search → ActionHub** — view suggested shortcuts
2. **Shortcuts app** — browse ActionHub actions under App Shortcuts
3. **Voice** — speak a registered phrase after the shortcut is added
4. **Widget** — interactive buttons use the same intents (not voice, but same intent surface)

## What is not implemented

- Custom SiriKit `.intentdefinition` dialogs
- Voice-only responses without opening Shortcuts UI (beyond App Intents defaults)
- Per-action custom voice phrases defined by users in-app

## Testing

1. Run the app and perform a few actions (create, run, favorite) to trigger donations.
2. Open **Shortcuts** → **App Shortcuts** → ActionHub.
3. Add a shortcut and invoke via Siri: “Hey Siri, run an action in ActionHub.”

## Related docs

- [AppIntents.md](AppIntents.md)
- [Widgets.md](Widgets.md)


See [ROADMAP.md](../ROADMAP.md).
