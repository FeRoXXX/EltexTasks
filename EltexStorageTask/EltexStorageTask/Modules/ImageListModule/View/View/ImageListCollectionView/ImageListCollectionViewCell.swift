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
    
    private var progressDownloadingPercentLabel: UILabel = {
        let label = UILabel()
        label.isHidden = true
        return label
    }()
    
    private var progressDownloadingView: UIProgressView = {
        let progressView = UIProgressView()
        progressView.isHidden = true
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
    
    //MARK: - Prepare function
    
    override func prepareForReuse() {
        super.prepareForReuse()
        downloadedImageView.image = nil
        downloadIcon.isHidden = false
        progressDownloadingView.isHidden = false
        deleteGesture()
        addGesture()
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
        addSubview(progressDownloadingPercentLabel)
        addSubview(downloadedImageView)
    }
    
    func setupConstraints() {
        downloadIcon.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(60)
            make.width.equalTo(60)
        }
        
        progressDownloadingPercentLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        progressDownloadingView.snp.makeConstraints { make in
            make.top.equalTo(progressDownloadingPercentLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        downloadedImageView.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    //MARK: - Setup gesture recognizer
    
    func addGesture() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(loadImage))
        self.addGestureRecognizer(gesture)
    }
    
    //MARK: - Delete gesture
    func deleteGesture() {
        self.gestureRecognizers?.removeAll()
    }
    
    @objc func loadImage() {
        downloadIcon.isHidden = true
        progressDownloadingView.isHidden = false
        progressDownloadingPercentLabel.isHidden = false
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
                self?.downloadedImageView.alpha = 0
                self?.downloadedImageView.image = data.image
                self?.downloadedImageView.isHidden = false
                UIView.animate(withDuration: 0.5) {
                    self?.progressDownloadingView.alpha = 0
                    self?.progressDownloadingPercentLabel.alpha = 0
                    self?.downloadedImageView.alpha = 1.0
                } completion: { _ in
                    self?.progressDownloadingView.isHidden = true
                    self?.downloadIcon.isHidden = true
                }
            }
            .store(in: &bindings)
        
        data.$progress
            .receive(on: DispatchQueue.main)
            .sink { [weak self] value in
                UIView.animate(withDuration: 0.5) {
                    self?.progressDownloadingPercentLabel.text = "\(Int(value * 100))%"
                    self?.progressDownloadingView.setProgress(Float(value), animated: true)
                }
            }
            .store(in: &bindings)
    }
}
