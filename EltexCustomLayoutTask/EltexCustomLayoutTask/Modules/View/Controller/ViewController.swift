//
//  ViewController.swift
//  EltexCustomLayoutTask
//
//  Created by Александр Федоткин on 08.11.2024.
//

import UIKit

class ViewController: UIViewController {
    
    //MARK: - Private properties
    
    private lazy var contentView: View = View(data: data)
    private var data: CollectionData = .init(alignment: .right, elements: [[.small, .small, .normal, .small], [.normal, .small, .normal], [.small, .normal, .small], [.small, .normal],[.small, .small, .small, .small], [.normal], [.small]])

    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
}

//MARK: - Private extension

private extension ViewController {
    
    func setupUI() {
        self.view = contentView
    }
}
