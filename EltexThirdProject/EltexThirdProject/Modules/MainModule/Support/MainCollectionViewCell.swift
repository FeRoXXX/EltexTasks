//
//  MainCollectionViewCell.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import UIKit

final class MainCollectionViewCell: UICollectionViewCell {
    
    //MARK: - Public closure
    var clickOnCell: ((String) -> ())?
    
    //MARK: - Private properties
    private let actionName: UILabel = {
        let label = UILabel() 
        label.font = UIFont.boldSystemFont(ofSize: 40)
        label.textAlignment = .left
        label.textColor = .white
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    //MARK: - Initialise
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
    
    //MARK: - Setup ui element function
    func setupUI() {
        backgroundColor = .darkGray
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        addSubviews()
        setupConstraints()
    }
    
    //MARK: - Add subview to view
    func addSubviews() {
        addSubview(actionName)
    }
    
    //MARK: - Setup constraint function
    func setupConstraints() {
        NSLayoutConstraint.activate([
            actionName.centerXAnchor.constraint(equalTo: centerXAnchor),
            actionName.centerYAnchor.constraint(equalTo: centerYAnchor)
        ])
    }
    
    //MARK: - Setup gesture recognizer function
    func setupGesture() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(clickInCell))
        self.addGestureRecognizer(tapGesture)
    }
    
    //MARK: - Setup style for cell function
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
    
    //MARK: - Objc function
    @objc func clickInCell() {
        clickOnCell?(actionName.text ?? "0")
    }
}

extension MainCollectionViewCell {
    
    //MARK: - Public functions
    func setupText(_ text: String) {
        actionName.text = text
    }
    
    func setupStyle() {
        setCellStyle()
    }
    
    //MARK: - Static functions
    static var identifier: String {
        return String(describing: MainCollectionViewCell.self)
    }
}
