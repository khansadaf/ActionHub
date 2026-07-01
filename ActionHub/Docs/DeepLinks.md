# Deep Links and Universal Links

ActionHub supports **custom URL schemes** and **Universal Links** for navigation and action execution.

Utilities: `Shared/Utilities/DeepLink/`

## Custom URL scheme

| Property | Value |
|----------|-------|
| Scheme | `actionhub` |
| Host | `open` |

Registered in `Config/ActionHub-URLTypes.plist`.

### Routes

Built by `DeepLinkURLBuilder.customURL(for:)`:

| Destination | Path | Example |
|-------------|------|---------|
| All actions | `/actions` | `actionhub://open/actions` |
| Favorites | `/favorites` | `actionhub://open/favorites` |
| Single action | `/actions/{uuid}` | `actionhub://open/actions/…` |
| Run action | `/actions/{uuid}/run` | `actionhub://open/actions/…/run` |

Parsed by `DeepLinkParser.destination(from: URL)`.

## Universal Links

| Property | Value |
|----------|-------|
| Hosts | `actionhub.app`, `www.actionhub.app` |
| Scheme | `https` |

Same path structure as above, e.g. `https://actionhub.app/actions/{uuid}`.

### Associated domains

Entitlement in `ActionHub/ActionHub.entitlements`:

```
applinks:actionhub.app
applinks:www.actionhub.app
```

### AASA file

Template: `Config/apple-app-site-association`

Replace `TEAMID` with your Apple Developer Team ID and host the file at:

```
https://actionhub.app/.well-known/apple-app-site-association
```

**Universal Links will not verify in production until this file is hosted.** Parsing works in-app when a valid URL is opened.

## Routing

`DeepLinkRouterState` applies destinations:

| Destination | Behavior |
|-------------|----------|
| `.actions` | Show all actions |
| `.favorites` | Filter favorites, clear selection |
| `.action(id)` | Select action in detail column |
| `.runAction(id)` | Select action and call `ActionRepository.run` |

### Entry points

- `ActionHubApp.onOpenURL`
- `onContinueUserActivity(NSUserActivityTypeBrowsingWeb)`
- `OpenActionIntent` → `DeepLinkCenter.open(.action(id))`
- Live Activity `widgetURL`

## Copying links in the app

`ActionDetailView` displays deep and universal URLs with copy buttons (`UIPasteboard`).

## Future work

- Share sheet for action links
- QR code generation
- Documented URL scheme for third-party integrations

See [ROADMAP.md](../ROADMAP.md).
