//
//  NewsPageModuleAssembly.swift
//  EltexNews
//
//  Created by Александр Федоткин on 15.11.2024.
//

import UIKit

final class NewsPageModuleAssembly {
    
    static func build(data: NavigateItem) -> UIViewController {
        
        let viewModel = NewsPageViewModel(pageData: data)
        let controller = NewsPageViewController(viewModel: viewModel)
        return controller
    }
}
