//
//  ActionRepository.swift
//  ActionHub
//

import Foundation
import SwiftData

@MainActor
final class ActionRepository {
    static let shared = ActionRepository()

    private var container: ModelContainer?

    private init() {}

    func configure(with container: ModelContainer) {
        self.container = container
    }

    private var context: ModelContext {
        if container == nil {
            configure(with: ModelContainerSetup.makeShared())
        }
        return container!.mainContext
    }

    func fetchAll() -> [Action] {
        let descriptor = FetchDescriptor<Action>(sortBy: [SortDescriptor(\.sortOrder)])
        return (try? context.fetch(descriptor)) ?? []
    }

    func fetch(ids: [UUID]) -> [Action] {
        guard !ids.isEmpty else { return [] }

        let descriptor = FetchDescriptor<Action>(
            predicate: #Predicate { ids.contains($0.id) },
            sortBy: [SortDescriptor(\.sortOrder)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    func search(matching query: String) -> [Action] {
        ActionSearchFilter.filter(fetchAll(), query: query)
    }

    func fetchFavorites() -> [Action] {
        let descriptor = FetchDescriptor<Action>(
            predicate: #Predicate { $0.isFavorite },
            sortBy: [SortDescriptor(\.sortOrder)]
        )
        return (try? context.fetch(descriptor)) ?? []
    }

    @discardableResult
    func create(title: String, details: String = "", notes: String? = nil) throws -> Action {
        let action = Action(
            title: title,
            details: details,
            notes: notes,
            sortOrder: nextSortOrder()
        )
        context.insert(action)
        try saveContext(updatedAction: action)
        ShortcutDonationService.donateCreate(title: title)
        return action
    }

    @discardableResult
    func createDefaultAction() throws -> Action {
        try create(
            title: ActionHubCopy.newActionTitle,
            details: ActionHubCopy.newActionDetails
        )
    }

    func delete(id: UUID) throws {
        guard let action = fetch(ids: [id]).first else {
            throw ActionRepositoryError.actionNotFound
        }

        ShortcutDonationService.donateDelete(action: action)
        let actionID = action.id
        context.delete(action)
        try saveContext(deletedActionID: actionID)
    }

    @discardableResult
    func duplicate(id: UUID) throws -> Action {
        guard let source = fetch(ids: [id]).first else {
            throw ActionRepositoryError.actionNotFound
        }

        let duplicate = Action(
            title: uniqueDuplicateTitle(for: source.title),
            details: source.details,
            notes: source.notes,
            isEnabled: source.isEnabled,
            isFavorite: false,
            sortOrder: nextSortOrder(),
            category: source.category
        )
        context.insert(duplicate)
        try saveContext(updatedAction: duplicate)
        ShortcutDonationService.donateDuplicate(action: duplicate)
        return duplicate
    }

    @discardableResult
    func setFavorite(id: UUID, isFavorite: Bool) throws -> Action {
        guard let action = fetch(ids: [id]).first else {
            throw ActionRepositoryError.actionNotFound
        }

        action.isFavorite = isFavorite
        action.updatedAt = .now
        try saveContext(updatedAction: action)
        ShortcutDonationService.donateFavorite(action: action)
        return action
    }

    @discardableResult
    func run(id: UUID) throws -> Action {
        guard let action = fetch(ids: [id]).first else {
            throw ActionRepositoryError.actionNotFound
        }

        guard action.isEnabled else {
            throw ActionRepositoryError.actionDisabled
        }

        ActionLiveActivityManager.beginRun(for: action)

        let history = ExecutionHistory(status: .success, action: action)
        action.executionHistory.append(history)
        action.updatedAt = .now
        try saveContext(updatedAction: action)
        ShortcutDonationService.donateRun(action: action)
        ActionLiveActivityManager.completeRun(for: action, status: .success)
        return action
    }

    private func saveContext(
        deletedActionID: UUID? = nil,
        updatedAction: Action? = nil
    ) throws {
        try context.save()
        WidgetReloadService.reloadFavoriteActions()

        if let deletedActionID {
            ActionIndexingService.remove(actionID: deletedActionID)
        } else if let updatedAction {
            ActionIndexingService.index(action: updatedAction)
        }
    }

    private func nextSortOrder() -> Int {
        (fetchAll().map(\.sortOrder).max() ?? -1) + 1
    }

    private func uniqueDuplicateTitle(for title: String) -> String {
        let baseTitle = title.hasSuffix(" Copy") ? String(title.dropLast(5)) : title
        let existingTitles = Set(fetchAll().map(\.title))
        var candidate = "\(baseTitle) Copy"
        var copyIndex = 2

        while existingTitles.contains(candidate) {
            candidate = "\(baseTitle) Copy \(copyIndex)"
            copyIndex += 1
        }

        return candidate
    }
}

enum ActionRepositoryError: LocalizedError {
    case actionNotFound
    case actionDisabled

    var errorDescription: String? {
        switch self {
        case .actionNotFound:
            "The action could not be found."
        case .actionDisabled:
            "This action is disabled and cannot be run."
        }
    }
}
