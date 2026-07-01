//
//  ActionLiveActivity.swift
//  ActionHubWidget
//

import ActivityKit
import SwiftUI
import WidgetKit

struct ActionLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: ActionActivityAttributes.self) { context in
            ActionLiveActivityLockScreenView(context: context)
                .activityBackgroundTint(.black.opacity(0.75))
                .activitySystemActionForegroundColor(.white)
                .widgetURL(DeepLinkURLBuilder.customURL(for: .action(context.attributes.actionID)))
        } dynamicIsland: { context in
            DynamicIsland {
                DynamicIslandExpandedRegion(.leading) {
                    Image(systemName: ActionActivityPhaseStyle.iconName(for: context.state.phase))
                        .foregroundStyle(ActionActivityPhaseStyle.tintColor(for: context.state.phase))
                }

                DynamicIslandExpandedRegion(.center) {
                    VStack(alignment: .leading, spacing: 2) {
                        Text(context.attributes.title)
                            .font(.headline)
                        Text(context.state.message)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .lineLimit(2)
                    }
                }

                DynamicIslandExpandedRegion(.trailing) {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .opacity(context.state.phase == .running ? 1 : 0)
                }
            } compactLeading: {
                Image(systemName: ActionActivityPhaseStyle.iconName(for: context.state.phase))
                    .foregroundStyle(ActionActivityPhaseStyle.tintColor(for: context.state.phase))
            } compactTrailing: {
                if context.state.phase == .running {
                    ProgressView()
                        .progressViewStyle(.circular)
                } else {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.green)
                }
            } minimal: {
                Image(systemName: ActionActivityPhaseStyle.iconName(for: context.state.phase))
                    .foregroundStyle(ActionActivityPhaseStyle.tintColor(for: context.state.phase))
            }
            .widgetURL(DeepLinkURLBuilder.customURL(for: .action(context.attributes.actionID)))
        }
    }
}

private struct ActionLiveActivityLockScreenView: View {
    let context: ActivityViewContext<ActionActivityAttributes>

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: ActionActivityPhaseStyle.iconName(for: context.state.phase))
                .font(.title2)
                .foregroundStyle(ActionActivityPhaseStyle.tintColor(for: context.state.phase))
                .frame(width: 28)

            VStack(alignment: .leading, spacing: 4) {
                Text(context.attributes.title)
                    .font(.headline)

                Text(context.state.message)
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Spacer(minLength: 0)

            if context.state.phase == .running {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .padding(.vertical, 4)
    }
}

#Preview("Notification", as: .content, using: ActionActivityAttributes.preview) {
    ActionLiveActivity()
} contentStates: {
    ActionActivityAttributes.ContentState.runningPreview
    ActionActivityAttributes.ContentState.completedPreview
}
