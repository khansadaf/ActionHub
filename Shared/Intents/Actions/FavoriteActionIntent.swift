//
//  FavoriteActionIntent.swift
//  ActionHub
//

import AppIntents

struct FavoriteActionIntent: AppIntent {
    static var title: LocalizedStringResource = "Favorite Action"
    static var description = IntentDescription("Marks or unmarks an action as a favorite.")
    static var openAppWhenRun = false

    @Parameter(title: "Action")
    var action: ActionEntity

    @Parameter(title: "Favorite", default: true)
    var favorite: Bool

    init() {}

    init(action: ActionEntity, favorite: Bool = true) {
        self.init()
        self.action = action
        self.favorite = favorite
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Update favorite for \(\.$action)") {
            \.$favorite
        }
    }

    func perform() async throws -> some IntentResult & ReturnsValue<ActionEntity> & ProvidesDialog {
        let entity = try await MainActor.run { () throws -> ActionEntity in
            let updated = try ActionRepository.shared.setFavorite(id: action.id, isFavorite: favorite)
            return ActionEntity(updated)
        }
        let message = favorite ? "Favorited \(entity.title)." : "Removed \(entity.title) from favorites."
        return .result(value: entity, dialog: IntentDialog(stringLiteral: message))
    }
}
