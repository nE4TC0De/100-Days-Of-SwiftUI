//
//  Prospect.swift
//  HotProspects
//
//  Created by Ryan Park on 3/9/21.
//

import SwiftUI

class Prospect: Identifiable, Codable {
    let id = UUID()
    var name = "Anonymous"
    var emailAddress = ""
    fileprivate(set) var isContacted = false
    
    var date = Date()
}

class Prospects: ObservableObject {
    @Published private(set) var people: [Prospect]
    static let saveKey = "SavedData"

    init() {
        self.people = []
        
        if let data = loadfromDocumentsDirectory() {
            if let decoded = try? JSONDecoder().decode([Prospect].self, from: data) {
                self.people = decoded
                return
            }
        }
    }
    
    func toggle(_ prospect: Prospect) {
        objectWillChange.send()
        prospect.isContacted.toggle()
        saveToDocumentsDirectory()
    }
    
    private func saveToUserDefaults() {
        if let encoded = try? JSONEncoder().encode(people) {
            UserDefaults.standard.set(encoded, forKey: Self.saveKey)
        }
    }
    
    private func loadFromUserDefaults() -> Data? {
        if let data = UserDefaults.standard.data(forKey: Self.saveKey) {
            return data
        }
        return nil
    }

    func add(_ prospect: Prospect) {
        people.append(prospect)
        saveToDocumentsDirectory()
    }
    
    private func getDocumentDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    
    private func saveToDocumentsDirectory() {
        if let encodedData = try? JSONEncoder().encode(people) {
            let url = getDocumentDirectory().appendingPathComponent(Self.saveKey)
            
            do {
                try encodedData.write(to: url, options: [.atomicWrite, .completeFileProtection])
            }
            catch let error {
                print("Could not write data: " + error.localizedDescription)
            }
        }
    }
    
    private func loadfromDocumentsDirectory() -> Data? {
        let url = getDocumentDirectory().appendingPathComponent(Self.saveKey)
        if let data = try? Data(contentsOf: url) {
            return data
        }
        
        return nil
    }
}
