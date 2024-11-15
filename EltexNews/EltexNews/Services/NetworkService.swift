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
    case getPostsWithoutSort(searchString: String, pageNumber: Int = 1)
    case getPostsWithSort(searchingString: String, pageNumber: Int = 1, sort: String)
    
    private var urlSession: URLSession {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 20
        configuration.httpAdditionalHeaders = [
            "Authorization": "Bearer b01c529c64d84b45b4908e317ba0e4b9"
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
                return data
            }
            .decode(type: NewsListGeneralModel.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
    
    func makeRequest() -> URLRequest? {
        let baseURL = "https://newsapi.org/v2/everything"
        switch self {
        case .getPostsWithoutSort(let searchString, let pageNumber):
            guard let requestURL = URL(string: "\(baseURL)?pageSize=20&page=\(pageNumber)&q=\(searchString)") else {
                return nil
            }
            return URLRequest(url: requestURL)
            
        case .getPostsWithSort(let searchingString, let pageNumber, let sort):
            guard let requestURL = URL(string: "\(baseURL)?pageSize=20&page=\(pageNumber)&q=\(searchingString)&sortBy=\(sort)") else {
                return nil
            }
            return URLRequest(url: requestURL)
        }
    }
}
