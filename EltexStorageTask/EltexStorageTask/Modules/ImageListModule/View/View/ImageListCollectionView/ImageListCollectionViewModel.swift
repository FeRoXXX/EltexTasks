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
                } else {
                    self?.progress = value.progress
                }
            }
            .store(in: &bindings)
    }
}
