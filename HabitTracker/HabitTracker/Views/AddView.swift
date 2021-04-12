//
//  AddView.swift
//  HabitTracker
//
//  Created by Ryan Park on 2/9/21.
//

import Foundation
import SwiftUI

struct AddView: View {
    @State private var name = ""
    @State private var description = ""
    @State private var showingError = false

    @ObservedObject var listItems: Habits
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            Form {
                TextField("Title", text: $name)
                TextField("Description", text: $description)
            }
            .navigationBarTitle("Add a new habit")
            .navigationBarItems(trailing: Button("Save") {
                self.presentationMode.wrappedValue.dismiss()
                let item = Habit(title: self.name, description: self.description, tapCount: 0)
                self.listItems.habits.append(item)
            })
        }
    }
}

struct AddView_Previews: PreviewProvider {
    static let listItems = Habits()
    
    static var previews: some View {
        AddView(listItems: listItems)
    }
}
