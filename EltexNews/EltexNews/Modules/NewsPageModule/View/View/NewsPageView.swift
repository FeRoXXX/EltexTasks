//
//  NewsPageView.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import UIKit
import UIKit
import SnapKit

final class NewsPageView: UIView {
    
    //MARK: - Private properties
    
    private var newsImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private lazy var dateAndAuthorStack: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [authorLabel, dateLabel])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .center
        return stackView
    }()
    
    private var dateLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var authorLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    private var newsTextLabel: UILabel = {
        let label = UILabel()
        return label
    }()
    
    //MARK: - Public properties
    
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

private extension NewsPageView {
    
    //MARK: - UI initialization functions
    
    
    func setupUI() {
        backgroundColor = .white
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(newsImageView)
        addSubview(dateAndAuthorStack)
        addSubview(newsTextLabel)
    }
    
    func setupConstraints() {
        newsImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview().inset(10)
            make.height.equalTo(200)
        }
        
        dateAndAuthorStack.snp.makeConstraints { make in
            make.top.equalTo(newsImageView.snp.bottom).inset(10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        newsTextLabel.snp.makeConstraints { make in
            make.bottom.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(dateAndAuthorStack.snp.bottom).inset(10)
        }
    }
}

//MARK: - Public extension

extension NewsPageView {
    
}
