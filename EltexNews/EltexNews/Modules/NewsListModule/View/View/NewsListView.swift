//
//  NewsListView.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import SnapKit

final class NewsListView: UIView {
    
    //MARK: - Private properties
    
    private var searchBar: UISearchBar = {
        let searchString = UISearchBar()
        searchString.searchBarStyle = .minimal
        return searchString
    }()
    
    private lazy var newsCollectionView: NewsListCollectionView = {
        let collectionView = NewsListCollectionView(frame: .zero, collectionViewLayout: createLayout())
        return collectionView
    }()
    
    //MARK: - Public properties
    
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

private extension NewsListView {
    
    //MARK: - UI initialization functions
    
    
    func setupUI() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(searchBar)
        addSubview(newsCollectionView)
    }
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview()
            make.top.equalToSuperview().inset(70)
        }
        newsCollectionView.snp.makeConstraints { make in
            make.top.equalTo(searchBar.snp.bottom).inset(-10)
            make.leading.trailing.bottom.equalToSuperview().inset(10)
        }
    }
    
    func createLayout() -> UICollectionViewLayout {
        let spacing: CGFloat = 5
        let itemSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0/2.0), heightDimension: .fractionalHeight(1.0))
        let item = NSCollectionLayoutItem(layoutSize: itemSize)
        let groupSize = NSCollectionLayoutSize(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 2.5))
        let group = NSCollectionLayoutGroup.horizontal(layoutSize: groupSize, repeatingSubitem: item, count: 2)
        group.interItemSpacing = .fixed(spacing)
        
        let section = NSCollectionLayoutSection(group: group)
        section.contentInsets = .init(top: spacing, leading: spacing, bottom: spacing, trailing: spacing)
        section.interGroupSpacing = spacing
        let layout = UICollectionViewCompositionalLayout(section: section)
        return layout
    }
}

//MARK: - Public extension

extension NewsListView {
    
}
