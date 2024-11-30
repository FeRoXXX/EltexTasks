//
//  ImageUploadViewModel.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 28.11.2024.
//

import Foundation
import Combine

enum loaderStatus: String {
    case downloading = "Скачивание..."
    case optimization = "Оптимизация..."
    case sendToServer = "Отправка на сервер"
    case none
}

final class ImageUploadViewModel {
    
    //MARK: - Private properties
    
    private(set) var uploadFromGalleryPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var onImageLoadToServer: PassthroughSubject<Void, Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    private var compressedImage: Data?
    
    //MARK: - Public properties
    
    @Published var image: ImageListCellDataModel?
    @Published var loadingState: loaderStatus = .none
    
}

//MARK: - Private properties

private extension ImageUploadViewModel {
    
    //MARK: - Save image to cache function
    
    func cacheImage(url: URL? = nil) {
        guard let url,
            let image else { return }
        
        ImageCacheService.shared.setCachedImage(image.image, for: url)
    }
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
        loadingState = .downloading
        ImageUploadService.getImageFromURL(url)
            .fetch()
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                switch value {
                case .finished:
                    return
                default:
                    self?.loadingState = .none
                }
                return
            } receiveValue: { [weak self] (value: ImageListCellDataModel) in
                DispatchQueue.main.async {
                    self?.loadingState = .optimization
                }
                self?.prepareImage(imageData: value)
            }
            .store(in: &bindings)
    }
    
    //MARK: - Image optimization functions
    
    func prepareImage(imageData: ImageListCellDataModel, url: URL? = nil) {
        DispatchQueue.global().async { [weak self] in
            guard let imageAndData = imageData.image.compressedImage(),
                  let image = imageAndData.0 else { return }
            DispatchQueue.main.async {
                self?.compressedImage = imageAndData.1
                self?.image = ImageListCellDataModel(image: image)
                self?.loadingState = .none
            }
        }
    }
    
    //MARK: - Send image to server
    
    func sendImageToServer() {
        guard let data = compressedImage else { return }
        loadingState = .sendToServer
        ImageUploadService.sendImageToServer(data).fetch()
            .receive(on: DispatchQueue.main)
            .sink { _ in
                return
            } receiveValue: { [weak self] (value: ImageList) in
                self?.loadingState = .none
                if let data = value.first {
                    self?.cacheImage(url: URL(string: data.url))
                }
                self?.onImageLoadToServer.send()
            }
            .store(in: &bindings)
    }
}
