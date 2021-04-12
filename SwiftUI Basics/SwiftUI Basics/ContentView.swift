//
//  ContentView.swift
//  SwiftUI Basics
//
//  Created by Ryan Park on 1/14/21.
//

import SwiftUI

struct ContentView: View {
    @State private var tapCount = 0
    @State private var name = ""
    
    let students = ["Harry", "Hermione", "Ron"]
    @State private var selectedStudent = 0
    
    
    var body: some View {
        
        NavigationView {
            Form {
                Section {
                    Text("Hello, world!")
                        .padding()
                    Text("Good bye, world...")
                        .padding()
                    Text("Your name: \(name)")
                        .padding()
                    TextField("Insert name here", text: $name)
                        .padding()
                }
                Section {
                    Button("Tap Count: \(tapCount)") {
                        self.tapCount += 1
                    }
                    .padding()
                }
                Section {
                    VStack {
                        Picker("Select your student", selection: $selectedStudent) {
                            ForEach(0 ..< students.count) { student in
                                Text(self.students[student])
                            }
                        }
                        Text("You chose: Student # \(students[selectedStudent])")
                    }
                }
                
            }
            .navigationBarTitle("SwiftUI")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension UIScreen {
    static let screenWidth = UIScreen.main.bounds.size.width
    static let screenHeight = UIScreen.main.bounds.size.height
    static let screenSize = UIScreen.main.bounds.size
}
