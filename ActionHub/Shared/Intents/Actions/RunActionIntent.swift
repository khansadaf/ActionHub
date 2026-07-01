//
//  RunActionIntent.swift
//  ActionHub
//

import AppIntents

struct RunActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Run Action"
    static var description = IntentDescription("Runs a saved action and records the execution.")
    static var openAppWhenRun = false

    @Parameter(title: "Action")
    var action: ActionEntity

    init() {}

    init(action: ActionEntity) {
        self.init()
        self.action = action
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Run \(\.$action)")
    }

    func perform() async throws -> some IntentResult & ProvidesDialog {
        let title = try await MainActor.run { () throws -> String in
            let updatedAction = try ActionRepository.shared.run(id: action.id)
            return updatedAction.title
        }
        return .result(dialog: "Ran \(title).")
    }
}
