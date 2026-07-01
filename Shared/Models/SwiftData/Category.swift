//
//  Category.swift
//  ActionHub
//

import Foundation
import SwiftData

@Model
final class Category {
    var id: UUID
    var name: String
    var iconName: String
    var colorHex: String
    var sortOrder: Int
    var createdAt: Date

    @Relationship(deleteRule: .nullify, inverse: \Action.category)
    var actions: [Action]

    init(
        id: UUID = UUID(),
        name: String,
        iconName: String = "folder",
        colorHex: String = "#007AFF",
        sortOrder: Int = 0,
        createdAt: Date = .now,
        actions: [Action] = []
    ) {
        self.id = id
        self.name = name
        self.iconName = iconName
        self.colorHex = colorHex
        self.sortOrder = sortOrder
        self.createdAt = createdAt
        self.actions = actions
    }
}
