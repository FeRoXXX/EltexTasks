//
//  MainViewController.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import UIKit

final class MainViewController: UIViewController {
    
    private var contentView: MainView?
    private let viewModel: IMainViewModel
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        viewModel.viewLoaded(ui: self)
    }
    
    init(dataSource: MainCollectionViewDataSource, viewModel: IMainViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
        self.contentView = MainView(delegate: self, dataSource: dataSource)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainViewController {
    
    func setupUI() {
        self.view = contentView
    }
}

extension MainViewController: IMainViewController {
    
    func setupText(_ text: String) {
        contentView?.setupText(text)
    }
    
    func getText() -> String? {
        contentView?.getText()
    }
}
