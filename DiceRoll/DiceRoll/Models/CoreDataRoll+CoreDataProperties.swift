//
//  CoreDataRoll+CoreDataProperties.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//
//

import Foundation
import CoreData


extension CoreDataRoll {

    @nonobjc public class func createfetchRequest() -> NSFetchRequest<CoreDataRoll> {
        return NSFetchRequest<CoreDataRoll>(entityName: "CoreDataRoll")
    }

    @NSManaged public var date: Date?
    @NSManaged public var dieSides: Int16
    @NSManaged public var id: UUID?
    @NSManaged public var result: [Int16]?
    @NSManaged public var total: Int16

}
