//
//  Downloadable.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 21.11.2024.
//

import UIKit
import AVFoundation

protocol Downloadable {
    
    //MARK: - Public properties
    
    var isLoading: (() -> Void)? { get set }
    var isCancelled: Bool { get set }
    var id: UUID { get }
    
    //MARK: - Public functions
    
    mutating func loadImage(from url: URL, withOptions: [DownloadOptions])
}

extension Downloadable where Self: UIImageView {
    
    //MARK: - loadImage main function
    
    mutating func loadImage(from url: URL, withOptions options: [DownloadOptions] = []) {
        isCancelled = false
        let operation = BlockOperation { [weak self] in
            
            if self?.isCancelled ?? true{
                DispatchQueue.main.sync {
                    self?.isCancelled = false
                }
                return
            }

            if let object = ImageCache.shared.get(key: url.absoluteString) {
                DispatchQueue.global().async {
                    if self?.isCancelled ?? true {
                        DispatchQueue.main.sync {
                            self?.isCancelled = false
                        }
                        return
                    }
                    
                    self?.processOperation(object, options)
                    self?.updateImage(object.image)
                }
                return
            }
            NetworkService.getImage(url, self?.id ?? UUID()).fetch { result in
                if self?.isCancelled ?? true {
                    DispatchQueue.main.async {
                        self?.isCancelled = false
                    }
                    return
                }
                
                switch result {
                case .success(let success):
                    let newObject = ImageCacheObject(image: success)
                    DispatchQueue.global().async {
                        if self?.isCancelled ?? true{
                            DispatchQueue.main.sync {
                                self?.isCancelled = false
                            }
                            return
                        }
                        self?.processOperation(newObject, options, url)
                        self?.updateImage(newObject.image)
                    }
                case .failure(_):
                    return
                }
            }
        }
        
        RequestConstraint.shared.operationQueue.addOperation(operation)
    }
    
    //MARK: - Process operation function
    
    private func processOperation(_ object: ImageCacheObject, _ options: [DownloadOptions], _ url: URL? = nil) {
        let semaphore = DispatchSemaphore(value: 0)
        options.forEach { [weak self] in
            switch $0 {
            case .circle:
                if self?.isCancelled ?? true {
                    DispatchQueue.main.async {
                        self?.isCancelled = false
                    }
                    return
                }
                if !object.isCircle {
                    DispatchQueue.global().async {
                        object.image = object.image.roundedImage()
                        object.isCircle = true
                        semaphore.signal()
                    }
                    semaphore.wait()
                }
            case .resize:
                if self?.isCancelled ?? true {
                    DispatchQueue.main.sync {
                        self?.isCancelled = false
                    }
                    return
                }
                DispatchQueue.main.async {
                    let size = self?.bounds.size ?? CGSize(width: 0, height: 0)
                    DispatchQueue.global().async {
                        if !object.isResized {
                            object.image = object.image.resize(size)
                            object.isResized = true
                        }
                        semaphore.signal()
                    }
                }
                semaphore.wait()
            case .cached(let path):
                guard let url else { break }
                ImageCache.shared.add(key: url.absoluteString, value: object, typeOfCache: path)
            }
        }
    }
    
    //MARK: - Update image on UI
    
    private func updateImage(_ image: UIImage) {
        DispatchQueue.main.async { [weak self] in
            self?.isLoading?()
            self?.image = image
        }
    }
}
