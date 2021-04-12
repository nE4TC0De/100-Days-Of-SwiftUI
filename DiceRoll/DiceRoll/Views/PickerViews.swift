//
//  PickerViews.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//

import SwiftUI

struct DicePicker: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Binding var diceNumber: Int
    let rollDisabled: Bool
    let pickerOpacity: Double

    var body: some View {
        VStack {
            HStack {
                Text("Dice").font(.caption)
                Spacer()
            }
            .padding(.leading, 2)

            Picker("", selection: $diceNumber) {
                ForEach(1...6, id: \.self) { i in
                    Text("\(i)")

                }
            }
            .modifier(CustomPickerStyle(rollDisabled: rollDisabled, pickerOpacity: pickerOpacity))
        }
    }
}

struct SidesPicker: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme

    @Binding var dieSides: Int
    let rollDisabled: Bool
    let pickerOpacity: Double

    var body: some View {
        VStack {
            HStack {
                Text("Sides").font(.caption)
                Spacer()
            }
            .padding(.leading, 2)

            Picker("", selection: $dieSides) {
                Text("4").tag(4)
                Text("6").tag(6)
                Text("8").tag(8)
                Text("10").tag(10)
                Text("12").tag(12)
                Text("20").tag(20)
                Text("100").tag(100)
            }
            .modifier(CustomPickerStyle(rollDisabled: rollDisabled, pickerOpacity: pickerOpacity))
        }
    }
}

struct CustomPickerStyle: ViewModifier {
    let rollDisabled: Bool
    let pickerOpacity: Double

    func body(content: Content) -> some View {
        content
            .pickerStyle(SegmentedPickerStyle())
            .disabled(rollDisabled)
            .cornerRadius(8)
            .animation(.linear(duration: 0.1))
    }
}
