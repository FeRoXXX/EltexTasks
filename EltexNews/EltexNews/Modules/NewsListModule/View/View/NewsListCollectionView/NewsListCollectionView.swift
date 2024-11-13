//
//  NewsListCollectionView.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import SnapKit

final class NewsListCollectionView: UICollectionView {
    
    private var data: [String] = ["", "","", "","", "","", "","", "","", "","", "","", "","", "","", ""]
    
    //MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        self.delegate = self
        self.dataSource = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension NewsListCollectionView: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {
            return UICollectionViewCell()
        }
        return cell
    }
}