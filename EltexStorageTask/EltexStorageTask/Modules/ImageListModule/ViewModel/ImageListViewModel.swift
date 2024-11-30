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
    
    private(set) var newDataPublisher: PassthroughSubject<[IndexPath], Never> = .init()
    private(set) var deleteDataPublisher: PassthroughSubject<[IndexPath], Never> = .init()
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Public properties
    
    @Published var data: ImageList? = []
    @Published var navigate: NavigationControllers = .none
}

//MARK: - Private extension

private extension ImageListViewModel {
    
    //MARK: - Append new data
    
    func appendNewData(newData: ImageList) {
        guard let existingData = data else {
                self.data = newData
                let indexes = newData.indices.map { IndexPath(row: $0, section: 0) }
                newDataPublisher.send(indexes)
                return
            }
            
            var indexes: [IndexPath] = []
            var updatedData = existingData

            for (index, newElement) in newData.enumerated() {
                if index >= existingData.count || newElement != existingData[index] {
                    indexes.append(IndexPath(row: index, section: 0))
                    updatedData.insert(newElement, at: index)
                }
            }

            self.data = updatedData
            newDataPublisher.send(indexes)
    }
    
    //MARK: - Delete cell
    
    func deleteCell(newData: ImageList) {
        guard let data else { return }
        let indexes = data.enumerated().compactMap { index, element in
            newData.contains(element) ? nil : IndexPath(row: index, section: 0)
        }
        self.data = newData
        deleteDataPublisher.send(indexes)
    }
}

//MARK: - Public extension

extension ImageListViewModel {
    
    //MARK: - First open data
    
    func fetchFirstOpenData() {
        ImageService.getImageList.fetch()
            .sink { _ in
                return
            } receiveValue: { [weak self] (completion: ImageList) in
                if completion.count > self?.data?.count ?? 0 {
                    self?.appendNewData(newData: completion)
                } else {
                    self?.deleteCell(newData: completion)
                }
            }
            .store(in: &bindings)
    }
}
