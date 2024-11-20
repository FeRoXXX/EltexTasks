//
//  NetworkService.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 21.11.2024.
//

import Foundation
import UIKit

enum serviceError: Error {
    case noData
    case invalidResponse
}

enum NetworkService {
    case getImage(String)
    
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        return URLSession(configuration: configuration)
    }
}

extension NetworkService {
    
    func fetch(completion: @escaping (Result<UIImage, Error>) -> Void) {
        guard let request = makeRequest() else {
            return completion(.failure(serviceError.invalidResponse))
        }
        
        urlSession.dataTask(with: request) { data, _, error in
            if let error {
                return completion(.failure(error))
            } else if let data {
                if let image = UIImage(data: data) {
                    return completion(.success(image))
                } else {
                    return completion(.failure(serviceError.noData))
                }
            }
        }
    }
    
    func makeRequest() -> URLRequest? {
        switch self {
        case .getImage(let url):
            guard let requestURL = URL(string: url) else {
                return nil
            }
            
            return URLRequest(url: requestURL)
        }
    }
}
