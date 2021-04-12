//
//  SortAndFilterView.swift
//  SnowSeeker
//
//  Created by Ryan Park on 3/22/21.
//

import SwiftUI

enum SortType {
    case defaultSort, name, country
}

struct SortAndFilterView: View {
    @Environment(\.presentationMode) var presentationMode

    var resorts: [Resort]

    @Binding var sortSelection: SortType
    @Binding var countriesSelection: [String]
    @Binding var sizesSelection: [String]
    @Binding var pricesSelection: [String]

    private var countries: [String] {
        var unique = [String]()
        for resort in resorts {
            if !unique.contains(resort.country) {
                unique.append(resort.country)
            }
        }
        return unique.sorted()
    }

    private var sizes: [Int] {
        var unique = [Int]()
        for resort in resorts {
            if !unique.contains(resort.size) {
                unique.append(resort.size)
            }
        }
        return unique.sorted()
    }

    private var prices: [Int] {
        var unique = [Int]()
        for resort in resorts {
            if !unique.contains(resort.price) {
                unique.append(resort.price)
            }
        }
        return unique.sorted()
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Sort resorts")) {
                    Picker("Sort resorts", selection: self.$sortSelection) {
                        Text("Default").tag(SortType.defaultSort)
                        Text("Name").tag(SortType.name)
                        Text("Country").tag(SortType.country)
                    }
                    .pickerStyle(SegmentedPickerStyle())
                }

                Section(header: Text("Filter resorts")) {
                    MultipleChoicesView(title: "Countries",
                                        values: countries,
                                        selections: $countriesSelection,
                                        convertValue: { $0 },
                                        updateSelection: { self.updateCountries(selection: $0) }
                    )

                    MultipleChoicesView(title: "Sizes",
                                        values: sizes,
                                        selections: $sizesSelection,
                                        convertValue: { Resort.sizeText(from: $0) },
                                        updateSelection: { self.updateSizes(selection: $0) }
                    )

                    MultipleChoicesView(title: "Prices",
                                        values: prices,
                                        selections: $pricesSelection,
                                        convertValue: { Resort.priceText(from: $0) },
                                        updateSelection: { self.updatePrices(selection: $0) }
                    )
                }
            }
            .navigationBarTitle(Text("Sort and filter"), displayMode: .inline)
            .navigationBarItems(trailing: Button(
                action: { self.presentationMode.wrappedValue.dismiss() },
                label: { Text("Done").padding(15) }
            ))
        }
    }

    func updateCountries(selection country: String) {
        update(selections: &countriesSelection, selection: country)
    }

    func updateSizes(selection size: String) {
        update(selections: &sizesSelection, selection: size)
    }

    func updatePrices(selection price: String) {
        update(selections: &pricesSelection, selection: price)
    }

    func update(selections: inout [String], selection: String) {
        if selection == "All" {
            selections = ["All"]
            return
        }

        if selections.contains(selection) {
            if let allIndex = selections.firstIndex(of: selection) {
                selections.remove(at: allIndex)
            }
            if selections.isEmpty {
                selections = ["All"]
            }
        }
        else {
            selections.append(selection)
            if let allIndex = selections.firstIndex(of: "All") {
                selections.remove(at: allIndex)
            }
        }
    }
}

struct MultipleChoicesView<ValueType: Hashable>: View {
    @State var title: String
    @State var values: [ValueType]
    @Binding var selections: [String]

    var convertValue: (_ value: ValueType) -> String
    var updateSelection: (_ selection: String) -> ()

    var body: some View {
        Group {
            Text(title)
                .font(.headline)

            HStack {
                Text("All")
                    .font(.subheadline)
                    .padding(.leading, 16)
                Spacer()
                if self.selections.contains("All") {
                    Image(systemName: "checkmark")
                }
            }
            .contentShape(Rectangle())
            .onTapGesture {
                self.updateSelection("All")
            }

            ForEach(values, id: \.self) { value in
                HStack {
                    Text("\(self.convertValue(value))")
                        .font(.subheadline)
                        .padding(.leading, 16)
                    Spacer()
                    if self.selections.contains(self.convertValue(value)) {
                        Image(systemName: "checkmark")
                    }
                }
                .contentShape(Rectangle())
                .onTapGesture {
                    self.updateSelection(self.convertValue(value))
                }
            }
        }
    }
}
