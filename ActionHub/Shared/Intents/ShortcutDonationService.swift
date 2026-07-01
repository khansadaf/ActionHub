//
//  ShortcutDonationService.swift
//  ActionHub
//

import AppIntents
import Foundation

enum ShortcutDonationService {
    static func donateRun(action: Action) {
        donate(RunActionIntent(action: ActionEntity(action)))
    }

    static func donateCreate(title: String) {
        let intent = CreateActionIntent()
        intent.title = title
        donate(intent)
    }

    static func donateDelete(action: Action) {
        donate(DeleteActionIntent(action: ActionEntity(action)))
    }

    static func donateDuplicate(action: Action) {
        donate(DuplicateActionIntent(action: ActionEntity(action)))
    }

    static func donateFavorite(action: Action) {
        donate(FavoriteActionIntent(action: ActionEntity(action), favorite: action.isFavorite))
    }

    private static func donate<I: AppIntent>(_ intent: I) {
        Task {
            try? await intent.donate()
        }
    }
}
