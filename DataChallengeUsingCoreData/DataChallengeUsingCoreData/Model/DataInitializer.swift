//
//  DataInitializer.swift
//  DataChallengeUsingCoreData
//
//  Created by Ryan Park on 2/18/21.
//

import Foundation
import CoreData

struct DataInitializer {

    static func fetchData(completion: @escaping ([UserTemplate]) -> ()) {
        print("Fetching data...")
        guard let url = URL(string: "https://www.hackingwithswift.com/samples/friendface.json") else {
            print("Invalid URL")
            return
        }

        let request = URLRequest(url: url)

        let session = URLSession.shared.dataTask(with: request) { data, response, sessionError in
            guard let data = data else {
                print("Fetch failed: \(sessionError?.localizedDescription ?? "Unknown error")")
                return
            }

            do {
                let decoded = try JSONDecoder().decode([UserTemplate].self, from: data)

                completion(decoded)
            }
            catch let decodingError {
                print("Decoding failed: \(decodingError.localizedDescription)")
            }
        }
        session.resume()
    }
    
    static func loadData(moc: NSManagedObjectContext) {
        DispatchQueue.global().async {
            fetchData { users in

                DispatchQueue.main.async {
                    var tempUsers = [User]()

                    for user in users {
                        let newUser = User(context: moc)
                        newUser.id = user.id
                        newUser.name = user.name
                        newUser.age = Int16(user.age)
                        newUser.email = user.email
                        newUser.address = user.address
                        newUser.company = user.company
                        newUser.registered = user.registered
                        newUser.about = user.about
                        newUser.friends = user.friends
                        
                        tempUsers.append(newUser)
                    }

                    do {
                        try moc.save()
                    }
                    catch let error {
                        print("Could not save data: \(error.localizedDescription)")
                    }
                }
            }
        }
    }
}
