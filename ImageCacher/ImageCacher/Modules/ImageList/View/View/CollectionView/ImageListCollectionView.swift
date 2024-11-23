//
//  ImageListCollectionView.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 20.11.2024.
//

import UIKit

final class ImageListCollectionView: UICollectionView {
    
    //MARK: - Private properties
    
    var viewModel: ImageListViewModelInput?
    
    //MARK: - Initializaton
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        dataSource = self
        self.register(ImageListCollectionViewCell.self, forCellWithReuseIdentifier: ImageListCollectionViewCell.identifier)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDataSource

extension ImageListCollectionView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let viewModel else { return 0 }
        return viewModel.data.data.count * viewModel.data.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageListCollectionViewCell.identifier, for: indexPath) as? ImageListCollectionViewCell,
              let viewModel else { return UICollectionViewCell() }
        cell.setupImage(with: URL(string: viewModel.data.data[indexPath.row % 8]))
        return cell
    }
}
