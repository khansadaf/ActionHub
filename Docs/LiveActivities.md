# Live Activities

ActionHub uses **ActivityKit** to show real-time feedback when an action is executed.

## When activities start

`ActionRepository.run(id:)` calls:

1. `ActionLiveActivityManager.beginRun(for:)` — requests a Live Activity
2. Records `ExecutionHistory`
3. `ActionLiveActivityManager.completeRun(for:status:)` — updates and ends the activity

Activities are skipped if `ActivityAuthorizationInfo().areActivitiesEnabled` is `false`.

## Attributes

`ActionActivityAttributes` (`Shared/LiveActivities/ActionActivityAttributes.swift`):

**Static**

- `actionID: UUID`
- `title: String`

**Dynamic state (`ContentState`)**

- `phase: Phase` — `.running`, `.completed`, `.failed`
- `message: String`

## UI

Live Activity UI is implemented in the **widget extension**:

- `ActionLiveActivity.swift` — `ActivityConfiguration`
- Lock Screen layout: `ActionLiveActivityLockScreenView`
- Dynamic Island: expanded, compact, and minimal regions
- Styling via `ActionActivityPhaseStyle` (shared icon and tint colors)

Tapping the activity opens the app via deep link to the action (`DeepLinkURLBuilder`).

## Info.plist

`Config/ActionHub-URLTypes.plist` sets:

```xml
<key>NSSupportsLiveActivities</key>
<true/>
```

## Lifecycle

1. **Begin** — phase `.running`, progress indicator shown
2. **Complete** — phase `.completed` or `.failed`, brief display
3. **End** — dismissed after ~2 seconds (`dismissalPolicy: .default`)

`ActionLiveActivityManager` tracks active activities per action ID and ends duplicates before starting a new run.


See [ROADMAP.md](../ROADMAP.md).
