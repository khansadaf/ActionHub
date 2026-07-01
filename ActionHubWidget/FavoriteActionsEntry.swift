//
//  FavoriteActionsEntry.swift
//  ActionHubWidget
//

import Foundation
import WidgetKit

struct FavoriteActionsEntry: TimelineEntry {
    let date: Date
    let actions: [ActionEntity]

    static let preview = FavoriteActionsEntry(
        date: .now,
        actions: [
            ActionEntity(
                id: UUID(),
                title: "Daily Standup",
                details: "Join the team sync",
                isFavorite: true,
                isEnabled: true
            ),
            ActionEntity(
                id: UUID(),
                title: "Morning Workout",
                details: "30 minutes of exercise",
                isFavorite: true,
                isEnabled: true
            ),
        ]
    )
}
