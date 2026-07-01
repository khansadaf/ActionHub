//
//  WidgetReloadService.swift
//  ActionHub
//

import WidgetKit

enum WidgetReloadService {
    static let favoriteActionsWidgetKind = "FavoriteActionsWidget"

    static func reloadFavoriteActions() {
        WidgetCenter.shared.reloadTimelines(ofKind: favoriteActionsWidgetKind)
    }
}
