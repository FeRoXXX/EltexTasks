//
//  ImageListView.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit
import SnapKit

final class ImageListView: UIView {
    
    //MARK: - Private properties
    
    lazy var imageListCollectionView: ImageListCollectionView = {
        let collectionView = ImageListCollectionView(frame: .zero, collectionViewLayout: createLayout())
        return collectionView
    }()
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension ImageListView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(imageListCollectionView)
    }
    
    func setupConstraints() {
        imageListCollectionView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Create layout functions
    
    func createLayout() -> UICollectionViewLayout {
        
        let itemSize = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(0.5),
                                                                heightDimension: .fractionalHeight(1.0)))
        itemSize.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 5)
        let groupSize = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0),
                                                                           heightDimension: .fractionalWidth(0.5)),
                                                         subitems: [itemSize])
        let section = NSCollectionLayoutSection(group: groupSize)
        return UICollectionViewCompositionalLayout(section: section)
    }
}
