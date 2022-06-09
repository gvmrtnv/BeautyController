//
//  CheckViewModel.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 30.04.22.
//

import Foundation
import Combine
import SwiftUI

class CheckViewModel: ObservableObject {
    
    @Published var image: Image?
    @Published var filterIntensity = 0.5

    @Published var showingImagePicker = false
    @Published var showingCamerPicker = false
    @Published var checkAnimation = false
    @Published var alreadyChecked = false
    @Published var isChecking = false
    @Published var inputImage: UIImage?
    @Published var processedImage: UIImage?
    
    @Published var compliment: String = ""
    @Published var generateNewCompliment: Bool = false
    @Published var currentFilter: CIFilter = CIFilter.sepiaTone()
    let context = CIContext()

    @Published var showingFilterSheet = false
    
    @Published var myImages: [MyImage] = []
    
    @Published var showFileAlert = false
    @Published var appError: MyImageError.ErrorType?
    
    private lazy var complimentPublisher: AnyPublisher<String, Never> = {
        $generateNewCompliment
            .flatMap { _ -> AnyPublisher<String, Never>  in
                NetworkManager.shared.fetchCompliment()
            }
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }()
    
    init(){
        complimentPublisher
            .assign(to: &$compliment)
    }
    
    
    func loadImage() {
        guard let inputImage = inputImage else { return }
        let beginImage: CIImage
        if let ciImage = inputImage.ciImage {
           beginImage = ciImage
        }
        else {
            beginImage = CIImage(cgImage: inputImage.cgImage!).oriented(CGImagePropertyOrientation(inputImage.imageOrientation))
        }

       
        currentFilter.setValue(beginImage, forKey: kCIInputImageKey)
        applyProcessing()
    }
  
    func applyProcessing() {
        let inputKeys = currentFilter.inputKeys

        if inputKeys.contains(kCIInputIntensityKey) { currentFilter.setValue(filterIntensity, forKey: kCIInputIntensityKey) }
        if inputKeys.contains(kCIInputRadiusKey) { currentFilter.setValue(filterIntensity * 200, forKey: kCIInputRadiusKey) }
        if inputKeys.contains(kCIInputScaleKey) { currentFilter.setValue(filterIntensity * 10, forKey: kCIInputScaleKey) }

        guard let outputImage = currentFilter.outputImage else { return }

        if let cgimg = context.createCGImage(outputImage, from: outputImage.extent) {
            let uiImage = UIImage(cgImage: cgimg)
            image = Image(uiImage: uiImage)
            processedImage = uiImage
        }
    }

    func setFilter(_ filter: CIFilter) {
        currentFilter = filter
        loadImage()
    }
    
    func addMyImage(_ name: String, image: UIImage) {
        loadMyImagesJSONFile()
        let myImage = MyImage(name: name)
        do {
            try FileManager().saveImage("\(myImage.id)", image: image)
            myImages.append(myImage)
            saveMyImagesJSONFile()
      
        } catch {
            showFileAlert = true
            appError = MyImageError.ErrorType(error: error as! MyImageError)
        }
    }
    
    func saveMyImagesJSONFile() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(myImages)
            let jsonString = String(decoding: data, as: UTF8.self)
   
            do {
                try FileManager().saveDocument(contents: jsonString)
            } catch {
                showFileAlert = true
                appError = MyImageError.ErrorType(error: error as! MyImageError)
            }
        } catch {
            showFileAlert = true
            appError = MyImageError.ErrorType(error: .encodingError)
        }
    }
    
    func loadMyImagesJSONFile() {
        do {
            let data = try FileManager().readDocument()
            let decoder = JSONDecoder()
            do {
                myImages = try decoder.decode([MyImage].self, from: data)
            } catch {
                showFileAlert = true
                appError = MyImageError.ErrorType(error: .decodingError)
            }
        } catch {
            showFileAlert = true
            appError = MyImageError.ErrorType(error: error as! MyImageError)
        }
    }
    
    
    
}
