//
//  ActionRowView.swift
//  ActionHub
//

import SwiftUI

struct ActionRowView: View {
    let action: Action

    private var lastExecutedAt: Date? {
        action.executionHistory.map(\.executedAt).max()
    }

    var body: some View {
        HStack(spacing: 12) {
            categoryIcon

            VStack(alignment: .leading, spacing: 4) {
                Text(action.title)
                    .font(.body)
                    .fontWeight(.medium)
                    .foregroundStyle(action.isEnabled ? .primary : .secondary)

                if !action.details.isEmpty {
                    Text(action.details)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                        .lineLimit(2)
                }

                metadataRow
            }

            Spacer(minLength: 0)

            if action.isFavorite {
                Image(systemName: "star.fill")
                    .font(.caption)
                    .foregroundStyle(.yellow)
                    .accessibilityLabel("Favorite")
            }

            if !action.isEnabled {
                Image(systemName: "pause.circle")
                    .font(.body)
                    .foregroundStyle(.tertiary)
                    .accessibilityLabel("Disabled")
            }
        }
        .padding(.vertical, 4)
        .accessibilityElement(children: .combine)
        .accessibilityLabel(accessibilityLabel)
    }

    @ViewBuilder
    private var categoryIcon: some View {
        if let category = action.category {
            Image(systemName: category.iconName)
                .font(.body.weight(.semibold))
                .foregroundStyle(Color(hex: category.colorHex))
                .frame(width: 32, height: 32)
                .background(Color(hex: category.colorHex).opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)
        } else {
            Image(systemName: "bolt.fill")
                .font(.body.weight(.semibold))
                .foregroundStyle(.tint)
                .frame(width: 32, height: 32)
                .background(Color.accentColor.opacity(0.15), in: RoundedRectangle(cornerRadius: 8))
                .accessibilityHidden(true)
        }
    }

    @ViewBuilder
    private var metadataRow: some View {
        HStack(spacing: 8) {
            if let category = action.category {
                Text(category.name)
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }

            if let lastExecutedAt {
                if action.category != nil {
                    Text("·")
                        .font(.caption)
                        .foregroundStyle(.quaternary)
                }

                Text("Last run \(lastExecutedAt, format: .relative(presentation: .named))")
                    .font(.caption)
                    .foregroundStyle(.secondary)
            }
        }
    }

    private var accessibilityLabel: String {
        var components = [action.title]

        if !action.details.isEmpty {
            components.append(action.details)
        }

        if let category = action.category {
            components.append("Category: \(category.name)")
        }

        if !action.isEnabled {
            components.append("Disabled")
        }

        if action.isFavorite {
            components.append("Favorite")
        }

        if let lastExecutedAt {
            components.append("Last run \(lastExecutedAt.formatted(date: .abbreviated, time: .shortened))")
        }

        return components.joined(separator: ", ")
    }
}

#Preview("With Category") {
    let category = Category(name: "Work", iconName: "briefcase.fill", colorHex: "#007AFF")
    let action = Action(
        title: "Daily Standup",
        details: "Join the team sync at 9 AM",
        category: category
    )

    List {
        ActionRowView(action: action)
    }
    .listStyle(.insetGrouped)
}

#Preview("Disabled") {
    List {
        ActionRowView(action: Action(title: "Archive Emails", details: "Move old messages", isEnabled: false))
    }
    .listStyle(.insetGrouped)
}
