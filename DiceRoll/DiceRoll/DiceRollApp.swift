//
//  DiceRollApp.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/18/21.
//

import SwiftUI

@main
struct DiceRollApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
