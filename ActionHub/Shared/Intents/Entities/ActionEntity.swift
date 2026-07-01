//
//  ActionEntity.swift
//  ActionHub
//

import AppIntents
import Foundation

struct ActionEntity: AppEntity, IndexedEntity {
    static var typeDisplayRepresentation = TypeDisplayRepresentation(name: "Action")
    static var defaultQuery = ActionEntityQuery()

    var id: UUID

    @Property(title: "Title")
    var title: String

    @Property(title: "Details")
    var details: String

    @Property(title: "Favorite")
    var isFavorite: Bool

    @Property(title: "Enabled")
    var isEnabled: Bool

    var displayRepresentation: DisplayRepresentation {
        DisplayRepresentation(
            title: "\(title)",
            subtitle: details.isEmpty ? nil : "\(details)",
            image: .init(systemName: isFavorite ? "star.fill" : "bolt.fill")
        )
    }

    init(id: UUID, title: String, details: String, isFavorite: Bool, isEnabled: Bool = true) {
        self.id = id
        self.title = title
        self.details = details
        self.isFavorite = isFavorite
        self.isEnabled = isEnabled
    }

    init(_ action: Action) {
        self.id = action.id
        self.title = action.title
        self.details = action.details
        self.isFavorite = action.isFavorite
        self.isEnabled = action.isEnabled
    }
}
