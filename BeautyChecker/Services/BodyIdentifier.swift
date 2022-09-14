//
//  BodyIdentifier.swift
//  BeautyController
//
//  Created by Gleb Martynov on 08.09.22.
//

import Foundation
import Vision
import Combine
import SwiftUI

class BodyIdentifier {
    
    @Published var compliment: String = ""
    let imagePredictor = ImagePredictor()
    var image: UIImage?
    
    func generateCompliment(_ image: UIImage) {
        DispatchQueue.global().async {
            self.image = image
            // Get the CGImage on which to perform requests.
            guard let cgImage = image.cgImage else { return }
            

            // Create a new image-request handler.
            let requestHandler = VNImageRequestHandler(cgImage: cgImage)

            // Create a new request to recognize a human body pose.
            let request = VNDetectHumanBodyPoseRequest(completionHandler: self.bodyPoseHandler)

            do {
                // Perform the body pose-detection request.
                try requestHandler.perform([request])
            } catch {
                print("Unable to perform the request: \(error).")
            }
        }
            
    }
    
    func bodyPoseHandler(request: VNRequest, error: Error?) {
        guard let observations =
                request.results as? [VNHumanBodyPoseObservation] else {
            compliment = "You are beautiful"
            return
        }
        
        // Process each observation to find the recognized body pose points.
        var groupMy: VNHumanBodyPoseObservation.JointsGroupName?
        var jointMy:Dictionary<VNHumanBodyPoseObservation.JointName, VNRecognizedPoint>.Element?
        outerLoop: for observation in observations {
            let recognizedJointGroups = observation.availableJointsGroupNames.shuffled()
          
            for group in recognizedJointGroups {
                guard let jointsOfGroup = try? observation.recognizedPoints(group).shuffled()
                else {
                    compliment = "You have a beautiful face2"
                    return
                }
           
                for joint in jointsOfGroup {
   
                    if joint.value.confidence > 0 {
                        
                        groupMy = group
                        jointMy = joint
                        break outerLoop
                    }
                }
            }
        }
            
        
        var groupName = "soul"
            if let groupMy = groupMy {
              
                switch groupMy {
                case .face:
                    groupName = "face"
                case .leftArm:
                    groupName = "left arm"
                case .rightArm:
                    groupName = "right arm"
                case .leftLeg:
                    groupName = "left leg"
                case .torso:
                    groupName = "torso"
                case .rightLeg:
                    groupName = "right leg"
                default:
                    break
                }
            }
        
        var jointName = "inner world"
            if let jointMy = jointMy {
                jointName = jointMy.key.rawValue.rawValue
            }
        if !(groupName == "soul" && jointName == "inner world") {

            compliment = "You have  beautiful \(groupName), and especially \(jointName)"
        }
        else if let image = image{
            do {
                try imagePredictor.makePredictions(for: image, completionHandler: imagePredictionHandler)
            } catch{
                compliment = "I can't see your picture"
            }
            
        }
        
        
    }
    private func imagePredictionHandler(_ predictions: [ImagePredictor.Prediction]?) {
        guard let predictions = predictions else {
            compliment = "This thing is beautiful"
            return
        }

        let prediction = predictions.max { a, b in a.confidencePercentage < b.confidencePercentage
        }
        
        guard var name = prediction?.classification else {return}

        // For classifications with more than one name, keep the one before the first comma.
        if let firstComma = name.firstIndex(of: ",") {
            name = String(name.prefix(upTo: firstComma))
        }
        
        compliment = "You have a great \(name)"

    }
}
