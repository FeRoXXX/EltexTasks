//
//  ImageListCollectionViewCell.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit
import SnapKit

final class ImageListCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private properties
    
    private var downloadIcon: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(systemName: "square.and.arrow.down.fill")
        return imageView
    }()
    
    private var progressDownloadingView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.isHidden = false
        progressView.progress = 0.2
        return progressView
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

private extension ImageListCollectionViewCell {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(downloadIcon)
        addSubview(progressDownloadingView)
    }
    
    func setupConstraints() {
        downloadIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        progressDownloadingView.snp.makeConstraints { make in
            make.top.equalTo(downloadIcon.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
    }
}
