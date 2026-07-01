//
//  ModelContainer+Setup.swift
//  ActionHub
//

import Foundation
import SwiftData

enum ModelContainerSetup {
    static let appGroupID = "group.com.sadaf.ActionHub"
    private static let storeFileName = "ActionHub.store"

    static func makeShared(isStoredInMemoryOnly: Bool = false) -> ModelContainer {
        let schema = Schema([
            Category.self,
            Action.self,
            ExecutionHistory.self,
        ])
        let modelConfiguration: ModelConfiguration
        if isStoredInMemoryOnly {
            modelConfiguration = ModelConfiguration(
                schema: schema,
                isStoredInMemoryOnly: true
            )
        } else if let storeURL = sharedStoreURL {
            modelConfiguration = ModelConfiguration(
                schema: schema,
                url: storeURL
            )
        } else {
            modelConfiguration = ModelConfiguration(schema: schema)
        }

        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("Could not create ModelContainer: \(error)")
        }
    }

    private static var sharedStoreURL: URL? {
        FileManager.default
            .containerURL(forSecurityApplicationGroupIdentifier: appGroupID)?
            .appending(path: storeFileName)
    }
}
