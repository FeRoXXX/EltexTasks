//
//  RequestConstraint.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 23.11.2024.
//

import Foundation

final class RequestConstraint {
    
    //MARK: - Static properties
    
    static let shared = RequestConstraint()
    
    //MARK: - Initialization
    
    private init() {}
    
    //MARK: - Queue property
    
    let operationQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 3
        return queue
    }()
}
