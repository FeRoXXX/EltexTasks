//
//  ImageListCollectionView.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 20.11.2024.
//

import UIKit

final class ImageListCollectionView: UICollectionView {
    
    //MARK: - Private properties
    
    private let data: [Int] = [0,1,2,3,4,5,6,7,8,9]
    
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
        return data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ImageListCollectionViewCell.identifier, for: indexPath) as? ImageListCollectionViewCell else { return UICollectionViewCell() }
        cell.layer.cornerRadius = 12
        cell.layer.masksToBounds = true
        cell.layer.borderWidth = 1
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
}
