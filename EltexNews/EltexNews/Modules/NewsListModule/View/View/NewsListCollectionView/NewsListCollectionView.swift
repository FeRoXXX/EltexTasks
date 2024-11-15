//
//  NewsListCollectionView.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import SnapKit
import Combine

final class NewsListCollectionView: UICollectionView {
    
    //MARK: - Private properties
    
    private(set) var scrollPublisher: PassthroughSubject<Void, Never> = .init()
    private(set) var selectionPublisher: PassthroughSubject<IndexPath, Never> = .init()
    
    //MARK: - Public properties
    
    var data: [NewsGeneralModel] = []
    
    //MARK: - Initialization
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        register(NewsCollectionViewCell.self, forCellWithReuseIdentifier: NewsCollectionViewCell.identifier)
        register(BottomRefreshControl.self, forCellWithReuseIdentifier: BottomRefreshControl.identifier)
        self.dataSource = self
        self.delegate = self
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - UICollectionViewDelegate & UICollectionViewDataSource

extension NewsListCollectionView: UICollectionViewDataSource, UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if data.count != 0 {
            return data.count + 1
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if indexPath.row < data.count {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewsCollectionViewCell.identifier, for: indexPath) as? NewsCollectionViewCell else {
                return UICollectionViewCell()
            }
            cell.setupData(data: data[indexPath.row])
            return cell
        } else {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: BottomRefreshControl.identifier, for: indexPath) as? BottomRefreshControl else {
                return UICollectionViewCell()
            }
            return cell
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offsetY = scrollView.contentOffset.y
        let contentHeight = scrollView.contentSize.height
        let frameHeight = scrollView.frame.height
        
        if offsetY > contentHeight - frameHeight - 100 {
            scrollPublisher.send()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard indexPath.row < data.count else { return }
        selectionPublisher.send(indexPath)
    }
}

//MARK: - Public extension

extension NewsListCollectionView {
    
    //MARK: - Loading indicator functions
    
    func startLoading() {
        if let bottomCell = self.cellForItem(at: IndexPath(item: data.count, section: 0)) as? BottomRefreshControl {
            bottomCell.startLoading()
        }
    }
    
    func stopLoading() {
        if let bottomCell = self.cellForItem(at: IndexPath(item: data.count, section: 0)) as? BottomRefreshControl {
            bottomCell.stopLoading()
        }
    }
}
