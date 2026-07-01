//
//  DeepLinkRouterState.swift
//  ActionHub
//

import Foundation

@Observable
@MainActor
final class DeepLinkRouterState {
    var selectedActionID: UUID?
    var showFavoritesOnly = false

    func apply(_ destination: DeepLinkDestination) {
        switch destination {
        case .actions:
            showFavoritesOnly = false
        case .favorites:
            showFavoritesOnly = true
            selectedActionID = nil
        case .action(let id):
            showFavoritesOnly = false
            selectedActionID = id
        case .runAction(let id):
            showFavoritesOnly = false
            selectedActionID = id
            runActionIfPossible(id: id)
        }
    }

    func handle(url: URL) {
        guard let destination = DeepLinkParser.destination(from: url) else { return }
        apply(destination)
    }

    func handle(userActivity: NSUserActivity) {
        guard let destination = DeepLinkParser.destination(from: userActivity) else { return }
        apply(destination)
    }

    func consumePendingDestinationIfNeeded() {
        guard let destination = DeepLinkCenter.consumePendingDestination() else { return }
        apply(destination)
    }

    private func runActionIfPossible(id: UUID) {
        do {
            try ActionRepository.shared.run(id: id)
        } catch {
            NSLog("Deep link run failed for action \(id): \(error.localizedDescription)")
        }
    }
}
