//
//  DetailView.swift
//  PeopleIdentifierChallenge
//
//  Created by Ryan Park on 3/2/21.
//


import SwiftUI
import MapKit

struct DetailView: View {
    let person: Person
    var image: UIImage? {
        return loadImageFromDocumentDirectory(nameOfImage: person.id!.uuidString)
    }
    
    var body: some View {
        GeometryReader { geometry in
            VStack {
                if image != nil {
                    Image(uiImage: image!)
                        .resizable()
                        .scaledToFit()
                        .padding()
                } else {
                    Image(systemName: "person.crop.square")
                        .resizable()
                        .scaledToFit()
                        .padding()
                }
                
                Group {
                    Text("Location")
                        .font(.title)
                        .foregroundColor(.secondary)
                    
                    if person.locationRecorded {
                        MapView(annotation: getAnnotation())
                    }
                    else {
                        Text("Location not found.")
                            .padding()
                    }
                    
                    Spacer()
                }
            }
        }
        .navigationBarTitle(Text(person.name ?? "Unknown Person"), displayMode: .inline)
    }
    
    func loadImageFromDocumentDirectory(nameOfImage : String) -> UIImage? {
        let nsDocumentDirectory = FileManager.SearchPathDirectory.documentDirectory
        let nsUserDomainMask = FileManager.SearchPathDomainMask.userDomainMask
        let paths = NSSearchPathForDirectoriesInDomains(nsDocumentDirectory, nsUserDomainMask, true)
        if let dirPath = paths.first{
            let imageURL = URL(fileURLWithPath: dirPath).appendingPathComponent(nameOfImage)
            let image = UIImage(contentsOfFile: imageURL.path)
            return image
        }
        return UIImage.init(named: "default.png")!
    }
    
    func getAnnotation() -> MKPointAnnotation {
        let annotation = MKPointAnnotation()
        annotation.coordinate = CLLocationCoordinate2D(latitude: person.latitude, longitude: person.longitude)
        return annotation
    }
}
