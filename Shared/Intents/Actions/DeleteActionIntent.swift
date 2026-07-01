//
//  DeleteActionIntent.swift
//  ActionHub
//

import AppIntents

struct DeleteActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Delete Action"
    static var description = IntentDescription("Deletes a saved action from ActionHub.")
    static var openAppWhenRun = false

    @Parameter(title: "Action")
    var action: ActionEntity

    init() {}

    init(action: ActionEntity) {
        self.init()
        self.action = action
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Delete \(\.$action)")
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let title = action.title
        try await MainActor.run {
            try ActionRepository.shared.delete(id: action.id)
        }
        return .result(dialog: "Deleted \(title).")
    }
}
