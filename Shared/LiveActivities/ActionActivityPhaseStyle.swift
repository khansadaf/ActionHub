//
//  ActionActivityPhaseStyle.swift
//  ActionHub
//

import SwiftUI

enum ActionActivityPhaseStyle {
    static func iconName(for phase: ActionActivityAttributes.Phase) -> String {
        switch phase {
        case .running:
            "bolt.fill"
        case .completed:
            "checkmark.circle.fill"
        case .failed:
            "xmark.circle.fill"
        }
    }

    static func tintColor(for phase: ActionActivityAttributes.Phase) -> Color {
        switch phase {
        case .running:
            .blue
        case .completed:
            .green
        case .failed:
            .red
        }
    }
}
