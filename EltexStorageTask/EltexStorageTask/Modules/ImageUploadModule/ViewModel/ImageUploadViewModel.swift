//
//  ImageUploadViewModel.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 28.11.2024.
//

import Foundation
import Combine

final class ImageUploadViewModel {
    
    //MARK: - Private properties
    
    private(set) var uploadFromGalleryPublisher: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Public properties
    
    @Published var image: ImageListCellDataModel?
    
}

//MARK: - Public extension

extension ImageUploadViewModel {
    
    //MARK: - When upload from gallery button tapped
    
    func onUploadFromGallery() {
        uploadFromGalleryPublisher
            .send()
    }
    
    //MARK: - Get image from url
    
    func getImageFromURL(_ url: String) {
        ImageUploadService.getImageFromURL(url)
            .fetch()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                return
            } receiveValue: { [weak self] (value: ImageListCellDataModel) in
                self?.image = value
            }
            .store(in: &bindings)
    }
}
