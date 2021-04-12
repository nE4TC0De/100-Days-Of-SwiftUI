//
//  Habits.swift
//  HabitTracker
//
//  Created by Ryan Park on 2/9/21.
//

import Foundation

class Habits: ObservableObject {
    @Published var habits: [Habit] {
        didSet {
            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(habits) {
                UserDefaults.standard.set(encoded, forKey: "Habits")
            }
        }
    }
    
    init() {
        if let habits = UserDefaults.standard.data(forKey: "Habits") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Habit].self, from: habits) {
                self.habits = decoded
                return
            }
        }
        self.habits = []
    }
    
    func add(habit: Habit) {
        habits.append(habit)
        sortHabits()
    }

    func update(habit: Habit) {
        guard let index = getIndex(habit: habit) else { return }

        habits[index] = habit
        sortHabits()
    }

    func getHabit(id: UUID) -> Habit {
        guard let index = getIndex(id: id) else { return Habit(title: "", description: "") }

        return habits[index]
    }
    
    private func sortHabits() {
        habits.sort(by: { $0.date > $1.date } )
    }

    private func getIndex(habit: Habit) -> Int? {
        return habits.firstIndex(where: { $0.id == habit.id })
    }

    private func getIndex(id: UUID) -> Int? {
        return habits.firstIndex(where: { $0.id == id })
    }
}
