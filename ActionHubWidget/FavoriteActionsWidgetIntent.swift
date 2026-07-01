//
//  FavoriteActionsWidgetIntent.swift
//  ActionHubWidget
//

import AppIntents

struct FavoriteActionsWidgetIntent: WidgetConfigurationIntent {
    static var title: LocalizedStringResource = "Favorite Actions"
    static var description = IntentDescription("Shows your starred actions for quick access.")
}
