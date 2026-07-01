//
//  OpenActionIntent.swift
//  ActionHub
//

import AppIntents

struct OpenActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Open Action"
    static var description = IntentDescription("Opens an action in ActionHub.")
    static var openAppWhenRun = true

    @Parameter(title: "Action")
    var action: ActionEntity

    init() {}

    init(action: ActionEntity) {
        self.init()
        self.action = action
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Open \(\.$action)")
    }

    @MainActor
    func perform() async throws -> some IntentResult {
        DeepLinkCenter.open(.action(action.id))
        return .result()
    }
}
