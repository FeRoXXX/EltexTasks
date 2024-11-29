//
//  ImageUploadViewController.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 28.11.2024.
//

import UIKit
import Combine
import PhotosUI

final class ImageUploadViewController: UIViewController {
    
    //MARK: - Private properties
    
    private var contentView = ImageUploadView()
    private var viewModel: ImageUploadViewModel
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Public properties
    
    @Published var uploadImagePublisher: UIImage? = nil
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        bind()
    }
    
    //MARK: - Initialization
    
    init(viewModel: ImageUploadViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension ImageUploadViewController {
    
    //MARK: - UI initialization functions
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bindings
    
    func bind() {
        
        //MARK: - Bind view to viewModel
        
        func bindViewToViewModel() {
            contentView.openPickerPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.onUploadFromGallery()
                }
                .store(in: &bindings)
            
            $uploadImagePublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let value else { return }
                    self?.contentView.setImage(value)
                }
                .store(in: &bindings)
            contentView.$uploadImageFromURL
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let value else { return }
                    self?.viewModel.getImageFromURL(value)
                }
                .store(in: &bindings)
        }
        
        //MARK: - Bind viewModel to view
        
        func bindViewModelToView() {
            viewModel.uploadFromGalleryPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.configureImagePicker()
                }
                .store(in: &bindings)
            
            viewModel.$image
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let value else { return }
                    self?.contentView.setImage(value.image)
                }
                .store(in: &bindings)
        }
        
        bindViewModelToView()
        bindViewToViewModel()
    }
    
    //MARK: - Configure image picker
    
    func configureImagePicker() {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            if status == .authorized {
                DispatchQueue.main.async {
                    var configuration = PHPickerConfiguration()
                    configuration.selectionLimit = 1
                    configuration.filter = .images
                    let controller = PHPickerViewController(configuration: configuration)
                    controller.delegate = self
                    self?.present(controller, animated: true)
                }
            } else {
                return
            }
        }
    }
}

//MARK: - PHPickerDelegate

extension ImageUploadViewController: PHPickerViewControllerDelegate {
    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        
        picker.dismiss(animated: true)
        if let result = results.first?.itemProvider {
            if result.canLoadObject(ofClass: UIImage.self) {
                result.loadObject(ofClass: UIImage.self) { [weak self] image, error in
                    if let image = image as? UIImage{
                        self?.uploadImagePublisher = image
                    }
                }
            }
        }
    }
}
