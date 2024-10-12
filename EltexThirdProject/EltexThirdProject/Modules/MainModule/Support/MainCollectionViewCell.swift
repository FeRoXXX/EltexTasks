//
//  MainCollectionViewCell.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    var clickOnCell: ((String) -> ())?
    private let actionName: UILabel = {
        let label = UILabel() 
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
        setupGesture()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension MainCollectionViewCell {
    
    func setupUI() {
        backgroundColor = .darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(actionName)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
            actionName.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionName.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickInCell))
        self.addGestureRecognizer(tapGesture)
    }
    
    func setCellStyle() {
        switch actionName.text! {
        case "AC", "+/-", "%":
            backgroundColor = .lightGray
            actionName.textColor = .black
        case "÷", "×", "+", "-", "=":
            backgroundColor = .systemOrange
        case "0":
            actionName.leftAnchor.constraint(equalTo: leftAnchor, constant: 35).isActive = true
            backgroundColor = .systemGray5
        default:
            backgroundColor = .systemGray5
        }
    }
    
    @objc func clickInCell() {
        clickOnCell?(actionName.text ?? "0")
    }
}

extension MainCollectionViewCell {
    
    func setupText(_ text: String) {
        actionName.text = text
    }
    
    func setupStyle() {
        setCellStyle()
    }
    
    static var identifier: String {
        return String(describing: MainCollectionViewCell.self)
    }
}
