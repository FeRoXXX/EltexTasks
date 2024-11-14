//
//  NewsCollectionViewCell.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import SnapKit

final class NewsCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Private properties
    
    private var newsImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = .remove
        return imageView
    }()
    
    private var newsTitleLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var newsDescriptionLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        return label
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

private extension NewsCollectionViewCell {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        self.layer.cornerRadius = 12
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor.black.cgColor
        self.layer.borderWidth = 1
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(newsImageView)
        addSubview(newsTitleLabel)
        addSubview(newsDescriptionLabel)
    }
    
    func setupConstraints() {
        newsImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(newsDescriptionLabel.snp.width)
        }
        
        newsTitleLabel.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        newsDescriptionLabel.snp.makeConstraints { make in
            make.top.equalTo(newsTitleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualToSuperview().inset(10)
        }
        
        newsTitleLabel.snp.contentHuggingVerticalPriority = 750
    }
}

//MARK: - Public extension

extension NewsCollectionViewCell {
    
    //MARK: - Static properties
    
    static var identifier: String {
        return String(describing: NewsCollectionViewCell.self)
    }
    
    func setupData(data: NewsGeneralModel) {
        newsTitleLabel.text = data.title
        newsDescriptionLabel.text = data.description
    }
}
