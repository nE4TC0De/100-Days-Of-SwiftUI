//
//  ContentView.swift
//  PeopleIdentifierChallenge
//
//  Created by Ryan Park on 3/2/21.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: Person.entity(), sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)]) var people: FetchedResults<Person>

    @State private var showingAddScreen = false
    
    var body: some View {
        NavigationView {
            List {
                ForEach(people, id: \.self) { person in
                    NavigationLink(destination: DetailView(person: person)) {
                        if loadImageFromDocumentDirectory(nameOfImage: person.id!.uuidString) != nil {
                            Image(uiImage: loadImageFromDocumentDirectory(nameOfImage: person.id!.uuidString)!)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(10)
                        } else {
                            Image(systemName: "person.crop.square")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipped()
                                .cornerRadius(10)
                        }
                        
                        Text(person.name ?? "Unknown Person")
                            .font(.headline)
                    }
                }
                .onDelete(perform: deletePeople)
            }
            .navigationBarTitle("PeopleIdentifier")
            .navigationBarItems(leading: EditButton(), trailing: Button(action: {
                self.showingAddScreen.toggle()
            }) {
                Image(systemName: "plus")
            })
            .sheet(isPresented: $showingAddScreen) {
                AddView().environment(\.managedObjectContext, self.moc)
            }
        }
    }
    
    func deletePeople(at offsets: IndexSet) {
        for offset in offsets {
            let person = people[offset]

            moc.delete(person)
        }
            
        try? moc.save()
    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image = UIImage(contentsOfFile: imageURL.path)
            return image
        }
        return UIImage.init(named: "default.png")!
    }
}
