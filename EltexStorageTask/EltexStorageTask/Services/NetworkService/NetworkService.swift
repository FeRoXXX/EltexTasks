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
    case getSavedImageFromURL(URL)
    case getImageFromURL(String)
    
    //MARK: - Private properties
    
    private var provider: URLSessionProvider {
        let provider = URLSessionProvider()
        return provider
    }
}

extension NetworkService {
    
    //MARK: - Fetch functions
    
    func fetch() -> AnyPublisher<Data, Error> {
        guard let request = makeRequest() else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        
        return provider.getURLSession()
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
    
    func fetchWithProgress() -> AnyPublisher<(progress: Double, data: Data?), Error> {
        
        guard let request = makeRequest() else {
            return Fail(error: NetworkError.invalidURL)
                .eraseToAnyPublisher()
        }
        return provider.download(from: request)
    }
    
    //MARK: - URL and Request generating
    
    private func makeRequest() -> URLRequest? {
        let baseURL = "http://164.90.163.215:1337"
        
        switch self {
        case .getImageMetadata:
            guard let requestURL = URL(string: "\(baseURL)/api/upload/files") else { return nil }
            return URLRequest(url: requestURL)
        case .getSavedImageFromURL(let url):
            guard let requestURL = URL(string: "\(baseURL)/uploads/\(url.lastPathComponent)") else { return nil }
            return URLRequest(url: requestURL)
        case .getImageFromURL(let url):
            guard let requestURL = URL(string: url) else { return nil }
            return URLRequest(url: requestURL)
        }
    }
}
