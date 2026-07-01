//
//  ActionHubWidgetBundle.swift
//  ActionHubWidget
//

import SwiftUI
import WidgetKit

@main
struct ActionHubWidgetBundle: WidgetBundle {
    var body: some Widget {
        FavoriteActionsWidget()
        ActionLiveActivity()
    }
}
