//
//  ImageListViewModel.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 23.11.2024.
//

import Foundation

final class ImageListViewModel: ImageListViewModelInput, ImageListViewModelOutput {
    
    //MARK: - Private properties
    
    var data: CollectionModel = .init(data: []) {
        didSet {
            dataIsLoading?()
        }
    }
    
    //MARK: - Public properties
    
    var dataIsLoading: (() -> Void)?
    
    //MARK: - Initialization
    
    init(data: CollectionModel) {
        self.data = data
    }
}
