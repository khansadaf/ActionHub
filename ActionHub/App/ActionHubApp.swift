//
//  ActionHubApp.swift
//  ActionHub
//
//  Created by IE01 on 30/06/26.
//

import SwiftUI
import SwiftData
import CoreSpotlight

@main
struct ActionHubApp: App {
    @State private var deepLinkRouter = DeepLinkRouterState()
    private let sharedModelContainer: ModelContainer

    init() {
        let container = ModelContainerSetup.makeShared()
        ActionRepository.shared.configure(with: container)
        sharedModelContainer = container
    }

    var body: some Scene {
        WindowGroup {
            ContentView(deepLinkRouter: deepLinkRouter)
                .onOpenURL { url in
                    deepLinkRouter.handle(url: url)
                }
                .onContinueUserActivity(CSSearchableItemActionType) { activity in
                    deepLinkRouter.handle(userActivity: activity)
                }
                .onContinueUserActivity(NSUserActivityTypeBrowsingWeb) { activity in
                    deepLinkRouter.handle(userActivity: activity)
                }
                .onReceive(NotificationCenter.default.publisher(for: .deepLinkDestinationDidChange)) { _ in
                    deepLinkRouter.consumePendingDestinationIfNeeded()
                }
        }
        .modelContainer(sharedModelContainer)
    }
}
