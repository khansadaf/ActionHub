//
//  ActionActivityAttributes.swift
//  ActionHub
//

import ActivityKit
import Foundation

struct ActionActivityAttributes: ActivityAttributes {
    enum Phase: String, Codable, Hashable, Sendable {
        case running
        case completed
        case failed
    }

    struct ContentState: Codable, Hashable, Sendable {
        var phase: Phase
        var message: String
    }

    var actionID: UUID
    var title: String
}

extension ActionActivityAttributes {
    static let preview = ActionActivityAttributes(
        actionID: UUID(),
        title: "Daily Standup"
    )
}

extension ActionActivityAttributes.ContentState {
    static let runningPreview = ActionActivityAttributes.ContentState(
        phase: .running,
        message: "Join the team sync at 9 AM"
    )

    static let completedPreview = ActionActivityAttributes.ContentState(
        phase: .completed,
        message: "Action completed successfully"
    )
}
