//
//  Action.swift
//  ActionHub
//

import Foundation
import SwiftData

@Model
final class Action {
    var id: UUID
    var title: String
    var details: String
    var notes: String?
    var isEnabled: Bool
    var isFavorite: Bool
    var sortOrder: Int
    var createdAt: Date
    var updatedAt: Date

    var category: Category?

    @Relationship(deleteRule: .cascade, inverse: \ExecutionHistory.action)
    var executionHistory: [ExecutionHistory]

    init(
        id: UUID = UUID(),
        title: String,
        details: String = "",
        notes: String? = nil,
        isEnabled: Bool = true,
        isFavorite: Bool = false,
        sortOrder: Int = 0,
        createdAt: Date = .now,
        updatedAt: Date = .now,
        category: Category? = nil,
        executionHistory: [ExecutionHistory] = []
    ) {
        self.id = id
        self.title = title
        self.details = details
        self.notes = notes
        self.isEnabled = isEnabled
        self.isFavorite = isFavorite
        self.sortOrder = sortOrder
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.category = category
        self.executionHistory = executionHistory
    }
}
