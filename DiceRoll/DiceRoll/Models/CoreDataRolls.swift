//
//  CoreDataRolls.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//

import Foundation
import CoreData

class CoreDataRolls: Rolls {
    private var items = [CoreDataRoll]() {
        didSet {
            saveContext()
        }
    }

    private var container: NSPersistentContainer

    init() {
        container = NSPersistentContainer(name: "DiceRoll")
        container.loadPersistentStores { storeDescription, error in
            if let error = error {
                print("Unresolved error \(error)")
            }
        }

        container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

        loadSavedData()
    }

    @Published private(set) var all = [Roll]()

    var allPublished: Published<[Roll]> { _all }
    var allPublisher: Published<[Roll]>.Publisher { $all }

    func insert(roll: Roll) {
        let cdRoll = buildCoreDataRoll(roll: roll)

        items.insert(cdRoll, at: 0)
        all.insert(roll, at: 0)
    }

    func removeAll() {
        for item in items {
            container.viewContext.delete(item)
        }
        items.removeAll()
        all.removeAll()
    }

    private func loadSavedData() {
        let request = CoreDataRoll.createfetchRequest()
        let sort = NSSortDescriptor(key: "date", ascending: false)
        request.sortDescriptors = [sort]

        do {
            items = try container.viewContext.fetch(request)

            for item in items {
                let roll = buildRoll(cdRoll: item)
                all.append(roll)
            }
        } catch {
            print("Fetch failed")
        }
    }

    private func buildRoll(cdRoll: CoreDataRoll) -> Roll {
        let id = cdRoll.id ?? UUID()

        if cdRoll.id == nil {
            cdRoll.id = id
            saveContext()
        }

        var result = [Int]()
        if let cdResult = cdRoll.result {
            result = cdResult.map { Int($0) }
        }

        let roll = Roll(id: id,
                        dieSides: Int(cdRoll.dieSides),
                        result: result,
                        total: Int(cdRoll.total))

        return roll
    }

    private func buildCoreDataRoll(roll: Roll) -> CoreDataRoll {
        let cdRoll = CoreDataRoll(context: container.viewContext)
        cdRoll.id = roll.id
        cdRoll.date = Date()
        copyRollAttributes(from: roll, to: cdRoll)

        return cdRoll
    }

    private func copyRollAttributes(from roll: Roll, to cdRoll: CoreDataRoll) {
        cdRoll.dieSides = Int16(roll.dieSides)
        cdRoll.result = roll.result.map { Int16($0) }
        cdRoll.total = Int16(roll.total)
    }

    private func saveContext() {
        if container.viewContext.hasChanges {
            do {
                try container.viewContext.save()
            } catch {
                print("An error occurred while saving: \(error)")
            }
        }
    }
}

