//
//  ImageCacheService.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 29.11.2024.
//

import UIKit

final class ImageCacheService {
    
    //MARK: - Private properties
    
    private var cache: NSCache<NSString, UIImage> = .init()
    
    //MARK: - Public properties
    
    static var shared: ImageCacheService = .init()
    
    //MARK: - Cache functions
    
    func getCachedImage(for url: URL) -> UIImage? {
        cache.object(forKey: url.absoluteString as NSString)
    }
    
    func setCachedImage(_ image: UIImage, for url: URL) {
        cache.setObject(image, forKey: url.absoluteString as NSString)
    }
}
