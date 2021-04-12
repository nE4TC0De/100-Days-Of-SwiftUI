//
//  Roll.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//

import Foundation

// A roll and its result
struct Roll: Identifiable {
    var id = UUID()
    var dieSides: Int
    var result: [Int]
    var total: Int
}
