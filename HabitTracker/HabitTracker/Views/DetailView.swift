//
//  DetailView.swift
//  HabitTracker
//
//  Created by Ryan Park on 2/9/21.
//

import Foundation
import SwiftUI

struct DetailView: View {
    @ObservedObject var listItems: Habits
    var habitId: UUID

    @State var completedTimes: Int = 0

    var habit: Habit {
        listItems.getHabit(id: habitId)
    }

    var body: some View {
        Form {
            Text(habit.title)
            Text(habit.description)
            Stepper(
                onIncrement: { self.updateHabitCount(by: 1) },
                onDecrement: { self.updateHabitCount(by: -1) },
                label: { Text("Completed \(habit.tapCount) times") }
            )
        }
        .navigationBarTitle("Edit Activity")
    }

    func updateHabitCount(by change: Int) {
        var habit = self.habit
        
        if habit.tapCount > 0 {
            habit.tapCount += change
        } else if habit.tapCount == 0 {
            habit.tapCount += 1
        }
        
        self.listItems.update(habit: habit)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        DetailView(listItems: Habits(), habitId: UUID())
    }
}
