//
//  DeepLinkCenter.swift
//  ActionHub
//

import Foundation

extension Notification.Name {
    static let deepLinkDestinationDidChange = Notification.Name("DeepLinkCenter.destinationDidChange")
}

@MainActor
enum DeepLinkCenter {
    private(set) static var pendingDestination: DeepLinkDestination?

    static func open(_ destination: DeepLinkDestination) {
        pendingDestination = destination
        NotificationCenter.default.post(name: .deepLinkDestinationDidChange, object: destination)
    }

    static func consumePendingDestination() -> DeepLinkDestination? {
        defer { pendingDestination = nil }
        return pendingDestination
    }
}
