//
//  Habit.swift
//  HabitTracker
//
//  Created by Ryan Park on 2/9/21.
//

import Foundation

struct Habit: Identifiable, Codable {
    let id = UUID()
    let title: String
    let description: String
    var tapCount: Int = 0
    var date = Date()
}
