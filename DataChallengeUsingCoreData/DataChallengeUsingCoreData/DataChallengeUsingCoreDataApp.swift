//
//  DataChallengeUsingCoreDataApp.swift
//  DataChallengeUsingCoreData
//
//  Created by Ryan Park on 2/18/21.
//

import SwiftUI

@main
struct DataChallengeUsingCoreDataApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
