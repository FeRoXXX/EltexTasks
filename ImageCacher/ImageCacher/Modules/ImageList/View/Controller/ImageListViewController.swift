//
//  ImageListViewController.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 20.11.2024.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    //MARK: - Private property
    
    private lazy var contentView = ImageListView(viewModel: viewModel)
    private let viewModel: ImageListViewModel
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    //MARK: - Initialization
    
    init(viewModel: ImageListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension ImageListViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
}
