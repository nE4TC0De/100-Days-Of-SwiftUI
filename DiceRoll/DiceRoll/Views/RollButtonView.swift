//
//  RollButtonView.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//

import SwiftUI

struct RollButton: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    var rollDisabled: Bool
    var rollButtonOpacity: Double
    var rollAction: () -> Void

    var body: some View {
        ZStack {
            Button(
                action: rollAction,
                label: {
                    HStack{
                        Spacer()
                        Text("⚁")
                            .font(.largeTitle)
                            .rotationEffect(.radians(.pi / 8))
                        Text("ROLL")
                            .font(.title)
                            .padding(.horizontal)
                        Text("⚄")
                            .font(.largeTitle)
                            .rotationEffect(.radians(.pi / 8))
                        Spacer()
                    }
                }
            )
            .foregroundColor(colorScheme == .light ? Color.white : Color.black)
            .padding(.vertical, 8)
            .background(colorScheme == .light ? Color.black : Color.white)
            .opacity(rollButtonOpacity)
            .animation(.linear(duration: 0.1))
            .cornerRadius(8)
            .disabled(rollDisabled)
        }
    }
}

