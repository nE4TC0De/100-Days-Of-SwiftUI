//
//  EdutainmentApp.swift
//  Edutainment
//
//  Created by Ryan Park on 2/1/21.
//

import SwiftUI

@main
struct EdutainmentApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(EnvironmentObjects())
        }
    }
}
