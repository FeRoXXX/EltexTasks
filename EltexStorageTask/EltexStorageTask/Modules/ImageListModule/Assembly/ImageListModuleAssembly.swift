//
//  ImageListModuleAssembly.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 28.11.2024.
//

import UIKit

final class ImageListModuleAssembly {
    
    //MARK: - Build view controller function
    
    static func build() -> UIViewController {
        let viewModel = ImageListViewModel()
        let controller = ImageListViewController(viewModel: viewModel)
        return controller
    }
}
