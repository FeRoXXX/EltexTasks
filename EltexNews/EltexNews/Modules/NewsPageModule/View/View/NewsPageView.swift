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
    
    private var titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = .boldSystemFont(ofSize: 18)
        return label
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
        label.numberOfLines = 0
        return label
    }()
    
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
        addSubview(titleLabel)
        addSubview(dateAndAuthorStack)
        addSubview(newsTextLabel)
    }
    
    func setupConstraints() {
        titleLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.top.equalTo(safeAreaLayoutGuide.snp.top).inset(10)
        }
        
        dateAndAuthorStack.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(-10)
            make.leading.trailing.equalToSuperview().inset(10)
        }
        
        newsTextLabel.snp.makeConstraints { make in
            make.leading.trailing.equalToSuperview().inset(10)
            make.bottom.lessThanOrEqualTo(safeAreaLayoutGuide.snp.bottom).inset(-10)
            make.top.equalTo(dateAndAuthorStack.snp.bottom).inset(-10)
        }
        
        newsTextLabel.snp.contentCompressionResistanceVerticalPriority = 780
    }
}

//MARK: - Public extension

extension NewsPageView {
    
    func setupData(_ data: NavigateItem) {
        titleLabel.text = data.title
        authorLabel.text = data.author
        dateLabel.text = data.date
        newsTextLabel.text = data.content
    }
}
