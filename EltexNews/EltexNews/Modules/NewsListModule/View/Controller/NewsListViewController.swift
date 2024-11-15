//
//  NewsListViewController.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import Combine

final class NewsListViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView: NewsListView = NewsListView()
    private var viewModel: NewsListViewModel
    private var bindings = Set<AnyCancellable>()
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
    }
    
    //MARK: - Initialization
    
    init(viewModel: NewsListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension NewsListViewController {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        view = contentView
        setupTitle()
    }
    
    func setupTitle() {
        title = "News"
    }
    
    //MARK: - Bindings
    
    func setupBindings() {
        
        func bindViewToViewModel() {
            contentView.searchBar.textPublisher
                .debounce(for: .seconds(0.3), scheduler: DispatchQueue.global())
                .removeDuplicates()
                .filter { $0.count > 2 }
                .sink { [weak viewModel] value in
                    viewModel?.search(value)
                }
                .store(in: &bindings)
            
            contentView.newsCollectionView.selectionPublisher
                .receive(on: DispatchQueue.global())
                .sink { [weak viewModel] indexPath in
                    viewModel?.navigateTo(indexPath)
                }
                .store(in: &bindings)
            
            contentView.menuPublisher
                .receive(on: DispatchQueue.global())
                .sink { [weak viewModel] value in
                    viewModel?.searchWithSorting(value)
                }
                .store(in: &bindings)
            
            contentView.newsCollectionView.scrollPublisher
                .dropFirst()
                .debounce(for: 0.3, scheduler: DispatchQueue.global())
                .sink { [weak viewModel] value in
                    viewModel?.addNewResults()
                }
                .store(in: &bindings)
        }
        
        func bindViewModelToView() {
            viewModel.$newsList
                .receive(on: DispatchQueue.main)
                .sink { [weak contentView] value in
                    contentView?.updateCollection(data: value)
                }
                .store(in: &bindings)
            viewModel.$navigateItem
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let value else { return }
                    self?.navigateToNewsPage(with: value)
                }
                .store(in: &bindings)
            viewModel.$state
                .receive(on: DispatchQueue.main)
                .sink { [weak contentView] value in
                    switch value {
                    case .finished:
                        contentView?.stopLoading()
                    case .loading:
                        contentView?.startLoading()
                    }
                }
                .store(in: &bindings)
            viewModel.$stateCollection
                .receive(on: DispatchQueue.main)
                .sink { [weak contentView] value in
                    switch value {
                    case .finished:
                        contentView?.newsCollectionView.stopLoading()
                    case .loading:
                        contentView?.newsCollectionView.startLoading()
                    }
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    //MARK: - Navigation
    
    func navigateToNewsPage(with data: NavigateItem) {
        navigationController?.pushViewController(NewsPageModuleAssembly.build(data: data), animated: true)
    }
}
