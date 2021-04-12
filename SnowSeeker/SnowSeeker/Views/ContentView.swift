//
//  ContentView.swift
//  SnowSeeker
//
//  Created by Ryan Park on 3/22/21.
//

import SwiftUI

struct ContentView: View {
    let resorts: [Resort] = Bundle.main.decode("resorts.json")
    @ObservedObject var favorites = Favorites()
    
    var sorted: [Resort] {
        switch sortSelection {
        case .defaultSort:
            return resorts
        case .name:
            return resorts.sorted { $0.name < $1.name }
        case .country:
            return resorts.sorted { $0.country < $1.country }
        }
    }
    
    var sortedFiltered: [Resort] {
        var list = sorted
        list = filteredCountries(resorts: sorted)
        list = filteredSizes(resorts: list)
        list = filteredPrices(resorts: list)
        
        return list
    }
    
    @State var showingSheet: Bool = false
    @State var sortSelection = SortType.defaultSort
    @State var countriesSelection = ["All"]
    @State var sizesSelection = ["All"]
    @State var pricesSelection = ["All"]
    
    var body: some View {
        NavigationView {
            List(sortedFiltered) { resort in
                NavigationLink(destination: ResortView(resort: resort)) {
                    Image(resort.country)
                        .resizable()
                        .scaledToFill()
                        .frame(width: 40, height: 25)
                        .clipShape(
                            RoundedRectangle(cornerRadius: 5)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.black, lineWidth: 1)
                        )

                    VStack(alignment: .leading) {
                        Text(resort.name)
                            .font(.headline)
                        Text("\(resort.runs) runs")
                            .foregroundColor(.secondary)
                    }
                    .layoutPriority(1)
                    
                    if self.favorites.contains(resort) {
                        Spacer()
                        Image(systemName: "heart.fill")
                        .accessibility(label: Text("This is a favorite resort"))
                            .foregroundColor(.red)
                    }
                }
            }
            .sheet(isPresented: $showingSheet, content: {
                SortAndFilterView(resorts: self.resorts,
                                  sortSelection: self.$sortSelection,
                                  countriesSelection: self.$countriesSelection,
                                  sizesSelection: self.$sizesSelection,
                                  pricesSelection: self.$pricesSelection)
            })
            .navigationBarTitle("Resorts")
            .navigationBarItems(trailing: Button(action: {
                self.showingSheet = true
            }, label: {
                HStack {
                    Image(systemName: "arrow.up.arrow.down.circle")
                    Image(systemName: "line.horizontal.3.decrease.circle")
                }
                .padding(15)
            })
            )

            WelcomeView()
        }
        .environmentObject(favorites)
    }
    
    func filteredCountries(resorts: [Resort]) -> [Resort] {
        filter(resorts: resorts, selections: countriesSelection, valuePath: \.country)
    }
    
    func filteredSizes(resorts: [Resort]) -> [Resort] {
        filter(resorts: resorts, selections: sizesSelection, valuePath: \.sizeText)
    }
    
    func filteredPrices(resorts: [Resort]) -> [Resort] {
        filter(resorts: resorts, selections: pricesSelection, valuePath: \.priceText)
    }
    
    func filter(resorts: [Resort],
                selections: [String],
                valuePath: KeyPath<Resort, String>) -> [Resort] {
        
        if selections.contains("All") {
            return resorts
        }
        
        var list = [Resort]()
        for resort in resorts {
            if selections.contains(resort[keyPath: valuePath]) {
                list.append(resort)
            }
        }
        
        return list
    }
}

extension View {
    func phoneOnlyStackNavigationView() -> some View {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return AnyView(self.navigationViewStyle(StackNavigationViewStyle()))
        } else {
            return AnyView(self)
        }
    }
}
