//
//  ContentView.swift
//  WordScramble
//
//  Created by Ryan Park on 1/28/21.
//

import SwiftUI

struct ContentView: View {
    @State private var usedWords = [String]()
    @State private var rootWord = ""
    @State private var newWord = ""
    @State private var errorTitle = ""
    @State private var errorMessage = ""
    @State private var showingError = false
    @State private var userScore = 0
    
    var body: some View {
        NavigationView {
            VStack {
                TextField("Enter your word", text: $newWord, onCommit: addNewWord)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .padding()
                    .autocapitalization(.none)
               
                GeometryReader { listProxy in
                    List(self.usedWords, id: \.self) { word in
                        GeometryReader { itemProxy in
                            HStack {
                                Image(systemName: "\(word.count).circle")
                                    .foregroundColor(self.getColor(listProxy: listProxy, itemProxy: itemProxy))
                                Text(word)
                            }
                            .frame(width: itemProxy.size.width, alignment: .leading)
                            .offset(x: self.getOffset(listProxy: listProxy, itemProxy: itemProxy), y: 0)
                        }
                    }
                }
                
                Text("Score: \(userScore)")
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            .navigationBarTitle(rootWord)
            .onAppear(perform: startGame)
            .navigationBarItems(trailing: Button(action: newRootWord) { Text("Scramble")})
            .alert(isPresented: $showingError) {
                Alert(title: Text(errorTitle), message: Text(errorMessage), dismissButton: .default(Text("OK")))
            }
        }
    }
    
    func addNewWord() {
        let answer = newWord.lowercased().trimmingCharacters(in: .whitespacesAndNewlines)

        guard answer.count > 0 else {
            return
        }

        guard isOriginal(word: answer) else {
            wordError(title: "Word used already", message: "Be more original")
            userScore -= answer.count * 10 / 2
            return
        }

        guard isPossible(word: answer) else {
            wordError(title: "Word not recognized", message: "You can't just make them up, you know!")
            userScore -= answer.count * 10 / 2
            return
        }

        guard isReal(word: answer) else {
            wordError(title: "Word not possible", message: "That isn't a real word.")
            userScore -= answer.count * 10 / 2
            return
        }

        usedWords.insert(answer, at: 0)
        newWord = ""
        userScore += answer.count * 10
    }
    
    func startGame() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")

                rootWord = allWords.randomElement() ?? "silkworm"

                return
            }
        }
        fatalError("Could not load start.txt from bundle.")
    }
    
    func isOriginal(word: String) -> Bool {
        if newWord == rootWord {
            return false
        } else {
            return !usedWords.contains(word)
        }
    }
    
    func isPossible(word: String) -> Bool {
        var tempWord = rootWord

        for letter in word {
            if let pos = tempWord.firstIndex(of: letter) {
                tempWord.remove(at: pos)
            } else {
                return false
            }
        }

        return true
    }
    
    func isReal(word: String) -> Bool {
        let checker = UITextChecker()
        let range = NSRange(location: 0, length: word.utf16.count)
        let misspelledRange = checker.rangeOfMisspelledWord(in: word, range: range, startingAt: 0, wrap: false, language: "en")

        if newWord.count < 2 {
            return false
        }
        return misspelledRange.location == NSNotFound
    }
    
    func wordError(title: String, message: String) {
        errorTitle = title
        errorMessage = message
        showingError = true
    }
    
    func newRootWord() {
        if let startWordsURL = Bundle.main.url(forResource: "start", withExtension: "txt") {
            if let startWords = try? String(contentsOf: startWordsURL) {
                let allWords = startWords.components(separatedBy: "\n")
                rootWord = allWords.randomElement() ?? "silkworm"
            }
        }
    }
    
    func getOffset(listProxy: GeometryProxy, itemProxy: GeometryProxy) -> CGFloat {
        let itemPercent = getItemPercent(listProxy: listProxy, itemProxy: itemProxy)
        
        let thresholdPercent: CGFloat = 60
        let indent: CGFloat = 9
        
        if itemPercent > thresholdPercent {
            return (itemPercent - (thresholdPercent - 1)) * indent
        }
        
        return 0
    }
    
    func getColor(listProxy: GeometryProxy, itemProxy: GeometryProxy) -> Color {
        let itemPercent = getItemPercent(listProxy: listProxy, itemProxy: itemProxy)
        
        let colorValue = Double(itemPercent / 100)
        
        return Color(hue: colorValue, saturation: 0.9, brightness: 0.9)
    }
    
    func getItemPercent(listProxy: GeometryProxy, itemProxy: GeometryProxy) -> CGFloat {
        let listHeight = listProxy.size.height
        let listStart = listProxy.frame(in: .global).minY
        let itemStart = itemProxy.frame(in: .global).minY
        
        let itemPercent =  (itemStart - listStart) / listHeight * 100
        
        return itemPercent
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
