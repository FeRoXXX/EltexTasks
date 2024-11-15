//
//  NewsListModuleAssembly.swift
//  EltexNews
//
//  Created by Александр Федоткин on 15.11.2024.
//

import UIKit

final class NewsListModuleAssembly {
    
    static func build() -> UIViewController {
        
        let viewModel = NewsListViewModel()
        let viewController = NewsListViewController(viewModel: viewModel)
        return viewController
    }
}
