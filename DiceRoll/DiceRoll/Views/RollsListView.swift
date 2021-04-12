//
//  RollsListView.swift
//  DiceRoll
//
//  Created by Ryan Park on 3/19/21.
//

import SwiftUI

struct RollsList: View {
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @ObservedObject var rolls: CoreDataRolls
    @Binding var showingAction: Bool

    var body: some View {
        GeometryReader { listProxy in
            List {
                ForEach(rolls.all) { roll in
                    GeometryReader { itemProxy in
                        ZStack {
                            HStack {
                                Text("\(roll.dieSides)")
                                Text("⚁")
                                    .rotationEffect(.radians(.pi / 8))

                                Spacer()

                                HStack(alignment: .lastTextBaseline) {
                                    Text("Σ")
                                        .font(.caption)
                                    Text("\(roll.total)")
                                }
                            }
                            .padding(.horizontal)

                            HStack {
                                Spacer()

                                ForEach(roll.result, id: \.self) { side in
                                    Text("\(side)")
                                }

                                Spacer()
                            }
                        }
                        .frame(height: itemProxy.size.height)
                        .background(rollColor(for: roll))
                        .opacity(itemOpacity(listProxy: listProxy, itemProxy: itemProxy))
                    }
                    .listRowInsets(EdgeInsets())
                }
            }
            .foregroundColor(.gray)
            .onAppear {
                UITableView.appearance().separatorStyle = .none
                UITableView.appearance().backgroundColor = UIColor.clear
            }
            .onDisappear {
                UITableView.appearance().separatorStyle = .singleLine
                UITableView.appearance().backgroundColor = UIColor.systemBackground
            }
            .onTapGesture {}
            .onLongPressGesture {
                if !self.rolls.all.isEmpty {
                    self.showingAction = true
                }
            }
        }
    }

    private func rollColor(for roll: Roll) -> Color {
        if colorScheme == .light {
            return index(for: roll) % 2 == 0 ?
                Color.black.opacity(0.05) :
                Color.black.opacity(0.15)
        }

        return index(for: roll) % 2 == 0 ?
            Color.white.opacity(0.125) :
            Color.white.opacity(0.075)
    }

    private func index(for roll: Roll) -> Int {
        rolls.all.firstIndex(where: { roll.id == $0.id }) ?? 0
    }

    private func itemOpacity(listProxy: GeometryProxy, itemProxy: GeometryProxy) -> Double {
        let itemMinY = itemProxy.frame(in: .global).minY
        let listMinY = listProxy.frame(in: .global).minY

        let positionInList = itemMinY - listMinY
        let ratio = positionInList / listProxy.size.height

        return 1 - Double(ratio * ratio)
    }
}

