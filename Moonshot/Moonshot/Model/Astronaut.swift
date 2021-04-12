//
//  Astronaut.swift
//  Moonshot
//
//  Created by Ryan Park on 2/4/21.
//

import Foundation

struct Astronaut: Codable, Identifiable {
    let id: String
    let name: String
    let description: String
    
    var accessibleName: String {
        name.replacingOccurrences(of: ".", with: " ")
    }
}
