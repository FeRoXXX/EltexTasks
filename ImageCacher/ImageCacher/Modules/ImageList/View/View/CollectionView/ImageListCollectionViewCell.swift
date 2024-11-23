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
    
    private lazy var imageView: DownloadableImageView = {
        let imageView = DownloadableImageView()
        imageView.isLoading = { [weak self] in
            self?.loadingIndicator.stopAnimating()
        }
        return imageView
    }()
    
    private let loadingIndicator: UIActivityIndicatorView = {
        let activityIndicator = UIActivityIndicatorView(style: .medium)
        return activityIndicator
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
    
    //MARK: - Prepare for reuse
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.imageView.isCancelled = true
        imageView.image = nil
        imageView.cancelRequest()
        self.loadingIndicator.stopAnimating()
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
        addSubview(loadingIndicator)
    }
    
    func setupConstraints() {
        imageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
        
        loadingIndicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}

//MARK: - Public extension

extension ImageListCollectionViewCell {
    
    //MARK: - Static properties
    
    static var identifier: String {
        return String(describing: ImageListCollectionViewCell.self)
    }
    
    //MARK: - Data initialization function
    
    func setupImage(with url: URL?) {
        guard let url else { return }
        loadingIndicator.startAnimating()
        imageView.loadImage(from: url, withOptions: [.resize, .cached(.memory), .circle])
    }
}
