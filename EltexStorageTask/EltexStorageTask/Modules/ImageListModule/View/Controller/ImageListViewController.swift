//
//  ImageListViewController.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit
import Combine

final class ImageListViewController: UIViewController {
    
    //MARK: - Private properties
    
    private(set) var addImageButtonTapped: PassthroughSubject<Void, Never> = .init()
    private(set) var firstOpenPublisher: PassthroughSubject<Void, Never> = .init()
    private let contentView = ImageListView()
    private let viewModel: ImageListViewModel
    private var bindings: Set<AnyCancellable> = []
    
    //MARK: - Lifecycle functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        configureNavigationBar()
        bind()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        firstOpenPublisher.send()
    }
    
    //MARK: - Initialization
    
    init(viewModel: ImageListViewModel) {
        self.viewModel = viewModel
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

//MARK: - Private extension

private extension ImageListViewController {
    
    //MARK: - UI initialization function
    
    func setupUI() {
        self.view = contentView
    }
    
    //MARK: - Bindings
    
    func bind() {
        
        //MARK: - Bind view to viewModel
        
        func bindViewToViewModel() {
            addImageButtonTapped
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.navigate = .addImage
                }
                .store(in: &bindings)
            firstOpenPublisher
                .receive(on: DispatchQueue.main)
                .sink { [weak self] _ in
                    self?.viewModel.fetchFirstOpenData()
                }
                .store(in: &bindings)
        }
        
        //MARK: - Bind viewModel to view
        
        func bindViewModelToView() {
            
            viewModel.$data
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    guard let value else { return }
                    self?.contentView.imageListCollectionView.data = value.map { return $0.url }
                    self?.contentView.imageListCollectionView.reloadData()
                }
                .store(in: &bindings)
            
            viewModel.$navigate
                .receive(on: DispatchQueue.main)
                .sink { [weak self] value in
                    self?.navigateTo(value)
                }
                .store(in: &bindings)
        }
        
        bindViewToViewModel()
        bindViewModelToView()
    }
    
    //MARK: - Configure navigation bar
    
    func configureNavigationBar() {
        navigationItem.rightBarButtonItems = [UIBarButtonItem(title: "Добавить картинку", style: .done, target: self, action: #selector(addImageHandler))]
    }
    
    @objc func addImageHandler() {
        addImageButtonTapped.send()
    }
    
    //MARK: - Navigation
    
    func navigateTo(_ window: NavigationControllers) {
        switch window {
        case .addImage:
            navigationController?.pushViewController(ImageUploadModuleAssembly.build(), animated: true)
        case .none:
            return
        }
    }
}
