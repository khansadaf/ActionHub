//
//  ExecutionHistory.swift
//  ActionHub
//

import Foundation
import SwiftData

@Model
final class ExecutionHistory {
    var id: UUID
    var executedAt: Date
    var statusRawValue: String
    var message: String?

    var action: Action?

    var status: ExecutionStatus {
        get { ExecutionStatus(rawValue: statusRawValue) ?? .failure }
        set { statusRawValue = newValue.rawValue }
    }

    init(
        id: UUID = UUID(),
        executedAt: Date = .now,
        status: ExecutionStatus,
        message: String? = nil,
        action: Action? = nil
    ) {
        self.id = id
        self.executedAt = executedAt
        self.statusRawValue = status.rawValue
        self.message = message
        self.action = action
    }
}
