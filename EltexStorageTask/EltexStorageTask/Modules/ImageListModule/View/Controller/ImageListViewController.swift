//
//  ImageListViewController.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit

final class ImageListViewController: UIViewController {
    
    //MARK: - Private properties
    
    private let contentView = ImageListView()
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    //MARK: - Initialization
    
    init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

extension ImageListViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bindings
    
    func bind() {
        
        //MARK: - Bind view to viewModel
        
        func bindViewToViewModel() {
            
        }
        
        //MARK: - Bind viewModel to view
        
        func bindViewModelToView() {
            
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
}
