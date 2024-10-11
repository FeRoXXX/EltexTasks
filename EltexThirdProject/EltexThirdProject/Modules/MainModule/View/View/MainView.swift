//
//  MainView.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import UIKit

final class MainView: UIView {
    
    private let showOperationsLabel: UILabel = {
        let label = UILabel()
        label.textColor = .white
        label.text = "0"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: 70)
        label.adjustsFontSizeToFitWidth = true
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var buttonsCollectionView: UICollectionView = {
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: createLayout())
        collectionView.register(MainCollectionViewCell.self, forCellWithReuseIdentifier: MainCollectionViewCell.identifier)
        collectionView.isScrollEnabled = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        return collectionView
    }()
    
    init(delegate: UICollectionViewDelegate, dataSource: UICollectionViewDataSource) {
        super.init(frame: .zero)
        buttonsCollectionView.delegate = delegate
        buttonsCollectionView.dataSource = dataSource
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func createLayout() -> UICollectionViewLayout {
        let layout = UICollectionViewCompositionalLayout {
            (sectionIndex: Int, layoutEnvironment: NSCollectionLayoutEnvironment) -> NSCollectionLayoutSection? in
            
            let topItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0 / 4.0), heightDimension: .fractionalHeight(1.0)))
            topItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            let topItemGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 4.0)), repeatingSubitem: topItem, count: 4)
            
            let topGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(4.0 / 5.0)), repeatingSubitem: topItemGroup, count: 4)
            
            let bottomLeadingItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0 / 2.0), heightDimension: .fractionalHeight(1.0)))
            bottomLeadingItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            let bottomTrailingItem = NSCollectionLayoutItem(layoutSize: .init(widthDimension: .fractionalWidth(1.0 / 2.0), heightDimension: .fractionalHeight(1.0)))
            bottomTrailingItem.contentInsets = .init(top: 8, leading: 8, bottom: 8, trailing: 8)
            let bottomTrailingGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0 / 2.0), heightDimension: .fractionalHeight(1.0)), repeatingSubitem: bottomTrailingItem, count: 2)
            
            let bottomGroup = NSCollectionLayoutGroup.horizontal(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0 / 5.0)), subitems: [bottomLeadingItem, bottomTrailingGroup])
            
            let nestedGroup = NSCollectionLayoutGroup.vertical(layoutSize: .init(widthDimension: .fractionalWidth(1.0), heightDimension: .fractionalHeight(1.0)), subitems: [topGroup, bottomGroup])
            let section = NSCollectionLayoutSection(group: nestedGroup)
            return section
        }
        return layout
    }
}

private extension MainView {
    
    func setupUI() {
        backgroundColor = .systemBackground
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(showOperationsLabel)
        addSubview(buttonsCollectionView)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            buttonsCollectionView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -30),
            buttonsCollectionView.trailingAnchor.constraint(equalTo: trailingAnchor),
            buttonsCollectionView.leadingAnchor.constraint(equalTo: leadingAnchor),
            buttonsCollectionView.heightAnchor.constraint(equalTo: buttonsCollectionView.widthAnchor, multiplier: 5.0 / 4.0)
        ])
        
        NSLayoutConstraint.activate([
            showOperationsLabel.bottomAnchor.constraint(equalTo: buttonsCollectionView.topAnchor, constant: 5),
            showOperationsLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 35),
            showOperationsLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -35),
            showOperationsLabel.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
}

extension MainView {
    
    func setupText(_ text: String) {
        showOperationsLabel.text = text
    }
    
    func getText() -> String? {
        showOperationsLabel.text
    }
}
