//
//  DeepLinkURLBuilder.swift
//  ActionHub
//

import Foundation

enum DeepLinkURLBuilder {
    static let customScheme = "actionhub"
    static let universalHost = "actionhub.app"
    static let universalWWWHost = "www.actionhub.app"

    static func customURL(for destination: DeepLinkDestination) -> URL? {
        url(scheme: customScheme, host: "open", destination: destination)
    }

    static func universalURL(for destination: DeepLinkDestination) -> URL? {
        url(scheme: "https", host: universalHost, destination: destination)
    }

    private static func url(scheme: String, host: String, destination: DeepLinkDestination) -> URL? {
        var components = URLComponents()
        components.scheme = scheme
        components.host = host

        switch destination {
        case .actions:
            components.path = "/actions"
        case .favorites:
            components.path = "/favorites"
        case .action(let id):
            components.path = "/actions/\(id.uuidString)"
        case .runAction(let id):
            components.path = "/actions/\(id.uuidString)/run"
        }

        return components.url
    }
}
