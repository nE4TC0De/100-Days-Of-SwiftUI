//
//  AstronautView.swift
//  Moonshot
//
//  Created by Ryan Park on 2/4/21.
//

import Foundation
import SwiftUI

struct AstronautView: View {
    let astronaut: Astronaut
    let missions: [Mission]

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    Image(decorative: self.astronaut.id)
                        .resizable()
                        .scaledToFit()
                        .frame(width: geometry.size.width)

                    Text(self.astronaut.description)
                        .padding()
                        .layoutPriority(1)
                    
                    Text("Missions")
                        .hidden()
                        .frame(width: 0, height: 0)
                        .accessibility(label: Text("Missions"))
                    
                    ForEach(self.missions) { mission in
                        HStack {
                            Image(decorative: mission.image)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 50, height: 50)
                            
                            Text(mission.displayName)
                                .font(.headline)
                            
                            Spacer()
                        }
                        .padding(.horizontal)
                    }
                }
            }
        }
        .navigationBarTitle(Text(astronaut.name), displayMode: .inline)
    }
    
    init(astronaut: Astronaut) {
        let listOfMissions: [Mission] = Bundle.main.decode("missions.json")
        
        self.astronaut = astronaut
        
        var matches = [Mission]()
        
        let missions = listOfMissions
        
        for mission in missions {
            if (mission.crew.first(where: { $0.name == astronaut.id }) != nil) {
                matches.append(mission)
            }
        }
        self.missions = matches
    }
}

struct AstronautView_Previews: PreviewProvider {
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        AstronautView(astronaut: astronauts[0])
    }
}

