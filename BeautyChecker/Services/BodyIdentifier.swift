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
    
    func generateCompliment(_ image: UIImage) {
//        guard let url = URL(string: "https://complimentr.com/api") else {return }
//        let conf = URLSessionConfiguration.default
//        conf.timeoutIntervalForRequest = 3
        
        // Get the CGImage on which to perform requests.
        guard let cgImage = image.cgImage else { return }
        

        // Create a new image-request handler.
        let requestHandler = VNImageRequestHandler(cgImage: cgImage)

        // Create a new request to recognize a human body pose.
        let request = VNDetectHumanBodyPoseRequest(completionHandler: bodyPoseHandler)

        do {
            // Perform the body pose-detection request.
            try requestHandler.perform([request])
        } catch {
            print("Unable to perform the request: \(error).")
        }
        
        
        
        
        
//        return URLSession(configuration: conf).dataTaskPublisher(for: url)
//            .map(\.data)
//            .decode(type: Compliment.self, decoder: JSONDecoder())
//            .map(\.compliment)
//            .replaceError(with: "Currently I can only say: it's pure beauty")
//            .eraseToAnyPublisher()
        
        
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
          
            
//            guard let group = recognizedJointGroups.randomElement() else {
//                compliment = "You have a beautiful face4"
//                return
//            }
//            guard let jointsOfGroup = try? observation.recognizedPoints(group)
//            else {
//                compliment = "You have a beautiful face2"
//                return
//            }
//
//            guard let joint = jointsOfGroup.randomElement(), joint.value.confidence > 0 else {
//                compliment = "You have a beautiful face5"
//                return
//            }
    
            
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
            
            compliment = "You have  beautiful \(groupName), and especially \(jointName) "
            
        
 
        
       
        
        
        
    }
    
//    func processObservation(_ observation: VNHumanBodyPoseObservation) {
//        
//        // Retrieve all torso points.
//        guard let recognizedPoints =
//                try? observation.recognizedPoints(.torso) else { return }
        
        // Torso joint names in a clockwise ordering.
//        let torsoJointNames: [VNHumanBodyPoseObservation.JointName] = [
//            .neck,
//            .rightShoulder,
//            .rightHip,
//            .root,
//            .leftHip,
//            .leftShoulder
//        ]
//
//        // Retrieve the CGPoints containing the normalized X and Y coordinates.
//        let imagePoints: [CGPoint] = torsoJointNames.compactMap {
//            guard let point = recognizedPoints[$0], point.confidence > 0 else { return nil }
//
//            // Translate the point from normalized-coordinates to image coordinates.
//            return VNImagePointForNormalizedPoint(point.location,
//                                                  Int(imageSize.width),
//                                                  Int(imageSize.height))
//        }
//
//        // Draw the points onscreen.
//        draw(points: imagePoints)
//    }
}
