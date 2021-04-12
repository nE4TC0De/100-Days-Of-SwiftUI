//
//  DieView.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//

import SwiftUI

struct DieView: View {
    let sides: Int
    let source: Int
    let target: Int
    let percent: Double
    
    @Binding var complete: Bool
    
    var body: some View {
        Text("100")
            .modifier(
                DieAnimatableModifier(sides: sides,
                                      source: source,
                                      target: target,
                                      percent: percent,
                                      complete: $complete)
            )
    }
}

struct DieConstants {
    static let numberFrameHeight: CGFloat = 40
    
    static let slotFrameHeight = numberFrameHeight * 3
    static let slotFrameWidth: CGFloat = 61
    
    static let minimumScrollingNumbers = 200
}

enum DieStyle {
    case normal, wheel
}

struct DieAnimatableModifier: AnimatableModifier {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var sides: Int
    var source: Int
    var target: Int
    var percent: Double
    
    @Binding var complete: Bool
    
    var animatableData: Double {
        get { percent }
        set { percent = newValue }
    }
    
    private let style: DieStyle = .normal
    
    private let wheelStyleStrength: Double = 0.5
    
    private var wheelMaskColor: Color {
        colorScheme == .light ?
            Color.gray :
            Color(red: 0.2, green: 0.2, blue: 0.2)
    }
        
    func body(content: Content) -> some View {
        let repeats = Double(DieConstants.minimumScrollingNumbers / sides)
        
        let absoluteNumber: Double = 1.0 + percent * Double(sides) * repeats + Double(source) * (1.0 - min(1.0, percent)) + Double(target) * max(0.0, percent)
        
        let offset: CGFloat = getOffsetPercentage(absoluteNumber)
        
        let sideNumbers = [
            absoluteNumber - 2,
            absoluteNumber - 1,
            absoluteNumber,
            absoluteNumber + 1,
            absoluteNumber + 2
        ]
        .map { getSideNumber($0) }
        
        notifyCompletion()
        
        return
            ZStack {
                VStack {
                    ForEach(sideNumbers, id: \.self) { number in
                        Text("\(number)").font(.largeTitle)
                            .frame(width: DieConstants.slotFrameWidth, height: DieConstants.numberFrameHeight)
                    }
                }
                .offset(x: 0, y: DieConstants.numberFrameHeight * offset)
                .frame(width: DieConstants.slotFrameWidth, height: DieConstants.slotFrameHeight)
                .clipped()
                
                if style == .wheel {
                    VStack(alignment: .center, spacing: 0) {
                        LinearGradient(
                            gradient: Gradient(colors: [
                                wheelMaskColor.opacity(wheelStyleStrength),
                                wheelMaskColor.opacity(0),
                                wheelMaskColor.opacity(wheelStyleStrength)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .frame(height: DieConstants.slotFrameHeight)
                    }
                }
            }
    }
        
    private func getSideNumber(_ number: Double) -> Int {
        var numberInRange = number.truncatingRemainder(dividingBy: Double(sides))
        
        if numberInRange < 0 { numberInRange += Double(sides) }
        
        let truncatedNumber = Int(numberInRange)
        
        if truncatedNumber == 0 { return sides }
        
        return truncatedNumber
    }
    
    private func getOffsetPercentage(_ number: Double) -> CGFloat {
        var numberInRange = number.truncatingRemainder(dividingBy: Double(sides))
        
        if numberInRange < 0 { numberInRange += Double(sides) }
        
        let truncatedNumber = Int(numberInRange)
        
        return 1 - CGFloat(numberInRange - Double(truncatedNumber))
    }
    
    private func notifyCompletion() {
        if percent == 1.0 {
            if self.complete == false {
                DispatchQueue.main.async { self.complete = true }
            }
        }
    }
}


