//
//  ImageListCollectionView.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit
import Combine

final class ImageListCollectionView: UICollectionView {
    
    //MARK: - Private properties
    
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Public properties
    
    var data: [String] = []
    
    //MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(ImageListCollectionViewCell.self)
        dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension ImageListCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.reuse(ImageListCollectionViewCell.self, for: indexPath)
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        let viewModel = ImageListCollectionViewModel(url: data[indexPath.row])
        cell.configureCell(with: viewModel)
        cell.tapPublisher
            .receive(on: DispatchQueue.main)
            .sink { _ in
                viewModel.fetch()
            }
            .store(in: &bindings)
        return cell
    }
}
