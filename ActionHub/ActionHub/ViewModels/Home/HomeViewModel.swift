//
//  HomeViewModel.swift
//  ActionHub
//

import Foundation

@Observable
@MainActor
final class HomeViewModel {
    var searchText = ""

    func filteredActions(from actions: [Action]) -> [Action] {
        ActionSearchFilter.filter(actions, query: searchText)
    }

    func deleteActions(
        at offsets: IndexSet,
        from filteredActions: [Action],
        selectedActionID: inout UUID?
    ) {
        for index in offsets {
            let action = filteredActions[index]
            if selectedActionID == action.id {
                selectedActionID = nil
            }
            try? ActionRepository.shared.delete(id: action.id)
        }
    }

    func createAction(selectedActionID: inout UUID?) {
        guard let action = try? ActionRepository.shared.createDefaultAction() else { return }
        selectedActionID = action.id
    }
}
