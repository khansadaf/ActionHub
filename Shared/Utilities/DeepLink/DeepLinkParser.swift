//
//  DeepLinkParser.swift
//  ActionHub
//

import CoreSpotlight
import Foundation

enum DeepLinkParser {
    static func destination(from url: URL) -> DeepLinkDestination? {
        if let destination = destinationFromCustomScheme(url) {
            return destination
        }
        return destinationFromUniversalLink(url)
    }

    static func destination(from userActivity: NSUserActivity) -> DeepLinkDestination? {
        if userActivity.activityType == CSSearchableItemActionType,
           let identifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String,
           let actionID = ActionIndexingService.actionID(from: identifier) {
            return .action(actionID)
        }

        if userActivity.activityType == NSUserActivityTypeBrowsingWeb,
           let url = userActivity.webpageURL {
            return destination(from: url)
        }

        return nil
    }

    private static func destinationFromCustomScheme(_ url: URL) -> DeepLinkDestination? {
        guard url.scheme?.lowercased() == DeepLinkURLBuilder.customScheme else { return nil }
        return destinationFromPathComponents(url.pathComponents)
    }

    private static func destinationFromUniversalLink(_ url: URL) -> DeepLinkDestination? {
        guard let host = url.host?.lowercased(),
              host == DeepLinkURLBuilder.universalHost || host == DeepLinkURLBuilder.universalWWWHost,
              url.scheme?.lowercased() == "https" else {
            return nil
        }
        return destinationFromPathComponents(url.pathComponents)
    }

    private static func destinationFromPathComponents(_ components: [String]) -> DeepLinkDestination? {
        let path = components.filter { $0 != "/" }

        if path == ["actions"] {
            return .actions
        }

        if path == ["favorites"] {
            return .favorites
        }

        if path.count == 2, path[0] == "actions", let uuid = UUID(uuidString: path[1]) {
            return .action(uuid)
        }

        if path.count == 3, path[0] == "actions", path[2] == "run", let uuid = UUID(uuidString: path[1]) {
            return .runAction(uuid)
        }

        return nil
    }
}
