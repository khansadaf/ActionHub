//
//  ActionLiveActivityManager.swift
//  ActionHub
//

import ActivityKit
import Foundation

@MainActor
enum ActionLiveActivityManager {
    private static var activeActivities: [UUID: Activity<ActionActivityAttributes>] = [:]

    static var areActivitiesEnabled: Bool {
        ActivityAuthorizationInfo().areActivitiesEnabled
    }

    static func beginRun(for action: Action) {
        guard areActivitiesEnabled else { return }

        endExistingActivity(for: action.id)

        let attributes = ActionActivityAttributes(
            actionID: action.id,
            title: action.title
        )
        let state = ActionActivityAttributes.ContentState(
            phase: .running,
            message: runningMessage(for: action)
        )

        do {
            let activity = try Activity.request(
                attributes: attributes,
                content: ActivityContent(state: state, staleDate: nil),
                pushType: nil
            )
            activeActivities[action.id] = activity
        } catch {
            NSLog("Failed to start Live Activity for action \(action.id): \(error.localizedDescription)")
        }
    }

    static func completeRun(for action: Action, status: ExecutionStatus) {
        Task {
            await finishRun(for: action, status: status)
        }
    }

    static func endAll() async {
        for activity in Activity<ActionActivityAttributes>.activities {
            await activity.end(nil, dismissalPolicy: .immediate)
        }
        activeActivities.removeAll()
    }

    private static func finishRun(for action: Action, status: ExecutionStatus) async {
        guard let activity = activeActivities[action.id] else { return }

        let phase: ActionActivityAttributes.Phase = status == .success ? .completed : .failed
        let state = ActionActivityAttributes.ContentState(
            phase: phase,
            message: completionMessage(for: action, status: status)
        )
        let content = ActivityContent(state: state, staleDate: nil)

        await activity.update(content)

        try? await Task.sleep(for: .seconds(2))
        await activity.end(content, dismissalPolicy: .default)
        activeActivities[action.id] = nil
    }

    private static func endExistingActivity(for actionID: UUID) {
        guard let existing = activeActivities[actionID] else { return }

        Task {
            await existing.end(nil, dismissalPolicy: .immediate)
            activeActivities[actionID] = nil
        }
    }

    private static func runningMessage(for action: Action) -> String {
        if !action.details.isEmpty {
            return action.details
        }
        return "Running \(action.title)…"
    }

    private static func completionMessage(for action: Action, status: ExecutionStatus) -> String {
        switch status {
        case .success:
            return "\(action.title) completed"
        case .failure:
            return "\(action.title) failed"
        case .cancelled:
            return "\(action.title) cancelled"
        }
    }
}
