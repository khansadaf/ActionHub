//
//  ContentView.swift
//  ActionHub
//
//  Created by IE01 on 30/06/26.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query(sort: \Action.sortOrder) private var actions: [Action]
    @Bindable var deepLinkRouter: DeepLinkRouterState

    var body: some View {
        NavigationSplitView {
            HomeView(
                selectedActionID: $deepLinkRouter.selectedActionID,
                showFavoritesOnly: $deepLinkRouter.showFavoritesOnly
            )
        } detail: {
            detailContent
        }
        .task {
            ActionIndexingService.reindexAll(actions: actions)
            deepLinkRouter.consumePendingDestinationIfNeeded()
        }
    }

    @ViewBuilder
    private var detailContent: some View {
        if let selectedActionID = deepLinkRouter.selectedActionID,
           let action = actions.first(where: { $0.id == selectedActionID }) {
            ActionDetailView(action: action)
        } else {
            ContentUnavailableView(
                ActionHubCopy.selectActionTitle,
                systemImage: "bolt.fill",
                description: Text(ActionHubCopy.selectActionDescription)
            )
        }
    }
}

#Preview {
    ContentView(deepLinkRouter: DeepLinkRouterState())
        .modelContainer(PreviewSampleData.populatedContainer)
}
