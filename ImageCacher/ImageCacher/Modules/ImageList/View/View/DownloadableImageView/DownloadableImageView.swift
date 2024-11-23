//
//  DownloadableImageView.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 21.11.2024.
//

import UIKit

final class DownloadableImageView: UIImageView, Downloadable {
    
    //MARK: - Private properties
    
    private var isCancelledProperty: Bool = false
    private let queue = DispatchQueue(label: "com.alexandrfedotkin.queue", attributes: .concurrent)
    
    //MARK: - Public properties
    
    var isLoading: (() -> Void)?
    var id: UUID = UUID()
    var isCancelled: Bool {
        get {
            queue.sync {
                return isCancelledProperty
            }
        }
        set {
            queue.sync {
                isCancelledProperty = newValue
            }
        }
    }
    
    //MARK: - Cancel request function
    
    func cancelRequest() {
        NetworkService.cancelRequest(id: id)
    }
}
