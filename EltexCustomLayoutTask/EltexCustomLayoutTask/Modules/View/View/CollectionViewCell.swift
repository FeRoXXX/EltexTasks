//
//  CollectionViewCell.swift
//  EltexCustomLayoutTask
//
//  Created by Александр Федоткин on 08.11.2024.
//

import UIKit

final class CollectionViewCell: UICollectionViewCell {
    
    //MARK: - private properties
    
    private var label: UILabel = {
        let label = UILabel()
        label.text = "tags"
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
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

private extension CollectionViewCell {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = .white
        layer.cornerRadius = frame.height / 2
        layer.borderWidth = 2
        layer.borderColor = UIColor.blue.cgColor
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(label)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            label.topAnchor.constraint(equalTo: topAnchor),
            label.bottomAnchor.constraint(equalTo: bottomAnchor),
            label.leadingAnchor.constraint(equalTo: leadingAnchor),
            label.trailingAnchor.constraint(equalTo: trailingAnchor)
        ])
    }
}

//MARK: - Public extension

extension CollectionViewCell {
    
    //MARK: - Static properties
    
    static var identifier: String {
        return String(describing: CollectionViewCell.self)
    }
}
