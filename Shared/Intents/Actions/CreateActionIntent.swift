//
//  CreateActionIntent.swift
//  ActionHub
//

import AppIntents

struct CreateActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Create Action"
    static var description = IntentDescription("Creates a new action in ActionHub.")
    static var openAppWhenRun = true

    @Parameter(title: "Title")
    var title: String

    @Parameter(title: "Details", default: "")
    var details: String

    @Parameter(title: "Notes", default: nil)
    var notes: String?

    static var parameterSummary: some ParameterSummary {
        Summary("Create \(\.$title)") {
            \.$details
            \.$notes
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<ActionEntity> & ProvidesDialog {
        let entity = try await MainActor.run { () throws -> ActionEntity in
            let created = try ActionRepository.shared.create(
                title: title,
                details: details,
                notes: notes
            )
            return ActionEntity(created)
        }
        return .result(value: entity, dialog: "Created \(entity.title).")
    }
}
