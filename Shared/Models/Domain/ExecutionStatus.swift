//
//  ExecutionStatus.swift
//  ActionHub
//

import Foundation

enum ExecutionStatus: String, Codable, CaseIterable, Sendable {
    case success
    case failure
    case cancelled

    var displayName: String {
        switch self {
        case .success: "Success"
        case .failure: "Failure"
        case .cancelled: "Cancelled"
        }
    }

    var systemImageName: String {
        switch self {
        case .success: "checkmark.circle.fill"
        case .failure: "xmark.circle.fill"
        case .cancelled: "minus.circle.fill"
        }
    }
}
