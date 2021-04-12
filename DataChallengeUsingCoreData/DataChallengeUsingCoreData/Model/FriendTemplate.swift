//
//  FriendTemplate.swift
//  DataChallengeUsingCoreData
//
//  Created by Ryan Park on 2/18/21.
//

import Foundation

public class FriendTemplate: NSObject, Codable, Identifiable {
    public var id: String
    var name: String
    
    init(id: String, name: String) {
        self.id = id
        self.name = name
    }
 }
