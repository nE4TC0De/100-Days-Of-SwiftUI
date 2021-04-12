//
//  DetailView.swift
//  DataChallengeUsingCoreData
//
//  Created by Ryan Park on 2/18/21.
//

import SwiftUI

struct DetailView: View {
    var user: User

    var body: some View {
        VStack {
            Form {
                Section(header: Text("User Info.").font(.headline)) {
                    Text("Name: \(user.unwrappedName)")
                    Text("Age: \(user.age)")
                    Text("Works at: \(user.unwrappedCompany)")
                    Text("Email: \(user.unwrappedEmail)")
                    Text("Address: \n\(user.unwrappedAddress)")
                    Text("Description: \(user.unwrappedAbout)")
                        .padding()
                    Text("Registered on: \(user.unwrappedRegistered)")
                }
                
                Section(header: Text("Friends").font(.headline)) {
                    ForEach(user.friends, id: \.id) { friend in
                        FriendView(friend: friend)
                    }
                }
            }
        }.navigationBarTitle("\(user.unwrappedName)", displayMode: .inline)
    }
}

struct FriendView: View {
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var users: FetchedResults<User>
    var friend: FriendTemplate

    var body: some View {
        if let foundFriend = find(withId: friend.id) {
            return AnyView(LinkedFriendView(friend: foundFriend))
        } else {
            return AnyView(Text(friend.name))
        }
    }
    
    func find(withId: String) -> User? {
        return users.first { $0.id == withId }
    }
}

struct LinkedFriendView: View {
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var users: FetchedResults<User>
    var friend: User

    var body: some View {
        NavigationLink(destination: DetailView(user: friend)) {
            VStack(alignment: HorizontalAlignment.leading) {
                Text(friend.unwrappedName)
            }
        }
    }
}

