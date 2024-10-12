//
//  MainCollectionViewDataSource.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import UIKit

final class MainCollectionViewDataSource: NSObject, UICollectionViewDataSource {
    
    //MARK: - Public closure
    var userAction: ((String) -> Void)?
    
    //MARK: - CollectionView Data source functions
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        ActionsConstant.actionArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: MainCollectionViewCell.identifier, for: indexPath) as? MainCollectionViewCell else { return UICollectionViewCell() }
        cell.setupText(ActionsConstant.actionArray[indexPath.row])
        cell.setupStyle()
        cell.clickOnCell = { [weak self] buttonText in
            self?.userAction?(buttonText)
        }
        
        return cell
    }
}
