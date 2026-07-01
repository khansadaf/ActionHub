//
//  ActionDetailView.swift
//  ActionHub
//

import SwiftUI
import UIKit

struct ActionDetailView: View {
    let action: Action
    @State private var errorMessage: String?
    @State private var copiedLinkID: String?

    var body: some View {
        List {
            Section {
                LabeledContent("Title", value: action.title)

                if !action.details.isEmpty {
                    LabeledContent("Details", value: action.details)
                }

                if let notes = action.notes, !notes.isEmpty {
                    LabeledContent("Notes", value: notes)
                }
            }

            if let category = action.category {
                Section("Category") {
                    Label(category.name, systemImage: category.iconName)
                }
            }

            Section("Status") {
                LabeledContent("Enabled", value: action.isEnabled ? "Yes" : "No")
                LabeledContent("Favorite", value: action.isFavorite ? "Yes" : "No")
                LabeledContent("Runs", value: "\(action.executionHistory.count)")

                if let lastRun = action.executionHistory.map(\.executedAt).max() {
                    LabeledContent("Last Run") {
                        Text(lastRun, format: .relative(presentation: .named))
                    }
                }
            }

            if let deepLink = DeepLinkURLBuilder.customURL(for: .action(action.id)),
               let universalLink = DeepLinkURLBuilder.universalURL(for: .action(action.id)) {
                Section("Links") {
                    CopyableLinkRow(
                        title: ActionHubCopy.deepLinkTitle,
                        urlString: deepLink.absoluteString,
                        copiedLinkID: $copiedLinkID
                    )

                    CopyableLinkRow(
                        title: ActionHubCopy.universalLinkTitle,
                        urlString: universalLink.absoluteString,
                        copiedLinkID: $copiedLinkID
                    )
                }
            }

            if let errorMessage {
                Section {
                    Text(errorMessage)
                        .foregroundStyle(.red)
                        .font(.footnote)
                }
            }
        }
        .navigationTitle(action.title)
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItemGroup(placement: .topBarTrailing) {
                Button {
                    toggleFavorite()
                } label: {
                    Label(
                        action.isFavorite ? "Unfavorite" : "Favorite",
                        systemImage: action.isFavorite ? "star.fill" : "star"
                    )
                }

                Button {
                    runAction()
                } label: {
                    Label("Run", systemImage: "play.fill")
                }
                .disabled(!action.isEnabled)
            }
        }
    }

    private func runAction() {
        do {
            try ActionRepository.shared.run(id: action.id)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }

    private func toggleFavorite() {
        do {
            try ActionRepository.shared.setFavorite(id: action.id, isFavorite: !action.isFavorite)
            errorMessage = nil
        } catch {
            errorMessage = error.localizedDescription
        }
    }
}

private struct CopyableLinkRow: View {
    let title: String
    let urlString: String
    @Binding var copiedLinkID: String?

    private var rowID: String {
        "\(title)-\(urlString)"
    }

    private var didCopy: Bool {
        copiedLinkID == rowID
    }

    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Button {
                copyLink()
            } label: {
                Image(systemName: didCopy ? "checkmark.circle.fill" : "doc.on.doc")
                    .font(.body)
                    .foregroundStyle(didCopy ? .green : .accentColor)
                    .frame(width: 28, height: 28)
            }
            .buttonStyle(.plain)
            .accessibilityLabel(didCopy ? ActionHubCopy.linkCopiedAccessibility : ActionHubCopy.copyLinkAccessibility)

            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.subheadline)

                Text(urlString)
                    .font(.footnote)
                    .foregroundStyle(.secondary)
                    .textSelection(.enabled)
            }
        }
        .padding(.vertical, 2)
        .sensoryFeedback(.success, trigger: didCopy)
    }

    private func copyLink() {
        UIPasteboard.general.string = urlString
        copiedLinkID = rowID

        Task { @MainActor in
            try? await Task.sleep(for: .seconds(1.5))
            if copiedLinkID == rowID {
                copiedLinkID = nil
            }
        }
    }
}
