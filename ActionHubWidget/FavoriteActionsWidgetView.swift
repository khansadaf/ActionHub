//
//  FavoriteActionsWidgetView.swift
//  ActionHubWidget
//

import SwiftUI
import WidgetKit

struct FavoriteActionsWidgetView: View {
    let entry: FavoriteActionsEntry

    var body: some View {
        Group {
            if entry.actions.isEmpty {
                emptyState
            } else {
                favoritesGrid
            }
        }
        .containerBackground(.fill.tertiary, for: .widget)
    }

    private var emptyState: some View {
        VStack(spacing: 8) {
            Image(systemName: "star")
                .font(.title2)
                .foregroundStyle(.secondary)

            Text(ActionHubCopy.noFavoritesTitle)
                .font(.headline)

            Text(ActionHubCopy.favoritesEmptyDescription)
                .font(.caption)
                .foregroundStyle(.secondary)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding()
    }

    private var favoritesGrid: some View {
        VStack(alignment: .leading, spacing: 10) {
            Label(ActionHubCopy.favoritesSectionTitle, systemImage: "star.fill")
                .font(.caption.weight(.semibold))
                .foregroundStyle(.secondary)

            LazyVGrid(
                columns: [GridItem(.flexible()), GridItem(.flexible())],
                spacing: 8
            ) {
                ForEach(entry.actions.prefix(4), id: \.id) { action in
                    FavoriteActionButton(action: action)
                }
            }
        }
        .padding()
    }
}

private struct FavoriteActionButton: View {
    let action: ActionEntity

    var body: some View {
        VStack(alignment: .leading, spacing: 6) {
            HStack {
                Text(action.title)
                    .font(.subheadline.weight(.semibold))
                    .lineLimit(2)
                    .multilineTextAlignment(.leading)

                Spacer(minLength: 0)

                Button(intent: FavoriteActionIntent(action: action, favorite: false)) {
                    Image(systemName: "star.fill")
                        .font(.caption)
                }
                .buttonStyle(.plain)
                .accessibilityLabel("Remove from favorites")
            }

            if !action.details.isEmpty {
                Text(action.details)
                    .font(.caption2)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
            }

            Button(intent: RunActionIntent(action: action)) {
                Label("Run", systemImage: "play.fill")
                    .font(.caption.weight(.semibold))
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.small)
            .disabled(!action.isEnabled)
        }
        .padding(10)
        .background(.background.opacity(0.55), in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview("Populated", as: .systemMedium) {
    FavoriteActionsWidget()
} timeline: {
    FavoriteActionsEntry.preview
}

#Preview("Empty", as: .systemMedium) {
    FavoriteActionsWidget()
} timeline: {
    FavoriteActionsEntry(date: .now, actions: [])
}
