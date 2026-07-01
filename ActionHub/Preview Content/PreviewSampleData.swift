//
//  PreviewSampleData.swift
//  ActionHub
//

import Foundation
import SwiftData

enum PreviewSampleData {
    @MainActor
    static var emptyContainer: ModelContainer {
        let container = ModelContainerSetup.makeShared(isStoredInMemoryOnly: true)
        ActionRepository.shared.configure(with: container)
        return container
    }

    @MainActor
    static var populatedContainer: ModelContainer {
        let container = ModelContainerSetup.makeShared(isStoredInMemoryOnly: true)
        ActionRepository.shared.configure(with: container)
        insertSampleData(into: container.mainContext)
        return container
    }

    @MainActor
    static func insertSampleData(into context: ModelContext) {
        let work = Category(
            name: "Work",
            iconName: "briefcase.fill",
            colorHex: "#007AFF",
            sortOrder: 0
        )
        let personal = Category(
            name: "Personal",
            iconName: "house.fill",
            colorHex: "#34C759",
            sortOrder: 1
        )

        let standup = Action(
            title: "Daily Standup",
            details: "Join the team sync at 9 AM",
            isFavorite: true,
            sortOrder: 0,
            category: work
        )
        let weeklyReport = Action(
            title: "Weekly Report",
            details: "Summarize progress and blockers",
            sortOrder: 1,
            category: work
        )
        let workout = Action(
            title: "Morning Workout",
            details: "30 minutes of exercise",
            isFavorite: true,
            sortOrder: 2,
            category: personal
        )
        let disabledAction = Action(
            title: "Archive Emails",
            details: "Move messages older than 90 days",
            isEnabled: false,
            sortOrder: 3,
            category: personal
        )

        standup.executionHistory.append(
            ExecutionHistory(executedAt: .now.addingTimeInterval(-3600), status: .success, action: standup)
        )
        workout.executionHistory.append(
            ExecutionHistory(executedAt: .now.addingTimeInterval(-86400), status: .success, action: workout)
        )

        context.insert(work)
        context.insert(personal)
        context.insert(standup)
        context.insert(weeklyReport)
        context.insert(workout)
        context.insert(disabledAction)
    }
}
