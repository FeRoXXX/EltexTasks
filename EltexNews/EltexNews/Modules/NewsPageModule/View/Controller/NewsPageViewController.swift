//
//  NewsPageViewController.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit

final class NewsPageViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView: NewsPageView = NewsPageView()
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - Private extension

private extension NewsPageViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
}
