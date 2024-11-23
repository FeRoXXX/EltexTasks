//
//  ImageListView.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 20.11.2024.
//

import UIKit
import SnapKit

final class ImageListView: UIView {
    
    //MARK: - Private properties
    
    private lazy var collectionView: ImageListCollectionView = {
        let collectionView = ImageListCollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.viewModel = viewModel
        return collectionView
    }()
    private let viewModel: ImageListViewModel
    
    //MARK: - Initialization
    
    init(viewModel: ImageListViewModel) {
        self.viewModel = viewModel
        super.init(frame: .zero)
        setupUI()
        bind()
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
        addSubview(collectionView)
    }
    
    func setupConstraints() {
        collectionView.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.bottom.equalTo(safeAreaLayoutGuide.snp.bottom)
        }
    }
    
    //MARK: - Bindings
    
    func bind() {
        viewModel.dataIsLoading = { [weak self] in
            self?.collectionView.reloadData()
        }
    }
    
    //MARK: - Create layout
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 10
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/4.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalWidth(1.0 / 4.0))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 4)
        group.interItemSpacing = .fixed(spacing)
    
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}
