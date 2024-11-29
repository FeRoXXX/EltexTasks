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
                print(value)
                return
            } receiveValue: { [weak self] (value: ImageListCellDataModel) in
                self?.currentCellImage = value
            }
            .store(in: &bindings)
    }
}
