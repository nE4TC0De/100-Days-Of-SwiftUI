//
//  ContentView.swift
//  Edutainment
//
//  Created by Ryan Park on 2/1/21.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var sharedObjects: EnvironmentObjects
    
    var body: some View {
        Group {
            if sharedObjects.isActive == false {
                Settings()
            } else {
                GameRunning()
            }
        }
    }
}

struct Settings: View {
    @EnvironmentObject var sharedObjects: EnvironmentObjects
    
    var body: some View {
        VStack {
            Form {
                Section(header: Text("Select a multiplication table")) {
                    Stepper(value: $sharedObjects.timesTable, in: 1...12, step: 1) {
                        Text("\(sharedObjects.timesTable)")
                    }
                }
                .font(.headline)
                
                Section(header: Text("Select the number of questions")) {
                    Picker("Number of questions", selection: $sharedObjects.inputSelection) {
                        ForEach(0 ..< sharedObjects.numberOfQuestions.count) {
                            Text("\(sharedObjects.numberOfQuestions[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                .font(.headline)
            }
            Button("Start Game") {
                sharedObjects.questions = [Question]()
                addQuestion()
                sharedObjects.isActive = true
            }
            .padding(20)
            .background(Color.black)
            .foregroundColor(.white)
            .clipShape(RoundedRectangle(cornerRadius: 60))
        }
    }
    
    func addQuestion() {
        let randomInt = (1...100).randomElements(sharedObjects.selectedAmount)
        
        for i in randomInt {
            sharedObjects.questions.append((Question(question: "\(sharedObjects.timesTable) X \(i)", answer: sharedObjects.timesTable * i)))
        }
    }
}

struct GameRunning: View {
    @EnvironmentObject var sharedObjects: EnvironmentObjects
    @State private var currentQuestion = 0
    @State private var userAnswer = ""
    @State private var userScore = 0
    
    var body: some View {
        VStack {
            if currentQuestion < sharedObjects.selectedAmount {
                Text("\(sharedObjects.questions[currentQuestion].question)")
                    .font(.largeTitle)
                
                TextField("Your Answer", text: $userAnswer, onCommit: nextQuestion)
                    .keyboardType(.numberPad)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .frame(width: 200, height: 100, alignment: .center)
            } else {
                Spacer()
                
                Text("Your Score: \(userScore)")
                    .font(.largeTitle)
                
                Spacer()
                
                Button("Play Again?") {
                    sharedObjects.isActive = false
                    currentQuestion = 0
                }
            }
        }
    }
    
    func nextQuestion() {
        if userAnswer.trimmingCharacters(in: .whitespacesAndNewlines) == String(sharedObjects.questions[currentQuestion].answer) {
            userScore += 1
        }
        
        if currentQuestion < sharedObjects.selectedAmount {
            currentQuestion += 1
        }
    }
}

class EnvironmentObjects: ObservableObject {
    @Published var isActive = false
    @Published var timesTable = 1
    @Published var inputSelection = 0
    @Published var numberOfQuestions = ["5", "10", "20", "All"]
    @Published var questions = [Question]()
    var selectedAmount: Int {
        switch numberOfQuestions[inputSelection] {
        case "5":
            return 5
        case "10":
            return 10
        case "20":
            return 20
        case "All":
            return 40
        default:
            fatalError()
        }
    }
}

struct Question {
    let question: String
    let answer: Int
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

extension RangeExpression where Bound: FixedWidthInteger {
    func randomElements(_ n: Int) -> [Bound] {
        precondition(n > 0)
        switch self {
        case let range as Range<Bound>: return (0..<n).map { _ in .random(in: range) }
        case let range as ClosedRange<Bound>: return (0..<n).map { _ in .random(in: range) }
        default: return []
        }
    }
}

extension Range where Bound: FixedWidthInteger {
    var randomElement: Bound { .random(in: self) }
}

extension ClosedRange where Bound: FixedWidthInteger {
    var randomElement: Bound { .random(in: self) }
}

