//
//  AddView.swift
//  PeopleIdentifierChallenge
//
//  Created by Ryan Park on 3/2/21.
//

import SwiftUI

struct AddView: View {
    @Environment(\.managedObjectContext) var moc
    @Environment(\.presentationMode) var presentationMode

    @State private var name = ""
    @State private var showingAlert = false
    @State private var image: Image?
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    let uuid = UUID().uuidString
    let locationFetcher = LocationFetcher()
    @State private var imageSourceType: ImageSourceType = .library
    @State private var showingErrorAlert = false
    @State private var errorAlertMessage = ""

    var body: some View {
        return NavigationView {
            Form {
                Section {
                    TextField("Enter a name", text: $name)
                    
                    ZStack {
                        Rectangle()
                            .fill(Color.secondary)
                            .frame(width: 200, height: 200)
                            .padding()
                        
                        if image != nil {
                            image?
                                .resizable()
                                .scaledToFit()
                        } else {
                            Text("Tap to select a picture")
                                .foregroundColor(.white)
                                .font(.headline)
                        }
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .onTapGesture {
                        selectPhoto()
                    }
                    
                    Button("Or shoot a new photo...") {
                        takePicture()
                    }
                    .frame(minWidth: 0, maxWidth: .infinity, minHeight: 0, maxHeight: .infinity, alignment: .center)
                    .alert(isPresented: $showingErrorAlert, content: {
                        Alert(title: Text(errorAlertMessage))
                    })
                }
            }
            .navigationBarTitle("Add Person")
            .navigationBarItems(trailing: Button("Save") {
                if name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
                    showingAlert = true
                } else {
                    let newPerson = Person(context: self.moc)
                    newPerson.name = self.name
                    newPerson.id = UUID(uuidString: uuid)
                    
                    if let location = self.locationFetcher.lastKnownLocation {
                        newPerson.latitude = location.latitude
                        newPerson.longitude = location.longitude
                        newPerson.locationRecorded = true
                    }
                    else {
                        newPerson.locationRecorded = false
                    }
                    
                    if inputImage != nil {
                        saveImageToDocumentDirectory(image: inputImage!)
                    }
                    
                    try? self.moc.save()
                    
                    self.presentationMode.wrappedValue.dismiss()
                }
            }
            .onAppear() {
                self.locationFetcher.start()
            }
            .alert(isPresented: $showingAlert) {
                Alert(title: Text("Error!"), message: Text("Please enter a name."), dismissButton: .default(Text("OK")))
            })
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                ImagePicker(image: self.$inputImage, sourceType: self.imageSourceType)
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        image = Image(uiImage: inputImage)
    }
    
    func saveImageToDocumentDirectory(image: UIImage ) {
        let documentsDirectory = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let fileName = uuid
        let fileURL = documentsDirectory.appendingPathComponent(fileName)
        if let data = image.jpegData(compressionQuality: 1.0),!FileManager.default.fileExists(atPath: fileURL.path){
            do {
                try data.write(to: fileURL)
                print("file saved")
            } catch {
                print("error saving file:", error)
            }
        }
    }
    
    func takePicture() {
        if ImagePicker.isCameraAvailable() {
            self.imageSourceType = .camera
            self.showingImagePicker = true
        }
        else {
            self.errorAlertMessage = "Camera is not available"
            self.showingErrorAlert = true
        }
    }

    func selectPhoto() {
        self.imageSourceType = .library
        self.showingImagePicker = true
    }
}
