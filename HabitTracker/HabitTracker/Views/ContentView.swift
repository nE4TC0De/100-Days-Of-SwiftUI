//
//  ContentView.swift
//  HabitTracker
//
//  Created by Ryan Park on 2/9/21.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var listItems = Habits()
    @State private var showingAddHabit = false

    var body: some View {
        NavigationView {
            List {
                ForEach(listItems.habits) { habit in
                    NavigationLink(destination: DetailView(listItems: listItems, habitId: habit.id)) {
                        HStack {
                            VStack(alignment: .leading) {
                                Text(habit.title)
                                    .font(.headline)
                            }

                            Spacer()
                            
                            Text("\(habit.tapCount)")
                        }
                    }
                }
                .onDelete(perform: removeItems)
            }
            .navigationBarTitle("HabitTracker")
            .navigationBarItems(leading: EditButton(), trailing:
                Button(action: {
                    showingAddHabit = true
                }) {
                    Image(systemName: "plus")
                }
            )
            .sheet(isPresented: $showingAddHabit) {
                AddView(listItems: listItems)
            }
        }
    }
    
    func removeItems(at offsets: IndexSet) {
        listItems.habits.remove(atOffsets: offsets)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
