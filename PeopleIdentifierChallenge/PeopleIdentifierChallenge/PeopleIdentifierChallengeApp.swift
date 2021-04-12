//
//  PeopleIdentifierChallengeApp.swift
//  PeopleIdentifierChallenge
//
//  Created by Ryan Park on 3/2/21.
//

import SwiftUI

@main
struct PeopleIdentifierChallengeApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
