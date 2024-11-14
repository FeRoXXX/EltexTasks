//
//  NewsListView.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import SnapKit
import Combine

final class NewsListView: UIView {
    
    //MARK: - Private properties
    
    private lazy var sortingMethodMenu: UIMenu = {
        let menu = UIMenu(title: "Sorting method", children: [
            UIAction(title: "By date") { [weak self] _ in
                self?.menuPublisher.send("publishedAt")
            },
            UIAction(title: "By popularity") { [weak self] _ in
                self?.menuPublisher.send("popularity")
            }
        ])
        return menu
    }()
    
    private lazy var sortButton: UIButton = {
        let button = UIButton()
        button.menu = sortingMethodMenu
        var configuration = UIButton.Configuration.plain()
        configuration.image = UIImage(systemName: "gear")
        configuration.baseForegroundColor = .lightGray
        configuration.contentInsets = .init(top: 5, leading: 5, bottom: 5, trailing: 0)
        button.configuration = configuration
        return button
    }()
    
    //MARK: - Public properties
    
    var menuPublisher = PassthroughSubject<String, Never>()
    
    var searchBar: UITextField = {
        let searchString = UITextField()
        searchString.leftViewMode = .always
        let view = UIImageView(image: UIImage(systemName: "magnifyingglass"))
        view.tintColor = .lightGray
        searchString.leftView = view
        searchString.backgroundColor = .systemGray6
        searchString.layer.cornerRadius = 12
        searchString.layer.masksToBounds = true
        return searchString
    }()
    
    lazy var newsCollectionView: NewsListCollectionView = {
        let collectionView = NewsListCollectionView(frame: .zero, collectionViewLayout: createLayout())
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

private extension NewsListView {
    
    //MARK: - UI initialization functions
    
    
    func setupUI() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(searchBar)
        addSubview(sortButton)
        addSubview(newsCollectionView)
    }
    
    func setupConstraints() {
        searchBar.snp.makeConstraints { make in
            make.leading.equalToSuperview().inset(10)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(sortButton.snp.height)
        }
        sortButton.snp.makeConstraints { make in
            make.left.equalTo(searchBar.snp.right).inset(5)
            make.trailing.equalToSuperview().inset(10)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
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
    
    func updateCollection(data: [NewsGeneralModel]) {
        newsCollectionView.data = data
        newsCollectionView.reloadData()
    }
}
