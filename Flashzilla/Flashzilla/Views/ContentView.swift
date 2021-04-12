//
//  ContentView.swift
//  Flashzilla
//
//  Created by Ryan Park on 3/10/21.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    enum SheetType {
        case editCards, settings
    }

    @Environment(\.accessibilityDifferentiateWithoutColor) var differentiateWithoutColor
    @Environment(\.accessibilityEnabled) var accessibilityEnabled
    @State private var cards = [Card]()
    @State private var timeRemaining = 100
    @State private var isActive = true
    @State private var showingEditScreen = false
    @State private var initialCardsCount = 0
    @State private var correctCards = 0
    @State private var incorrectCards = 0
    @State private var showingSheet = false
    @State private var retryIncorrectCards = false
    @State private var sheetType = SheetType.editCards
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let haptics = Haptics()

    private var reviewedCards: Int {
        correctCards + incorrectCards
    }

    var body: some View {
        ZStack {
            Image(decorative: "background")
                .resizable()
                .scaledToFill()
                .edgesIgnoringSafeArea(.all)
            
            VStack {
                Text("Time: \(timeRemaining)")
                    .font(.largeTitle)
                    .foregroundColor(.white)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 5)
                    .background(
                        Capsule()
                            .fill(Color.black)
                            .opacity(0.75)
                    )
                
                ZStack {
                    ForEach(cards) { card in
                        CardView(card: card, retryIncorrectCards: self.retryIncorrectCards) { isCorrect in
                            if isCorrect {
                                self.correctCards += 1
                            }
                            else {
                                self.incorrectCards += 1

                                if self.retryIncorrectCards {
                                    self.restackCard(at: self.index(for: card))
                                    return
                                }
                            }
                            withAnimation {
                                self.removeCard(at: self.index(for: card))
                            }
                        }
                        .stacked(at: self.index(for: card), in: self.cards.count)
                        .allowsHitTesting(self.index(for: card) == self.cards.count - 1)
                        .accessibility(hidden: self.index(for: card) < self.cards.count - 1)
                    }
                    .allowsHitTesting(timeRemaining > 0)
                    
                    if timeRemaining == 0 || !isActive {
                        RestartView(retryIncorrectCards: retryIncorrectCards,
                                    initialCardsCount: initialCardsCount,
                                    reviewedCards: reviewedCards,
                                    correctCards: correctCards,
                                    incorrectCards: incorrectCards,
                                    restartAction: resetCards)
                            .frame(width: 300, height: 200)
                    }
                }
            }
            
            VStack {
                HStack {
                    ActionButton(systemImage: "gear") {
                        self.showSheet(type: .settings)
                    }
                    Spacer()
                }
                Spacer()
            }
            .padding()

            VStack {
                HStack {
                    Spacer()
                    ActionButton(systemImage: "plus.circle") {
                        self.showSheet(type: .editCards)
                    }
                }
                Spacer()
            }
            .padding()

            
            if differentiateWithoutColor || accessibilityEnabled {
                VStack {
                    Spacer()
                    
                    HStack {
                        ActionButton(systemImage: "xmark.circle") {
                            self.incorrectCards += 1

                            if self.retryIncorrectCards {
                                self.restackCard(at: self.cards.count - 1)
                                return
                            }

                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                            }
                        }
                        .accessibility(label: Text("Wrong"))
                        .accessibility(hint: Text("Mark your answer as being incorrect."))
                        Spacer()
                        
                        ActionButton(systemImage: "checkmark.circle") {
                            withAnimation {
                                self.removeCard(at: self.cards.count - 1)
                                self.correctCards += 1
                            }
                        }
                        .accessibility(label: Text("Correct"))
                        .accessibility(hint: Text("Mark your answer as being correct."))
                    }
                    .foregroundColor(.white)
                    .font(.largeTitle)
                    .padding()
                }
            }
        }
        .onReceive(timer) { time in
            guard self.isActive else { return }
            if self.timeRemaining > 0 {
                self.timeRemaining -= 1
                
                if self.timeRemaining == 2 {
                    self.haptics.prepare()
                }
                else if self.timeRemaining == 0 {
                    self.haptics.playEnding()
                }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification)) { _ in
            self.isActive = false
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            if self.cards.isEmpty == false {
                self.isActive = true
            }
        }
        .sheet(isPresented: $showingSheet, onDismiss: resetCards) {
            if self.sheetType == .editCards {
                EditCards()
            }
            else if self.sheetType == .settings {
                SettingsView(retryIncorrectCards: self.$retryIncorrectCards)
            }
        }
        .onAppear(perform: resetCards)
    }
    
    func removeCard(at index: Int) {
        guard index >= 0 else { return }
        
        cards.remove(at: index)
        
        if cards.count == 1 {
            haptics.prepare()
        }
        
        if cards.isEmpty {
            isActive = false
            haptics.playEnding()
        }
    }
    
    func resetCards() {
        timeRemaining = 100
        isActive = true
        loadData()
    }
    
    func loadData() {
        if let data = UserDefaults.standard.data(forKey: "Cards") {
            if let decoded = try? JSONDecoder().decode([Card].self, from: data) {
                self.cards = decoded
                
                self.initialCardsCount = cards.count
                self.correctCards = 0
                self.incorrectCards = 0
                if cards.count == 1 {
                    self.haptics.prepare()
                }
            }
        }
    }
    
    func restackCard(at index: Int) {
        guard index >= 0 else { return }

        let card = cards[index]
        cards.remove(at: index)
        cards.insert(card, at: 0)
    }
    
    func index(for card: Card) -> Int {
        return cards.firstIndex(where: { $0.id == card.id }) ?? 0
    }

    func showSheet(type: SheetType) {
        self.sheetType = type
        self.showingSheet = true
    }
}

extension View {
    func stacked(at position: Int, in total: Int) -> some View {
        let offset = CGFloat(total - position)
        return self.offset(CGSize(width: 0, height: offset * 10))
    }
}

struct Haptics {
    @State private var engine: CHHapticEngine?
    
    func prepare() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }

        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }

    func playEnding() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()

        for i in stride(from: 0, to: 1, by: 0.1) {
            let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: Float(i))
            let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: Float(i))
            let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: i)
            events.append(event)
        }

        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}


struct ActionButton: View {
    let systemImage: String
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Image(systemName: systemImage)
                .padding()
                .background(Color.black.opacity(0.7))
                .clipShape(Circle())
        }
        .foregroundColor(.white)
        .font(.largeTitle)
    }
}

struct RestartView: View {
    let retryIncorrectCards: Bool
    let initialCardsCount: Int
    let reviewedCards: Int
    let correctCards: Int
    let incorrectCards: Int
    let restartAction: () -> Void

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 25, style: .continuous)
                .fill(Color.black)

            VStack(alignment: .center) {
                Text("Statistics")
                    .font(.headline)

                HStack {
                    VStack(alignment: .leading) {
                        Text("Cards" + (retryIncorrectCards ? " (unique)" : ""))
                        Text("Reviewed")
                        Text("Correct")
                        Text("Incorrect")
                    }
                    VStack(alignment: .trailing) {
                        Text("\(initialCardsCount)")
                        Text("\(reviewedCards)")
                        Text("\(correctCards)")
                        Text("\(incorrectCards)")
                    }
                }
                .font(.subheadline)
                .padding(.bottom)

                Button("Start Again", action: restartAction)
                    .padding()
                    .background(Color.white)
                    .foregroundColor(.black)
                    .clipShape(Capsule())
            }
            .foregroundColor(.white)
        }
    }
}

struct SettingsView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var retryIncorrectCards: Bool

    var body: some View {
        NavigationView {
            Form {
                Section(footer: Text("Cards for which you did not know the answer will go back to the end of the stack")) {
                    Toggle(isOn: $retryIncorrectCards) {
                        Text("Retry incorrect cards")
                    }
                }
            }
            .navigationBarTitle("Settings")
            .navigationBarItems(trailing: Button("Done", action: dismiss))
        }
    }

    func dismiss() {
        presentationMode.wrappedValue.dismiss()
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView(retryIncorrectCards: Binding.constant(false))
    }
}


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
