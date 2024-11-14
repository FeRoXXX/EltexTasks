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
    private var viewModel: NewsListViewModel = NewsListViewModel()
    private var bindings = Set<AnyCancellable>()
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupBindings()
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
        }
        
        func bindViewModelToView() {
            viewModel.$newsList
                .receive(on: DispatchQueue.main)
                .sink { [weak contentView] value in
                    contentView?.updateCollection(data: value)
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
}
