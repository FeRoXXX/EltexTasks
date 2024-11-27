//
//  Extension+UICollectionView.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit

extension UICollectionView {
    
    //MARK: - Cell registration
    
    func register<T:UICollectionViewCell>(_ type:T.Type) {
        self.register(T.self, forCellWithReuseIdentifier: T.identifier)
    }
    
    //MARK: - Cell reuse
    
    func reuse<T:UICollectionViewCell>(_ type:T.Type, for indexPath:IndexPath) -> T {
        guard let cell = self.dequeueReusableCell(withReuseIdentifier: T.identifier, for: indexPath) as? T else { fatalError() }
        return cell
    }
}
