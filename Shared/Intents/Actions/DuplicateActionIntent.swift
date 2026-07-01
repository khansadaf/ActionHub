//
//  DuplicateActionIntent.swift
//  ActionHub
//

import AppIntents

struct DuplicateActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Duplicate Action"
    static var description = IntentDescription("Creates a copy of an existing action.")
    static var openAppWhenRun = true

    @Parameter(title: "Action")
    var action: ActionEntity

    init() {}

    init(action: ActionEntity) {
        self.init()
        self.action = action
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Duplicate \(\.$action)")
    }

    func perform() async throws -> some IntentResult & ReturnsValue<ActionEntity> & ProvidesDialog {
        let entity = try await MainActor.run { () throws -> ActionEntity in
            let duplicate = try ActionRepository.shared.duplicate(id: action.id)
            return ActionEntity(duplicate)
        }
        return .result(value: entity, dialog: "Duplicated as \(entity.title).")
    }
}
