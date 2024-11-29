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
    private(set) var onImageLoadToServer: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Public properties
    
    @Published var image: ImageListCellDataModel?
    @Published var loadingState: Bool?
    
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
        loadingState = true
        ImageUploadService.getImageFromURL(url)
            .fetch()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] _ in
                self?.loadingState = false
                return
            } receiveValue: { [weak self] (value: ImageListCellDataModel) in
                self?.prepareImage(imageData: value)
            }
            .store(in: &bindings)
    }
    
    func prepareImage(imageData: ImageListCellDataModel) {
        DispatchQueue.global().async { [weak self] in
            guard let image = imageData.image.compressedImage() else { return }
            DispatchQueue.main.async {
                self?.image = ImageListCellDataModel(image: image)
                self?.loadingState = false
            }
        }
    }
    
    func sendImageToServer() {
        guard let data = image?.image.jpegData(compressionQuality: 1.0) else { return }
        ImageUploadService.sendImageToServer(data).fetch()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                return
            } receiveValue: { [weak self] (value: ImageList) in
                self?.onImageLoadToServer.send()
            }
            .store(in: &bindings)
    }
}
