//
//  UIImage+extension.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 23.11.2024.
//

import UIKit
import AVFoundation

extension UIImage {
    
    //MARK: - Rounded current image
    
    func roundedImage() -> UIImage {
        let minSide = min(size.width, size.height)
        let renderer = UIGraphicsImageRenderer(size: CGSize(width: minSide, height: minSide))
        
        return renderer.image { context in
            let rect = CGRect(origin: .zero, size: CGSize(width: minSide, height: minSide))
            UIBezierPath(ovalIn: rect).addClip()
            draw(in: rect)
        }
    }
    
    //MARK: - Resize current image
    
    func resize(_ size: CGSize) -> UIImage {
        let maxSize = CGSize(width: size.width, height: size.height)
        
        let availableRect = AVFoundation.AVMakeRect(
            aspectRatio: size,
            insideRect: .init(origin: .zero, size: maxSize)
        )
        let targetSize = availableRect.size
        
        let format = UIGraphicsImageRendererFormat()
        format.scale = 1
        let renderer = UIGraphicsImageRenderer(size: targetSize, format: format)
        
        let resized = renderer.image { _ in
            draw(in: CGRect(origin: .zero, size: targetSize))
        }
        
        return resized
    }
}
