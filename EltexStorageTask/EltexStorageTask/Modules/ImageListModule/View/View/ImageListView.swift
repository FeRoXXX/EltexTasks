//
//  ImageListView.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit
import SnapKit

final class ImageListView: UIView {
    
    //MARK: - Private properties
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

//MARK: - Private extension

private extension ImageListView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        
    }
    
    func setupConstraints() {
        
    }
}
