//
//  ImageListViewModel.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import Foundation
import Combine

enum NavigationControllers {
    case addImage
    case none
}

final class ImageListViewModel {
    
    //MARK: - Private properties
    
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Public properties
    
    @Published var data: ImageList?
    @Published var navigate: NavigationControllers = .none
}

//MARK: - Public extension

extension ImageListViewModel {
    
    //MARK: - First open data
    
    func fetchFirstOpenData() {
        ImageService.getImageList.fetch()
            .sink { _ in
                return
            } receiveValue: { [weak self] (completion: ImageList) in
                self?.data = completion
            }
            .store(in: &bindings)
    }
}
