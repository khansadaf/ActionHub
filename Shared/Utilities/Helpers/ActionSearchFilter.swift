//
//  ActionSearchFilter.swift
//  ActionHub
//

import Foundation

enum ActionSearchFilter {
    static func normalizedQuery(_ query: String) -> String {
        query.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    static func matches(_ action: Action, query: String) -> Bool {
        let normalized = normalizedQuery(query)
        guard !normalized.isEmpty else { return true }

        return action.title.localizedCaseInsensitiveContains(normalized)
            || action.details.localizedCaseInsensitiveContains(normalized)
            || (action.notes?.localizedCaseInsensitiveContains(normalized) ?? false)
            || (action.category?.name.localizedCaseInsensitiveContains(normalized) ?? false)
    }

    static func filter(_ actions: [Action], query: String) -> [Action] {
        let normalized = normalizedQuery(query)
        guard !normalized.isEmpty else { return actions }
        return actions.filter { matches($0, query: normalized) }
    }
}
