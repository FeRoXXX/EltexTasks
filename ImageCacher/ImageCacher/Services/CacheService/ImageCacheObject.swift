//
//  ImageCacheObject.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 21.11.2024.
//

import UIKit

final class ImageCacheObject: NSObject, NSCoding, NSSecureCoding {
    
    //MARK: - Static properties
    
    static var supportsSecureCoding: Bool = true
    
    //MARK: - Public properties
    
    var image: UIImage
    var isCircle: Bool
    var isResized: Bool
    
    //MARK: - Initialization
    
    init(image: UIImage, isCircle: Bool = false, isResized: Bool = false) {
        self.image = image
        self.isCircle = isCircle
        self.isResized = isResized
    }
    
    required init?(coder: NSCoder) {
        guard let imageData = coder.decodeObject(forKey: "imageData") as? Data,
              let decodedImage = UIImage(data: imageData) else {
            return nil
        }
        self.image = decodedImage
        self.isCircle = coder.decodeBool(forKey: "isCircle")
        self.isResized = coder.decodeBool(forKey: "isResized")
    }
    
    //MARK: - Encode function
    
    func encode(with coder: NSCoder) {
        if let imageData = image.pngData() {
            coder.encode(imageData, forKey: "imageData")
        }
        coder.encode(isCircle, forKey: "isCircle")
        coder.encode(isResized, forKey: "isResized")
    }
}

