//
//  NetworkService.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 21.11.2024.
//

import Foundation
import UIKit

//MARK: - Service errors enum

enum serviceError: Error {
    case noData
    case invalidResponse
}

enum NetworkService {
    //MARK: - Type of requests
    
    case getImage(URL, UUID)
    
    //MARK: - URLSession object
    
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 3
        return URLSession(configuration: configuration)
    }
    
    //MARK: - Tasks dictionary
    
    static var tasks: [UUID: URLSessionDataTask] = [:]
}

extension NetworkService {
    
    //MARK: - Fetch function
    
    func fetch(completion: @escaping (Result<UIImage, Error>) -> Void) {
            
            let result = makeRequest()
            guard let request = result.0 else {
                return completion(.failure(serviceError.invalidResponse))
            }
            
            let task = urlSession.dataTask(with: request) { data, _, error in
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
        DispatchQueue.main.sync {
            NetworkService.tasks[result.1] = task
        }
            task.resume()
    }
    
    //MARK: - Make request function
    
    private func makeRequest() -> (URLRequest?, UUID) {
        switch self {
        case .getImage(let url, let id):
            return (URLRequest(url: url), id)
        }
    }
    
    //MARK: - Static function
    
    static func cancelRequest(id: UUID) {
        tasks[id]?.cancel()
    }
}
