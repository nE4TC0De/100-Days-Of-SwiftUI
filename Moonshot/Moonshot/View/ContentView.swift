//
//  ContentView.swift
//  Moonshot
//
//  Created by Ryan Park on 2/4/21.
//

import SwiftUI

struct ContentView: View {
    let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")
    let missions: [Mission] = Bundle.main.decode("missions.json")
    @State private var toggleSwitch = false
    
    var body: some View {
        NavigationView {
            List(missions) { mission in
                NavigationLink(destination: MissionView(mission: mission, astronauts: self.astronauts)) {
                    Image(mission.image)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 44, height: 44)

                    VStack(alignment: .leading) {
                        Text(mission.displayName)
                            .font(.headline)
                        
                        if toggleSwitch {
                            Text(mission.formattedLaunchDate)
                                .accessibility(label: Text(""))
                                .accessibility(value: Text(mission.accessibleLaunchDate))
                        } else {
                            Text(mission.crewNames(astronauts: self.astronauts))
                                .accessibility(label: Text(""))
                                .accessibility(value: Text(mission.accessibleCrewNames(astronauts: self.astronauts)))
                        }
                    }
                }
            }
            .navigationBarTitle("Moonshot")
            .navigationBarItems(leading: Button(action: { self.toggleSwitch.toggle() }, label: { Text("Show \(self.toggleSwitch ? "Crew" : "Date")")}))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
