//
//  NetworkManager.swift
//  BeautyChecker
//
//  Created by Gleb Martynov on 30.04.22.
//

import Foundation
import Combine

struct Compliment: Codable {
    var compliment: String
}

class NetworkManager {
    static let shared = NetworkManager()
    
    func fetchCompliment() -> AnyPublisher <String, Never> {
        guard let url = URL(string: "https://complimentr.com/api") else {
            return Just( "Currently I can only say: it's amazing").eraseToAnyPublisher()
        }
        let conf = URLSessionConfiguration.default
        conf.timeoutIntervalForRequest = 3
        
        return URLSession(configuration: conf).dataTaskPublisher(for: url)
            .map(\.data)
            .decode(type: Compliment.self, decoder: JSONDecoder())
            .map(\.compliment)
            .replaceError(with: "Currently I can only say: it's pure beauty")
            .eraseToAnyPublisher()
        
    }
    
}
