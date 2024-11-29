//
//  ImageUploadService.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 29.11.2024.
//

import UIKit
import Combine

//MARK: - Service errors

enum ImageUploadServiceError: Error {
    case decodingError
}

enum ImageUploadService {
    case getImageFromURL(String)
}

extension ImageUploadService {
    
    //MARK: - Decoding function
    
    func fetch<T: Codable>() -> AnyPublisher<T, Error> {
        
        switch self {
        case .getImageFromURL(let url):
            return NetworkService.getImageFromURL(url).fetch()
                .tryMap({ data in
                    guard let image = UIImage(data: data) else { throw ImageServiceError.decodingError }
                    guard let imageType = ImageListCellDataModel(image: image) as? T else { throw ImageServiceError.decodingError }
                    return imageType
                })
                .eraseToAnyPublisher()
        }
    }
}
