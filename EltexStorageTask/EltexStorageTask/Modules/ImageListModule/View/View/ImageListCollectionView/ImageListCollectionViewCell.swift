//
//  ImageListCollectionViewCell.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit
import SnapKit
import Combine

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
    
    private var downloadedImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.isHidden = true
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var bindings: [AnyCancellable] = []
    private(set) var tapPublisher: PassthroughSubject<Void, Never> = .init()
    
    //MARK: - Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        addGesture()
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
        addSubview(downloadedImageView)
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
        
        downloadedImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        self.addGestureRecognizer(gesture)
    }
    
    @objc func loadImage() {
        tapPublisher.send()
    }
}

//MARK: - Public extension

extension ImageListCollectionViewCell {
    
    //MARK: - Configure cell function
    
    func configureCell(with data: ImageListCollectionViewModel) {
        
        data.$currentCellImage
            .receive(on: DispatchQueue.main)
            .sink { [weak self] data in
                guard let data else { return }
                self?.progressDownloadingView.isHidden = true
                self?.downloadIcon.isHidden = true
                self?.downloadedImageView.isHidden = false
                self?.downloadedImageView.image = data.image
            }
            .store(in: &bindings)
    }
}
