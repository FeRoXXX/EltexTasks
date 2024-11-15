//
//  BottomRefreshControl.swift
//  EltexNews
//
//  Created by Александр Федоткин on 15.11.2024.
//

import UIKit
import SnapKit

final class BottomRefreshControl: UICollectionViewCell {
    
    //MARK: - Private properties
    
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        activityIndicator.color = .black
        activityIndicator.hidesWhenStopped = true
        return activityIndicator
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension BottomRefreshControl {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(activityIndicator)
    }
    
    func setupConstraints() {
        activityIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

//MARK: - Public extension

extension BottomRefreshControl {
    
    //MARK: - Static properties
    
    static var identifier: String {
        return String(describing: BottomRefreshControl.self)
    }
    
    //MARK: - Setup data function
    
    func startLoading() {
        activityIndicator.startAnimating()
    }
    
    func stopLoading() {
        activityIndicator.stopAnimating()
    }
}
