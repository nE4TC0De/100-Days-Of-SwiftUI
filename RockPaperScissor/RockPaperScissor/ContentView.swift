//
//  ContentView.swift
//  RockPaperScissor
//
//  Created by Ryan Park on 1/25/21.
//

import SwiftUI

struct ContentView: View {
    @State private var shouldWin = Bool.random()
    @State private var correctChoice = Int.random(in: 0...2)
    @State private var scoreTitle = ""
    @State private var userScore = 0
    @State private var showAlert = false
    @State private var gameTurn = 0
    var winOrLose = ["Win", "Lose"]
    var moves = ["Rock", "Paper", "Scissor"]
    
    var body: some View {
        VStack(spacing: 100) {
            VStack(spacing: 20) {
                Text("Opponent picks...")
                Text(moves[correctChoice])
                    .font(.largeTitle)
                    .fontWeight(.black)
                Text("Win or Lose?")
                Text(shouldWin == true ? winOrLose[0] : winOrLose[1])
                    .font(.largeTitle)
                    .fontWeight(.black)
            }
            ForEach(0 ..< 3) { move in
                Button(action: {
                    selectedMove(move)
                }) {
                    Text("\(moves[move])")
                }
            }
            Spacer()
            Text(gameTurn == 10 ? "Score: \(userScore)" : "")
                .font(.largeTitle)
                .fontWeight(.black)
        }
        .alert(isPresented: $showAlert) {
            Alert(title: Text(scoreTitle), dismissButton: .default(Text("Continue")) {
                newTurn()
            })
        }
    }
    
    func selectedMove(_ move: Int) {
        switch (moves[correctChoice], moves[move], shouldWin) {
        case ("Rock", "Paper", true):
            scoreTitle = "You win!"
            userScore += 1
        case ("Paper", "Scissor", true):
            scoreTitle = "You win!"
            userScore += 1
        case ("Scissor", "Rock", true):
            scoreTitle = "You win!"
            userScore += 1
        case ("Rock", "Scissor", false):
            scoreTitle = "You win!"
            userScore += 1
        case ("Paper", "Rock", false):
            scoreTitle = "You win!"
            userScore += 1
        case ("Scissor", "Paper", false):
            scoreTitle = "You win!"
            userScore += 1
        default:
            scoreTitle = "You lose..."
            if userScore > 0 {
                userScore -= 1
            }
        }
        showAlert = true
    }
    
    func newTurn() {
        correctChoice = Int.random(in: 0...2)
        shouldWin = Bool.random()
        if gameTurn < 10 {
            gameTurn += 1
        } else if gameTurn == 9 {
            userScore = 0
        } else {
            gameTurn = 1
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
