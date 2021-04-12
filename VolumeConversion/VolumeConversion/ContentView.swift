//
//  ContentView.swift
//  VolumeConversion
//
//  Created by Ryan Park on 1/19/21.
//

import SwiftUI

struct ContentView: View {
    @State private var inputNumber = ""
    @State private var inputUnit = 0
    @State private var outputUnit = 0
    var volumeUnits = ["mL", "L", "cup", "pt", "gal"]
    var inputVolumeUnits = [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons]
    var outputVolumeUnits = [UnitVolume.milliliters, UnitVolume.liters, UnitVolume.cups, UnitVolume.pints, UnitVolume.gallons]
    
    var inputVolume: Measurement<UnitVolume> {
        return Measurement(value: Double(inputNumber) ?? 0, unit: inputVolumeUnits[inputUnit])
    }

    var outputVolume: Measurement<UnitVolume> {
        return inputVolume.converted(to: outputVolumeUnits[outputUnit])
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    TextField("Volume amount", text: $inputNumber)
                        .keyboardType(.decimalPad)
                }
                Section(header: Text("Select input unit")) {
                    Picker("Input Unit", selection: $inputUnit) {
                        ForEach(0 ..< volumeUnits.count) {
                            Text("\(self.volumeUnits[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Select output unit")) {
                    Picker("Output Unit", selection: $outputUnit) {
                        ForEach(0 ..< volumeUnits.count) {
                            Text("\(self.volumeUnits[$0])")
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }
                Section(header: Text("Conversion Output")) {
                    Text("\(outputVolume.value)")
                }
            }
            .navigationBarTitle("Volume Conversion")
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
