//
//  FavoriteActionsProvider.swift
//  ActionHubWidget
//

import WidgetKit

struct FavoriteActionsProvider: AppIntentTimelineProvider {
    func placeholder(in context: Context) -> FavoriteActionsEntry {
        .preview
    }

    func snapshot(for configuration: FavoriteActionsWidgetIntent, in context: Context) async -> FavoriteActionsEntry {
        await loadEntry()
    }

    func timeline(for configuration: FavoriteActionsWidgetIntent, in context: Context) async -> Timeline<FavoriteActionsEntry> {
        let entry = await loadEntry()
        let nextUpdate = Calendar.current.date(byAdding: .minute, value: 15, to: .now) ?? .now.addingTimeInterval(900)
        return Timeline(entries: [entry], policy: .after(nextUpdate))
    }

    @MainActor
    private func loadEntry() -> FavoriteActionsEntry {
        let favorites = ActionRepository.shared.fetchFavorites().map(ActionEntity.init)
        return FavoriteActionsEntry(date: .now, actions: favorites)
    }
}
