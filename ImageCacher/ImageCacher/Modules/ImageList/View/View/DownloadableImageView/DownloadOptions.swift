//
//  DownloadOptions.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 21.11.2024.
//

import Foundation

enum DownloadOptions {
    
    //MARK: - Cache method enum
    
    enum From {
        case disk
        case memory
    }
    
    //MARK: - Download options
    
    case circle
    case cached(From)
    case resize
}
