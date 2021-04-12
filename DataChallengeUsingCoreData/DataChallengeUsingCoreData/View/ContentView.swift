//
//  ContentView.swift
//  DataChallengeUsingCoreData
//
//  Created by Ryan Park on 2/18/21.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: User.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var users: FetchedResults<User>

    var body: some View {
        NavigationView {
            List {
                ForEach(users, id: \.id) { user in
                    NavigationLink(destination: DetailView(user: user)) {
                        VStack(alignment: HorizontalAlignment.leading) {
                            Text(user.unwrappedName)
                        }
                    }
                }
            }
            .navigationBarTitle("User Directory")
            .padding()
        }
        .onAppear(perform: checkDataLoad)
    }
    
    func checkDataLoad() {
        if users.isEmpty {
            DataInitializer.loadData(moc: moc)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

