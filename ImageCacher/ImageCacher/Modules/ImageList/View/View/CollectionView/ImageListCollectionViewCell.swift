//
//  ImageListCollectionViewCell.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 20.11.2024.
//

import UIKit
import SnapKit

final class ImageListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private properties
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: .zero)
        setupUI()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension ImageListCollectionViewCell {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(imageView)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
}

//MARK: - Public extension

extension ImageListCollectionViewCell {
    
    //MARK: - Static properties
    
    static var identifier: String {
        return String(describing: ImageListCollectionViewCell.self)
    }
}
