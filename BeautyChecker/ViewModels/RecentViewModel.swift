//
//  RecentViewModel.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 01.05.22.
//

import SwiftUI

class RecentViewModel: ObservableObject {
    @Published var image: Image?
    @Published var imageName: String = ""
    @Published var textVisible: Bool = true
    
    @Published var selectedImage: MyImage?
    @Published var myImages: [MyImage] = []
    
    @Published var showFileAlert = false
    @Published var appError: MyImageError.ErrorType?
    
    init(){
  
    }
    
    func display(_ myImage: MyImage) {
        image = Image(uiImage: myImage.image)
        imageName = myImage.name
        selectedImage = myImage
    }
    
    func deleteSelected() {
        if let index = myImages.firstIndex(where: {$0.id == selectedImage!.id}) {
            myImages.remove(at: index)
            image = nil
            imageName = ""
            saveMyImagesJSONFile()
      
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
    
    func saveBeautyGradeCard(image: UIImage) {
      
        let imageSaver = ImageSaver()

        imageSaver.successHandler = {
            print("Success!")
        }

        imageSaver.errorHandler = {
            print("Oops! \($0.localizedDescription)")
        }

        imageSaver.writeToPhotoAlbum(image: image)
    }
    
    func share(card: UIImage) {
           
        let activityVC = UIActivityViewController(activityItems: ["#beautygrade: " + imageName, card], applicationActivities: nil)
           UIApplication.shared.windows.first?.rootViewController?.present(activityVC, animated: true, completion: nil)
       }
    
    
    
}
