//
//  NetworkService.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import Foundation
import Combine

//MARK: - Service errors

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case redirection
    case clientError
    case serverError
}

enum NetworkService {
    case getImageMetadata
    case getImageFromURL(URL)
    
    //MARK: - Private properties
    
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.httpAdditionalHeaders = [
            "Authorization": "Bearer 11c211d104fe7642083a90da69799cf055f1fe1836a211aca77c72e3e069e7fde735be9547f0917e1a1000efcb504e21f039d7ff55bf1afcb9e2dd56e4d6b5ddec3b199d12a2fac122e43b4dcba3fea66fe428e7c2ee9fc4f1deaa615fa5b6a68e2975cd2f99c65a9eda376e5b6a2a3aee1826ca4ce36d645b4f59f60cf5b74a"
        ]
        return URLSession(configuration: configuration)
    }
}

extension NetworkService {
    
    //MARK: - Fetch function
    
    func fetch() -> AnyPublisher<Data, Error> {
        guard let request = makeRequest() else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return urlSession
            .dataTaskPublisher(for: request)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw NetworkError.badResponse
                }
                
                switch httpResponse.statusCode {
                case 200..<300:
                    return data
                case 300..<400:
                    throw NetworkError.redirection
                case 400..<500:
                    throw NetworkError.clientError
                default:
                    throw NetworkError.serverError
                }
            }
            .eraseToAnyPublisher()
    }
    
    //MARK: - URL and Request generating
    
    private func makeRequest() -> URLRequest? {
        let baseURL = "http://164.90.163.215:1337"
        
        switch self {
        case .getImageMetadata:
            guard let requestURL = URL(string: "\(baseURL)/api/upload/files") else { return nil }
            return URLRequest(url: requestURL)
        case .getImageFromURL(let url):
            guard let requestURL = URL(string: "\(baseURL)/uploads/\(url.lastPathComponent)") else { return nil }
            return URLRequest(url: requestURL)
        }
    }
    
    
}
