//
//  ImageListCollectionViewModel.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import Foundation
import Combine

final class ImageListCollectionViewModel {
    
    //MARK: - Private properties
    
    private var url: String
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Public properties
    
    @Published var currentCellImage: ImageListCellDataModel?
    @Published var progress: Double = 0
    
    //MARK: - Initialization
    
    init(url: String) {
        self.url = url
        checkImageInCache()
    }
    
    //MARK: - Fetch function
    
    func fetch() {
        guard let url = URL(string: url) else { return }
        
        ImageService.getImageFromURL(url: url)
            .fetch()
            .receive(on: DispatchQueue.main)
            .sink { value in
                return
            } receiveValue: { [weak self] (value: FetchResultDataModel) in
                if let value = value.image {
                    self?.currentCellImage = value
                    self?.saveImageToCache(image: value)
                } else {
                    self?.progress = value.progress
                }
            }
            .store(in: &bindings)
    }
    
    //MARK: - Check image in cache
    
    func checkImageInCache() {
        guard let url = URL(string: url) else { return }
        if let image = ImageCacheService.shared.getCachedImage(for: url) {
            self.currentCellImage = ImageListCellDataModel(image: image)
        }
    }
}

//MARK: - Private extension

private extension ImageListCollectionViewModel {
    
    //MARK: - Save image to cache
    
    func saveImageToCache(image: ImageListCellDataModel) {
        guard let url = URL(string: url) else { return }
        ImageCacheService.shared.setCachedImage(image.image, for: url)
    }
}
