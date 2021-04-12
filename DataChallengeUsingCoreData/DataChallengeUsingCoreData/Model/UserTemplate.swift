//
//  UserTemplate.swift
//  DataChallengeUsingCoreData
//
//  Created by Ryan Park on 2/18/21.
//

import Foundation

struct UserTemplate: Codable, Identifiable {
    var id: String
    var name: String
    var age: Int
    var company: String
    var email: String
    var address: String
    var about: String
    var registered: String
    var friends: [FriendTemplate]
 }
