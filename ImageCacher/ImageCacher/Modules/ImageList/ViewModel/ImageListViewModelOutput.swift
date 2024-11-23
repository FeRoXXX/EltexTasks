//
//  ImageListViewModelOutput.swift
//  ImageCacher
//
//  Created by Александр Федоткин on 23.11.2024.
//

import Foundation

protocol ImageListViewModelOutput {
    var dataIsLoading: (() -> Void)? { get set }
}
