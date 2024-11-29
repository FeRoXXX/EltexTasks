//
//  ImageUploadView.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 28.11.2024.
//

import UIKit
import SnapKit
import Combine

final class ImageUploadView: UIView {
    
    //MARK: - Private properties
    
    private(set) var openPickerPublisher: PassthroughSubject<Void, Never> = .init()
    
    private var previewImageView: UIImageView = {
        let imageView = UIImageView()
        return imageView
    }()
    
    private var spinLoader: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .medium)
        activityIndicatorView.color = .systemBlue
        activityIndicatorView.isHidden = true
        return activityIndicatorView
    }()
    
    private var urlTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Введите URL"
        return textField
    }()
    
    private lazy var verticalStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [uploadURLButton, uploadGalleryButton, sendToServerButton])
        stackView.axis = .vertical
        stackView.spacing = 16
        return stackView
    }()
    
    private(set) lazy var uploadURLButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Загрузить по ссылке"
        configuration.background.backgroundColor = .systemBlue
        configuration.background.cornerRadius = 12
        button.configuration = configuration
        button.addTarget(self, action: #selector(uploadFromURL), for: .touchUpInside)
        return button
    }()
    
    private lazy var uploadGalleryButton: UIButton = {
        let button = UIButton()
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Загрузить из галлереи"
        configuration.background.backgroundColor = .systemBlue
        configuration.background.cornerRadius = 12
        button.configuration = configuration
        button.addTarget(self, action: #selector(uploadFromGallery), for: .touchUpInside)
        return button
    }()
    
    private var sendToServerButton: UIButton = {
        let button = UIButton()
        button.isEnabled = false
        var configuration = UIButton.Configuration.filled()
        configuration.title = "Отправить"
        configuration.background.backgroundColor = .systemBlue
        configuration.background.cornerRadius = 12
        button.configuration = configuration
        return button
    }()
    
    //MARK: - Public properties
    
    @Published var uploadImageFromURL: String?
    
    //MARK: - Initialization
    
    init() {
        super.init(frame: .zero)
        setupUI()
        setupGestureRecognizer()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension ImageUploadView {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        backgroundColor = UIColor.white
        addSubviews()
        setupConstraints()
    }
    
    func addSubviews() {
        addSubview(previewImageView)
        addSubview(spinLoader)
        addSubview(urlTextField)
        addSubview(verticalStackView)
    }
    
    func setupConstraints() {
        previewImageView.snp.makeConstraints { make in
            make.top.leading.trailing.equalToSuperview()
            make.height.equalTo(400)
        }
        
        spinLoader.snp.makeConstraints { make in
            make.center.equalTo(previewImageView.snp.center)
        }
        
        urlTextField.snp.makeConstraints { make in
            make.top.equalTo(previewImageView.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
        }
        
        verticalStackView.snp.makeConstraints { make in
            make.top.equalTo(urlTextField.snp.bottom).inset(-20)
            make.leading.trailing.equalToSuperview().inset(40)
            make.bottom.lessThanOrEqualToSuperview().inset(20)
        }
    }
    
    //MARK: - Tap gesture recognizer
    
    func setupGestureRecognizer() {
        let gestureRecognize = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        addGestureRecognizer(gestureRecognize)
    }
    
    //MARK: - Gesture action
    
    @objc func dismissKeyboard() {
        endEditing(true)
    }
    
    //MARK: - Buttons actions
    
    @objc func uploadFromGallery() {
        openPickerPublisher.send()
    }
    
    @objc func uploadFromURL() {
        uploadImageFromURL = urlTextField.text
    }
}

//MARK: - Public extensions

extension ImageUploadView {
    
    //MARK: - Setup image to imageView function
    
    func setImage(_ image: UIImage) {
        previewImageView.image = image
        sendToServerButton.isEnabled = true
    }
    
    //MARK: - Start loading animation
    
    func startLoading() {
        spinLoader.isHidden = false
        spinLoader.startAnimating()
    }
    
    //MARK: - Stop loading animation
    
    func stopLoading() {
        spinLoader.stopAnimating()
        spinLoader.isHidden = true
    }
}
