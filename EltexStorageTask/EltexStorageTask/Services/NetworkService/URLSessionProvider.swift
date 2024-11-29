//
//  URLSessionProvider.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 29.11.2024.
//

import Foundation
import Combine

final class URLSessionProvider: NSObject {
    
    //MARK: - Private properties
    
    private var progressSubject = PassthroughSubject<(Double, Data?), Error>()
    
    private lazy var urlSession: URLSession = {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 10
        configuration.httpAdditionalHeaders = [
            "Authorization": "Bearer 11c211d104fe7642083a90da69799cf055f1fe1836a211aca77c72e3e069e7fde735be9547f0917e1a1000efcb504e21f039d7ff55bf1afcb9e2dd56e4d6b5ddec3b199d12a2fac122e43b4dcba3fea66fe428e7c2ee9fc4f1deaa615fa5b6a68e2975cd2f99c65a9eda376e5b6a2a3aee1826ca4ce36d645b4f59f60cf5b74a"
        ]
        return URLSession(configuration: configuration, delegate: self, delegateQueue: nil)
    }()
    
    //MARK: - Download function
    
    func download(from request: URLRequest) -> AnyPublisher<(progress: Double, data: Data?), Error> {
            urlSession.downloadTask(with: request).resume()
            
            return progressSubject
                .map { progress in (progress) }
                .eraseToAnyPublisher()
        }
    
    //MARK: - Get urlSession function
    
    func getURLSession() -> URLSession {
        return urlSession
    }
}

//MARK: - URLSessionDownloadDelegate

extension URLSessionProvider: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        guard totalBytesExpectedToWrite > 0 else { return }
        let progress = Double(totalBytesWritten) / Double(totalBytesExpectedToWrite)
        progressSubject.send((progress, nil))
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        do {
            let data = try Data(contentsOf: location)
            progressSubject.send((1.0, data))
        } catch {
            progressSubject.send(completion: .failure(error))
        }
        progressSubject.send(completion: .finished)
    }
}
