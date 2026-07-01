//
//  FavoriteActionsWidget.swift
//  ActionHubWidget
//

import SwiftUI
import WidgetKit

struct FavoriteActionsWidget: Widget {
    let kind = WidgetReloadService.favoriteActionsWidgetKind

    var body: some WidgetConfiguration {
        AppIntentConfiguration(
            kind: kind,
            intent: FavoriteActionsWidgetIntent.self,
            provider: FavoriteActionsProvider()
        ) { entry in
            FavoriteActionsWidgetView(entry: entry)
        }
        .configurationDisplayName("Favorite Actions")
        .description("Run and manage your starred actions.")
        .supportedFamilies([.systemMedium, .systemLarge])
    }
}
