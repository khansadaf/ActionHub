//
//  ActionIndexingService.swift
//  ActionHub
//

import CoreSpotlight
import Foundation
import UniformTypeIdentifiers

enum ActionIndexingService {
    static let domainIdentifier = "com.sadaf.ActionHub.actions"
    static let indexName = "ActionHubActions"

    static func searchableItemIdentifier(for actionID: UUID) -> String {
        "\(domainIdentifier).\(actionID.uuidString)"
    }

    static func actionID(from searchableItemIdentifier: String) -> UUID? {
        let prefix = "\(domainIdentifier)."
        guard searchableItemIdentifier.hasPrefix(prefix) else { return nil }
        return UUID(uuidString: String(searchableItemIdentifier.dropFirst(prefix.count)))
    }

    @MainActor
    static func index(action: Action) {
        let attributeSet = searchableItemAttributes(for: action)
        let item = CSSearchableItem(
            uniqueIdentifier: searchableItemIdentifier(for: action.id),
            domainIdentifier: domainIdentifier,
            attributeSet: attributeSet
        )
        CSSearchableIndex.default().indexSearchableItems([item]) { error in
            if let error {
                NSLog("Spotlight indexing failed for action \(action.id): \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    static func indexAll(actions: [Action]) {
        let items = actions.map { action in
            CSSearchableItem(
                uniqueIdentifier: searchableItemIdentifier(for: action.id),
                domainIdentifier: domainIdentifier,
                attributeSet: searchableItemAttributes(for: action)
            )
        }

        CSSearchableIndex.default().indexSearchableItems(items) { error in
            if let error {
                NSLog("Spotlight bulk indexing failed: \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    static func remove(actionID: UUID) {
        CSSearchableIndex.default().deleteSearchableItems(
            withIdentifiers: [searchableItemIdentifier(for: actionID)]
        ) { error in
            if let error {
                NSLog("Spotlight deletion failed for action \(actionID): \(error.localizedDescription)")
            }
        }
    }

    @MainActor
    static func reindexAll(actions: [Action]) {
        CSSearchableIndex.default().deleteSearchableItems(withDomainIdentifiers: [domainIdentifier]) { error in
            if let error {
                NSLog("Spotlight domain reset failed: \(error.localizedDescription)")
            } else {
                indexAll(actions: actions)
            }
        }
    }

    @MainActor
    private static func searchableItemAttributes(for action: Action) -> CSSearchableItemAttributeSet {
        let attributeSet = CSSearchableItemAttributeSet(itemContentType: UTType.content.identifier)
        attributeSet.title = action.title
        attributeSet.contentDescription = action.details.isEmpty ? action.notes : action.details
        attributeSet.keywords = spotlightKeywords(for: action)
        attributeSet.relatedUniqueIdentifier = action.id.uuidString
        attributeSet.domainIdentifier = domainIdentifier

        if let category = action.category {
            attributeSet.subject = category.name
        }

        if let deepLink = DeepLinkURLBuilder.universalURL(for: .action(action.id)) {
            attributeSet.url = deepLink
        }

        return attributeSet
    }

    private static func spotlightKeywords(for action: Action) -> [String] {
        var keywords = [action.title, "action", "actionhub"]

        if !action.details.isEmpty {
            keywords.append(action.details)
        }

        if let notes = action.notes, !notes.isEmpty {
            keywords.append(notes)
        }

        if let category = action.category {
            keywords.append(category.name)
        }

        if action.isFavorite {
            keywords.append("favorite")
        }

        return keywords
    }
}
