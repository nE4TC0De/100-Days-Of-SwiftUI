//
//  ContentView.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/18/21.
//

import SwiftUI
import CoreHaptics

struct ContentView: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var rolls = CoreDataRolls()
    @State private var rollDisabled = false
    @State private var diceNumber = 3
    @State private var dieSides = 6
    @State private var animationCompletions = Array<Double>(repeating: 1, count: 6)
    @State private var animationComplete = true
    @State private var previousSides = Array<Int>(repeating: 1, count: 6)
    @State private var selectedSides = Array<Int>(repeating: 1, count: 6)
    @State private var engine: CHHapticEngine?
    @State private var coloredNumbers = true
    @State private var showingAction = false
    
    private var pickerOpacity: Double {
        if rollDisabled {
            return colorScheme == .light ? 0.6 : 0.4
        }
        return 0.8
    }
    
    private var rollButtonOpacity: Double {
        if rollDisabled {
            return colorScheme == .light ? 0.6 : 0.4
        }
        return 0.8
    }
    
    private var dividerOpacity: Double {
        colorScheme == .light ? 0.1 : 0.3
    }
    
    private var slotsBackground: Color {
        colorScheme == .light ? .white : .black
    }
    
    var body: some View {
        let diceNumberWithCallback = Binding<Int>(
            get: { diceNumber },
            set: {
                diceNumber = $0
                resetPositions()
            }
        )
        
        let dieSidesWithCallback = Binding<Int>(
            get: { dieSides },
            set: {
                dieSides = $0
                resetPositions()
            }
        )
        
        let animationCompleteWithCallback = Binding<Bool>(
            get: { animationComplete },
            set: {
                animationComplete = $0
                if animationComplete {
                    var result = [Int]()
                    result += selectedSides[0..<diceNumber]
                    let total = result.reduce(0, +)
                    
                    rolls.insert(roll: Roll(dieSides: dieSides, result: result, total: total))
                    
                    playCompletionHaptics()
                    rollDisabled = false
                }
            }
        )
        
        TabView {
            NavigationView {
                VStack {
                    DicePicker(diceNumber: diceNumberWithCallback,
                               rollDisabled: rollDisabled,
                               pickerOpacity: pickerOpacity)
                        .padding([.horizontal, .top])
                    
                    SidesPicker(dieSides: dieSidesWithCallback,
                                rollDisabled: rollDisabled,
                                pickerOpacity: pickerOpacity)
                        .padding()
                    
                    ZStack {
                        Divider()
                            .background(Color.green.opacity(dividerOpacity))
                        
                        HStack {
                            Spacer(minLength: 0)
                            
                            ForEach(0..<diceNumber) { i in
                                DieView(sides: dieSides,
                                        source: previousSides[i],
                                        target: selectedSides[i],
                                        percent: animationCompletions[i],
                                        complete: i < diceNumber - 1 ? .constant(true) : animationCompleteWithCallback)
                                    .foregroundColor(dieColor(for: i))
                                
                                Spacer(minLength: 0)
                            }
                            .id(diceNumber)
                        }
                    }
                    .background(slotsBackground)
                    .padding(.vertical)
                    
                    VStack {
                        Spacer()
                        
                        RollButton(rollDisabled: rollDisabled,
                                   rollButtonOpacity: rollButtonOpacity,
                                   rollAction: rollAction)
                            .padding()
                    }
                }
                .navigationBarTitle("DiceRoll")
            }
            .tabItem {
                Image(systemName: "die.face.3")
                Text("Dice Roll")
            }
            
            NavigationView {
                ZStack {
                    RollsList(rolls: rolls, showingAction: $showingAction)
                        .padding(.top)
                        .edgesIgnoringSafeArea(.bottom)
                }
                .navigationBarTitle("Past Rolls")
                .modifier(DeleteHistoryModifier(showingAction: $showingAction, action: rolls.removeAll))
            }
            .tabItem {
                Image(systemName: "list.number")
                Text("Roll History")
            }
        }
    }
    
    private func rollAction() {
        self.prepareHaptics()
        self.rollDisabled = true
        
        for i in 0..<self.diceNumber {
            let duration = Double(i + 2) / 2
            
            self.previousSides[i] = self.selectedSides[i]
            self.animationCompletions[i] = 0
            self.selectedSides[i] = Int.random(in: 1...self.dieSides)
            if i == self.diceNumber - 1 {
                self.animationComplete = false
            }
            
            withAnimation(.easeOut(duration: duration)) {
                self.animationCompletions[i] = 1
            }
        }
    }
    
    private func dieColor(for index: Int) -> Color {
        if self.coloredNumbers {
            return Color(
                hue: Double(index) / Double(diceNumber),
                saturation: 0.7,
                brightness: 0.8
            )
        }
        
        return .primary
    }
    
    private func resetPositions() {
        for i in 0..<self.diceNumber {
            self.previousSides[i] = 1
            self.selectedSides[i] = 1
            self.animationCompletions[i] = 1
            self.animationComplete = true
        }
    }
    
    private func prepareHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        
        do {
            self.engine = try CHHapticEngine()
            try engine?.start()
        } catch {
            print("There was an error creating the engine: \(error.localizedDescription)")
        }
    }
    
    private func playCompletionHaptics() {
        guard CHHapticEngine.capabilitiesForHardware().supportsHaptics else { return }
        var events = [CHHapticEvent]()
        
        let intensity = CHHapticEventParameter(parameterID: .hapticIntensity, value: 0.3)
        let sharpness = CHHapticEventParameter(parameterID: .hapticSharpness, value: 0.3)
        let event = CHHapticEvent(eventType: .hapticTransient, parameters: [intensity, sharpness], relativeTime: 0)
        events.append(event)
        
        do {
            let pattern = try CHHapticPattern(events: events, parameters: [])
            let player = try engine?.makePlayer(with: pattern)
            try player?.start(atTime: 0)
        } catch {
            print("Failed to play pattern: \(error.localizedDescription).")
        }
    }
}

struct DeleteHistoryModifier: ViewModifier {
    @Binding var showingAction: Bool
    var action: () -> Void
    
    private let title = Text("Delete history?")
    private let deleteButton = Text("Delete all")
    
    func body(content: Content) -> some View {
        return Group {
            if UIDevice.current.userInterfaceIdiom == .pad {
                content.alert(isPresented: $showingAction, content: {
                    Alert(title: title,
                          primaryButton: .destructive(deleteButton, action: action),
                          secondaryButton: .cancel())
                })
            }
            else {
                content.actionSheet(isPresented: $showingAction, content: {
                    ActionSheet(title: title, buttons: [
                                    .destructive(deleteButton, action: action),
                                    .cancel()]
                    )
                })
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
