//
//  NetworkService.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import Combine

enum NetworkError: Error {
    case invalidURL
    case badResponse
    case statusCode(Int)
}

enum NetworkService {
    case getPostsWithoutSort(searchString: String)
    case getPostsWithSort(searchingString: String, sort: String)
    
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.httpAdditionalHeaders = [
            "Authorization": "Bearer 8f63e1069a0e4dbdb44fb33f2ab742d5"
        ]
        
        return URLSession(configuration: configuration)
    }
}

extension NetworkService {
    
    func fetch() -> AnyPublisher<NewsListGeneralModel, Error> {
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
                
                guard (200...299).contains(httpResponse.statusCode) else {
                    throw NetworkError.statusCode(httpResponse.statusCode)
                }
                print(try JSONDecoder().decode(NewsListGeneralModel.self, from: data))
                return data
            }
            .decode(type: NewsListGeneralModel.self, decoder: JSONDecoder())
            .handleEvents(
                receiveSubscription: { _ in print("Starting network request for \(request)") },
                receiveOutput: { data in print("Received data of size: \(data) bytes") },
                receiveCompletion: { completion in print("Request completed with: \(completion)") },
                receiveCancel: { print("Request was cancelled") }
            )
            .eraseToAnyPublisher()
    }
    
    func makeRequest() -> URLRequest? {
        let baseURL = "https://newsapi.org/v2/everything"
        switch self {
        case .getPostsWithoutSort(let searchString):
            guard let requestURL = URL(string: "\(baseURL)?q=\(searchString)") else {
                return nil
            }
            return URLRequest(url: requestURL)
            
        case .getPostsWithSort(let searchingString, let sort):
            guard let requestURL = URL(string: "\(baseURL)?q=\(searchingString)&sortBy=\(sort)") else {
                return nil
            }
            return URLRequest(url: requestURL)
        }
    }
}
