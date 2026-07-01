//
//  HomeView.swift
//  ActionHub
//

import SwiftUI
import SwiftData

struct HomeView: View {
    @Query(sort: \Action.sortOrder) private var actions: [Action]
    @Binding var selectedActionID: UUID?
    @Binding var showFavoritesOnly: Bool
    @State private var viewModel = HomeViewModel()

    init(
        selectedActionID: Binding<UUID?> = .constant(nil),
        showFavoritesOnly: Binding<Bool> = .constant(false)
    ) {
        _selectedActionID = selectedActionID
        _showFavoritesOnly = showFavoritesOnly
    }

    private var sourceActions: [Action] {
        showFavoritesOnly ? actions.filter(\.isFavorite) : actions
    }

    private var filteredActions: [Action] {
        viewModel.filteredActions(from: sourceActions)
    }

    var body: some View {
        @Bindable var viewModel = viewModel

        Group {
            if sourceActions.isEmpty {
                emptyLibraryState
            } else if filteredActions.isEmpty {
                noSearchResultsState
            } else {
                actionsList
            }
        }
        .navigationTitle(showFavoritesOnly ? "Favorites" : "Actions")
        .navigationBarTitleDisplayMode(.large)
        .searchable(
            text: $viewModel.searchText,
            placement: .navigationBarDrawer(displayMode: .always),
            prompt: "Search actions"
        )
        .toolbar {
            if !sourceActions.isEmpty {
                ToolbarItem(placement: .topBarTrailing) {
                    EditButton()
                }
            }
        }
    }

    private var actionsList: some View {
        List(selection: $selectedActionID) {
            ForEach(filteredActions) { action in
                ActionRowView(action: action)
                    .tag(action.id as UUID?)
            }
            .onDelete(perform: deleteActions)
        }
        .listStyle(.insetGrouped)
    }

    private var emptyLibraryState: some View {
        ContentUnavailableView {
            Label(showFavoritesOnly ? "No Favorites" : "No Actions Yet", systemImage: "bolt.fill")
        } description: {
            Text(showFavoritesOnly
                ? ActionHubCopy.favoritesEmptyDescription
                : ActionHubCopy.actionsEmptyDescription)
        } actions: {
            if !showFavoritesOnly {
                Button(ActionHubCopy.createActionTitle) {
                    withAnimation {
                        viewModel.createAction(selectedActionID: &selectedActionID)
                    }
                }
                .buttonStyle(.borderedProminent)
            }
        }
    }

    private var noSearchResultsState: some View {
        ContentUnavailableView.search(text: viewModel.searchText)
    }

    private func deleteActions(at offsets: IndexSet) {
        withAnimation {
            viewModel.deleteActions(
                at: offsets,
                from: filteredActions,
                selectedActionID: &selectedActionID
            )
        }
    }
}

#Preview("Empty") {
    NavigationSplitView {
        HomeView()
    } detail: {
        Text("Detail")
    }
    .modelContainer(PreviewSampleData.emptyContainer)
}

#Preview("Populated") {
    NavigationSplitView {
        HomeView()
    } detail: {
        Text("Detail")
    }
    .modelContainer(PreviewSampleData.populatedContainer)
}
