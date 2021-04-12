//
//  Rolls.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//

import Foundation

protocol Rolls: ObservableObject {
    var all: [Roll] { get }
    var allPublished: Published<[Roll]> { get }
    var allPublisher: Published<[Roll]>.Publisher { get }

    func insert(roll: Roll)

    func removeAll()
}
