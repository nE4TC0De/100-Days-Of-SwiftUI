//
//  ContentView.swift
//  Instafilter
//
//  Created by Ryan Park on 2/22/21.
//

import SwiftUI
import CoreImage
import CoreImage.CIFilterBuiltins

struct ContentView: View {
    @State private var image: Image?
    @State private var filterIntensity = 0.5
    @State private var showingImagePicker = false
    @State private var inputImage: UIImage?
    @State private var currentFilter: CIFilter = CIFilter.sepiaTone()
    @State private var showingFilterSheet = false
    @State private var processedImage: UIImage?
    @State private var showingError = false
    @State private var filterButtonText = "Change Filter"
    @State private var filterRadius = 0.5
    @State private var filterScale = 0.5
    let context = CIContext()

    var body: some View {
        let intensity = Binding<Double>(
            get: {
                self.filterIntensity
            },
            set: {
                self.filterIntensity = $0
                self.applyProcessing()
            }
        )
        
        let radius = Binding<Double>(
            get: {
                self.filterRadius
            },
            set: {
                self.filterRadius = $0
                self.applyProcessing()
            }
        )
        
        let scale = Binding<Double>(
            get: {
                self.filterScale
            },
            set: {
                self.filterScale = $0
                self.applyProcessing()
            }
        )
        
        return NavigationView {
            VStack {
                ZStack {
                    Rectangle()
                        .fill(Color.secondary)

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
                .onTapGesture {
                    self.showingImagePicker = true
                }
                
                VStack {
                    if currentFilter.inputKeys.contains(kCIInputIntensityKey) {
                        HStack {
                            Text("Intensity")
                            Slider(value: intensity)
                        }
                    }
                    
                    if currentFilter.inputKeys.contains(kCIInputRadiusKey) {
                        HStack {
                            ZStack(alignment: .leading) {
                                Text("Intensity").opacity(0)
                                Text("Radius")
                            }
                            Slider(value: radius)
                        }
                    }
                    
                    if currentFilter.inputKeys.contains(kCIInputScaleKey) {
                        HStack {
                            ZStack(alignment: .leading) {
                                Text("Intensity").opacity(0)
                                Text("Scale")
                            }
                            Slider(value: scale)
                        }
                    }
                }
                .padding(.vertical)
                
                HStack {
                    Button(filterButtonText) {
                        self.showingFilterSheet = true
                    }

                    Spacer()

                    Button("Save") {
                        guard let processedImage = self.processedImage else { return showingError = true }

                        let photoSaver = PhotoSaver()
                        
                        photoSaver.successHandler = {
                            print("Success!")
                        }

                        photoSaver.errorHandler = {
                            print("Oops: \($0.localizedDescription)")
                        }

                        photoSaver.writeToPhotoAlbum(image: processedImage)
                    }
                    .alert(isPresented: $showingError) {
                        Alert(title: Text("Error"), message: Text("Plesae select a photo"), dismissButton: .default(Text("OK")))
                    }
                }
            }
            .padding([.horizontal, .bottom])
            .navigationBarTitle("Instafilter")
            .sheet(isPresented: $showingImagePicker, onDismiss: loadImage) {
                PhotoPicker(image: self.$inputImage)
            }
            .actionSheet(isPresented: $showingFilterSheet) {
                ActionSheet(title: Text("Select a filter"), buttons: [
                    .default(Text("Crystalized")) { self.setFilter(CIFilter.crystallize(), "Crystalized") },
                    .default(Text("Edges")) { self.setFilter(CIFilter.edges(), "Edges") },
                    .default(Text("Gaussian Blur")) { self.setFilter(CIFilter.gaussianBlur(), "Gaussian Blur") },
                    .default(Text("Pixelate")) { self.setFilter(CIFilter.pixellate(), "Pixelate") },
                    .default(Text("Sepia Tone")) { self.setFilter(CIFilter.sepiaTone(), "Sepia Tone") },
                    .default(Text("Unsharp Mask")) { self.setFilter(CIFilter.unsharpMask(), "Unsharp Mask") },
                    .default(Text("Vignette")) { self.setFilter(CIFilter.vignette(), "Vignette") },
                    .cancel()
                ])
            }
        }
    }
    
    func loadImage() {
        guard let inputImage = inputImage else { return }

        let beginImage = CIImage(image: inputImage)
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
    
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys
        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterRadius * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterScale * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }
    
    func setFilter(_ filter: CIFilter, _ title: String) {
        currentFilter = filter
        filterButtonText = title
        loadImage()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
