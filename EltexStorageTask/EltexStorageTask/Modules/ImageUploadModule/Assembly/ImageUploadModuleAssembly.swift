//
//  ImageUploadModuleAssembly.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 28.11.2024.
//

import UIKit

final class ImageUploadModuleAssembly {
    
    //MARK: - Build view controller function
    
    static func build() -> UIViewController {
        let viewModel = ImageUploadViewModel()
        let viewController = ImageUploadViewController(viewModel: viewModel)
        return viewController
    }
}
