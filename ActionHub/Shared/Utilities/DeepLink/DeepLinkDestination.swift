//
//  DeepLinkDestination.swift
//  ActionHub
//

import Foundation

enum DeepLinkDestination: Equatable, Sendable {
    case actions
    case favorites
    case action(UUID)
    case runAction(UUID)
}
