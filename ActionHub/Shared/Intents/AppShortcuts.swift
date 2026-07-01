//
//  AppShortcuts.swift
//  ActionHub
//

import AppIntents

struct ActionHubAppShortcuts: AppShortcutsProvider {
    static var shortcutTileColor = ShortcutTileColor.navy

    @AppShortcutsBuilder
    static var appShortcuts: [AppShortcut] {
        AppShortcut(
            intent: CreateActionIntent(),
            phrases: [
                "Create an action in \(.applicationName)",
                "Add a new action with \(.applicationName)",
                "New action in \(.applicationName)",
            ],
            shortTitle: "Create Action",
            systemImageName: "plus.circle.fill"
        )

        AppShortcut(
            intent: RunActionIntent(),
            phrases: [
                "Run an action in \(.applicationName)",
                "Execute action with \(.applicationName)",
                "Start action in \(.applicationName)",
            ],
            shortTitle: "Run Action",
            systemImageName: "play.circle.fill"
        )

        AppShortcut(
            intent: DuplicateActionIntent(),
            phrases: [
                "Duplicate an action in \(.applicationName)",
                "Copy action with \(.applicationName)",
            ],
            shortTitle: "Duplicate Action",
            systemImageName: "plus.square.on.square"
        )

        AppShortcut(
            intent: FavoriteActionIntent(),
            phrases: [
                "Favorite an action in \(.applicationName)",
                "Star action with \(.applicationName)",
                "Mark action as favorite in \(.applicationName)",
            ],
            shortTitle: "Favorite Action",
            systemImageName: "star.fill"
        )

        AppShortcut(
            intent: OpenActionIntent(),
            phrases: [
                "Open an action in \(.applicationName)",
                "Show action in \(.applicationName)",
            ],
            shortTitle: "Open Action",
            systemImageName: "arrow.up.forward.app"
        )

        AppShortcut(
            intent: DeleteActionIntent(),
            phrases: [
                "Delete an action in \(.applicationName)",
                "Remove action with \(.applicationName)",
            ],
            shortTitle: "Delete Action",
            systemImageName: "trash"
        )
    }
}
