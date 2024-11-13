//
//  NewsListViewController.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit

final class NewsListViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView: NewsListView = NewsListView()
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - Private extension

private extension NewsListViewController {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        self.view = contentView
    }
}
