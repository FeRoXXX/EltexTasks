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
    
    @Published var data: ImageList?
    @Published var navigate: NavigationControllers = .none
    
    private var bindings: Set<AnyCancellable> = []
    
    init() {
        fetchFirstOpenData()
    }
}

//MARK: - Private extension

private extension ImageListViewModel {
    
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
