//
//  Extensions.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 28.04.22.
//

import SwiftUI
import Vision

let fileName = "MyImages.json"

extension FileManager {
    static var docDirURL: URL {
        return Self.default.urls(for: .documentDirectory, in: .userDomainMask).first!
    }
    
    func docExist(named docName: String) -> Bool {
        fileExists(atPath: Self.docDirURL.appendingPathComponent(docName).path)
    }
    
    func saveDocument(contents: String) throws {
        let url = Self.docDirURL.appendingPathComponent(fileName)
        do {
            try contents.write(to: url, atomically: true, encoding: .utf8)
        } catch {
            throw MyImageError.saveError
        }
    }
    
    func readDocument() throws -> Data {
        let url = Self.docDirURL.appendingPathComponent(fileName)
        do {
            return try Data(contentsOf: url)
        } catch {
            throw MyImageError.readError
        }
    }
    
    func saveImage(_ id: String, image: UIImage) throws {
        if let data = image.jpegData(compressionQuality: 0.6) {
            let imageURL = FileManager.docDirURL.appendingPathComponent("\(id).jpg")
            do {
                try data.write(to: imageURL)
            } catch {
                throw MyImageError.saveImageError
            }
        } else {
            throw MyImageError.saveImageError
        }
    }
    
    func readImage(with id: UUID) throws -> UIImage {
        let imageURL = FileManager.docDirURL.appendingPathComponent("\(id).jpg")
        do {
            let imageData = try Data(contentsOf: imageURL)
            if let image = UIImage(data: imageData) {
                return image
            } else {
                throw MyImageError.readImageError
            }
        } catch {
            throw MyImageError.readImageError
        }
    }
}


extension Color {
    public static let mildPink: Color = Color(UIColor(red: 1.00, green: 0.88, blue: 0.88, alpha: 1))
    public static let mildPurple: Color = Color(UIColor(red: 0.96, green: 0.91, blue: 0.98, alpha: 1.00))
    public static let mildYellow: Color = Color(UIColor(red: 0.96, green: 0.93, blue: 0.77, alpha: 1.00))
    public static let mildGreen: Color = Color(UIColor(red: 0.68, green: 0.90, blue: 0.85, alpha: 1.00))
    public static let mystic: Color = Color(UIColor(red: 0.84, green: 0.34, blue: 0.50, alpha: 1.00))
}






// MARK: - Convertation from View to Image

extension UIView {
    func asImage() -> UIImage {
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        return UIGraphicsImageRenderer(size: self.layer.frame.size, format: format).image { context in
            self.drawHierarchy(in: self.layer.bounds, afterScreenUpdates: true)
        }
    }
}



extension View {
    func asImage(size: CGSize) -> UIImage {
        let controller = UIHostingController(rootView: self)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        let image = controller.view.asImage()
        return image
    }
}

extension CGImagePropertyOrientation {
    init(_ uiOrientation: UIImage.Orientation) {
        switch uiOrientation {
            case .up: self = .up
            case .upMirrored: self = .upMirrored
            case .down: self = .down
            case .downMirrored: self = .downMirrored
            case .left: self = .left
            case .leftMirrored: self = .leftMirrored
            case .right: self = .right
            case .rightMirrored: self = .rightMirrored
            @unknown default:
                fatalError("Unknown uiOrientation \(uiOrientation)")
        }
    }
}

extension VNClassificationObservation {
    /// Generates a string of the observation's confidence as a percentage.
    var confidencePercentageString: String {
        let percentage = confidence * 100

        switch percentage {
            case 100.0...:
                return "100%"
            case 10.0..<100.0:
                return String(format: "%2.1f", percentage)
            case 1.0..<10.0:
                return String(format: "%2.1f", percentage)
            case ..<1.0:
                return String(format: "%1.2f", percentage)
            default:
                return String(format: "%2.1f", percentage)
        }
    }
}



