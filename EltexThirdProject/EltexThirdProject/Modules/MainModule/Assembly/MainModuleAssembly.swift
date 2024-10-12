//
//  MainModuleAssembly.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import UIKit

final class MainModuleAssembly {
    
    //MARK: - Build module function
    static func build() -> UIViewController {
        
        let dataSource = MainCollectionViewDataSource()
        let viewModel = MainViewModel(dataSource: dataSource)
        let controller = MainViewController(dataSource: dataSource, viewModel: viewModel)
        return controller
    }
}
