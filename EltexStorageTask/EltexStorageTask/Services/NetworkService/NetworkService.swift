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
    case sendImageToServer(Data)
    
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
        case .sendImageToServer(let data):
            guard let requestURL = URL(string: "\(baseURL)/api/upload") else { return nil }
            var request = URLRequest(url: requestURL)
            request.httpMethod = "POST"
            let boundary = UUID().uuidString
            request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
            let httpBody = createMultipartFormDataBody(image: data, imageName: boundary, boundary: boundary)
            request.httpBody = httpBody
            return request
        }
    }
    
    //MARK: - Create form data
    
    private func createMultipartFormDataBody(image: Data, imageName: String, boundary: String) -> Data {
        var body = Data()

        let fileName = "\(imageName).jpg"
        let mimeType = "image/jpeg"
        body.append("\r\n--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=files; filename=\"\(fileName)\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: \(mimeType)\r\n\r\n".data(using: .utf8)!)
        body.append(image)
        
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)
        return body
    }
}
