//
//  User+CoreDataProperties.swift
//  DataChallengeUsingCoreData
//
//  Created by Ryan Park on 2/18/21.
//
//

import Foundation
import CoreData

extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var id: String?
    @NSManaged public var address: String?
    @NSManaged public var email: String?
    @NSManaged public var company: String?
    @NSManaged public var age: Int16
    @NSManaged public var name: String?
    @NSManaged public var about: String?
    @NSManaged public var registered: String?
    @NSManaged public var friends: [FriendTemplate]

    public var unwrappedAddress: String {
        address ?? "Unknown address"
    }
    
    public var unwrappedEmail: String {
        email ?? "Unknown email"
    }
    
    public var unwrappedCompany: String {
        company ?? "Unknown company"
    }
    
    public var unwrappedName: String {
        name ?? "Unknown name"
    }

    public var unwrappedAbout: String {
        about ?? "Unknown description"
    }

    public var unwrappedRegistered: String {
        registered ?? "Unknown registration date"
    }
}

// MARK: Generated accessors for friend
extension User {
    @objc(addFriendObject:)
    @NSManaged public func addToFriend(_ value: User)

    @objc(removeFriendObject:)
    @NSManaged public func removeFromFriend(_ value: User)

    @objc(addFriend:)
    @NSManaged public func addToFriend(_ values: NSSet)

    @objc(removeFriend:)
    @NSManaged public func removeFromFriend(_ values: NSSet)
}
