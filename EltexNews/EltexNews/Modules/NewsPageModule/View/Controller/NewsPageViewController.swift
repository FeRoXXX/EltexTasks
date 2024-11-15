//
//  NewsPageViewController.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import Combine

final class NewsPageViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView: NewsPageView = NewsPageView()
    private var bindings = Set<AnyCancellable>()
    private var viewModel: NewsPageViewModel
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBinding()
    }
    
    //MARK: - Initialization
    
    init(viewModel: NewsPageViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension NewsPageViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bindings
    
    func setupBinding() {
        
        func bindViewModelToView() {
            viewModel.$pageData
                .receive(on: DispatchQueue.main)
                .sink { [weak contentView] value in
                    contentView?.setupData(value)
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
    }
}
