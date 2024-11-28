//
//  ImageService.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit
import Combine

//MARK: - Service errors

enum ImageServiceError: Error {
    case decodingError
}

enum ImageService {
    case getImageList
    case getImageFromURL(url: URL)
}

extension ImageService {
    
    //MARK: - Decoding function
    
    func fetch<T: Codable>() -> AnyPublisher<T, Error> {
        
        switch self {
        case .getImageList:
            return NetworkService.getImageMetadata.fetch()
                .decode(type: T.self, decoder: JSONDecoder())
                .eraseToAnyPublisher()
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
