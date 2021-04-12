//
//  MissionView.swift
//  Moonshot
//
//  Created by Ryan Park on 2/4/21.
//

import Foundation
import SwiftUI

struct MissionView: View {
    let mission: Mission
    let astronauts: [CrewMember]

    var body: some View {
        GeometryReader { geometry in
            ScrollView(.vertical) {
                VStack {
                    GeometryReader { imageGeometry in
                        Image(self.mission.image)
                            .resizable()
                            .scaledToFit()
                            .padding(.top)
                            .frame(width: imageGeometry.size.width, height: imageGeometry.size.height)
                            .scaleEffect(1 - self.scaleFactor(geometry: geometry, imageGeometry: imageGeometry))
                            .offset(x: 0, y: self.scaleFactor(geometry: geometry, imageGeometry: imageGeometry) * imageGeometry.size.height / 2)
                    }
                    .frame(height: geometry.size.width * 0.75)
                    
                    Text("Launch Date: \(mission.formattedLaunchDate)")
                        .accessibility(label: Text(""))
                        .accessibility(value: Text(self.mission.accessibleLaunchDate))
                    
                    Text(self.mission.description)
                        .padding()

                    Text("Astronauts")
                        .hidden()
                        .frame(width: 0, height: 0)
                        .accessibility(label: Text("Astronauts"))
                    
                    ForEach(self.astronauts, id: \.role) { crewMember in
                        NavigationLink(destination: AstronautView(astronaut: crewMember.astronaut)) {
                            HStack {
                                Image(crewMember.astronaut.id)
                                    .resizable()
                                    .frame(width: 83, height: 60)
                                    .clipShape(Capsule())
                                    .overlay(Capsule().stroke(Color.primary, lineWidth: 1))

                                VStack(alignment: .leading) {
                                    Text(crewMember.astronaut.name)
                                        .font(.headline)
                                    Text(crewMember.role)
                                        .foregroundColor(.secondary)
                                }

                                Spacer()
                            }
                            .padding(.horizontal)
                            .accessibilityElement(children: .ignore)
                            .accessibility(label: Text(self.getNameAndRole(crewMember: crewMember)))
                        }
                        .buttonStyle(PlainButtonStyle())
                    }
                    
                    Spacer(minLength: 25)
                }
            }
        }
        .navigationBarTitle(Text(mission.displayName), displayMode: .inline)
    }
    
    struct CrewMember {
        let role: String
        let astronaut: Astronaut
    }
    
    init(mission: Mission, astronauts: [Astronaut]) {
        self.mission = mission

        var matches = [CrewMember]()

        for member in mission.crew {
            if let match = astronauts.first(where: { $0.id == member.name }) {
                matches.append(CrewMember(role: member.role, astronaut: match))
            } else {
                fatalError("Missing \(member)")
            }
        }
        self.astronauts = matches
    }
    
    func getNameAndRole(crewMember: CrewMember) -> String {
        crewMember.astronaut.accessibleName + ", " + crewMember.role
    }
    
    func scaleFactor(geometry: GeometryProxy, imageGeometry: GeometryProxy) -> CGFloat {
        let imagePosition = imageGeometry.frame(in: .global).minY
        let safeAreaHeight = geometry.safeAreaInsets.top
        
        return (safeAreaHeight - imagePosition) / 500
    }
}

struct MissionView_Previews: PreviewProvider {
    static let missions: [Mission] = Bundle.main.decode("missions.json")
    static let astronauts: [Astronaut] = Bundle.main.decode("astronauts.json")

    static var previews: some View {
        MissionView(mission: missions[0], astronauts: astronauts)
    }
}
