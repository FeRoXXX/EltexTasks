//
//  Extension+UIImage.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 29.11.2024.
//

import UIKit

extension UIImage {
    
    //MARK: - Image compression method
    
    func compressedImage() -> UIImage? {
        let targetSize = 1 * 1024 * 1024
        
        var compression: CGFloat = 1.0
        guard var imageData = self.jpegData(compressionQuality: compression) else { return nil }
        
        if imageData.count <= targetSize {
            return UIImage(data: imageData)
        }
        
        while imageData.count > targetSize && compression > 0.1 {
            compression -= 0.1
            if let compressedData = self.jpegData(compressionQuality: compression) {
                imageData = compressedData
            }
        }
        return UIImage(data: imageData)
    }
}
