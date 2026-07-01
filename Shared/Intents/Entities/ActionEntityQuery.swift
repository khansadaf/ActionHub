//
//  ActionEntityQuery.swift
//  ActionHub
//

import AppIntents
import Foundation

struct ActionEntityQuery: EntityQuery, EntityStringQuery {
    @MainActor
    func entities(for identifiers: [UUID]) async throws -> [ActionEntity] {
        ActionRepository.shared.fetch(ids: identifiers).map(ActionEntity.init)
    }

    @MainActor
    func suggestedEntities() async throws -> [ActionEntity] {
        ActionRepository.shared.fetchAll().map(ActionEntity.init)
    }

    @MainActor
    func entities(matching string: String) async throws -> [ActionEntity] {
        ActionRepository.shared.search(matching: string).map(ActionEntity.init)
    }
}
