//
//  NewsPageViewModel.swift
//  EltexNews
//
//  Created by Александр Федоткин on 15.11.2024.
//

import Foundation

final class NewsPageViewModel {
    
    //MARK: - Private properties
    
    @Published private(set) var pageData: NavigateItem
    
    //MARK: - Initialization
    
    init(pageData: NavigateItem) {
        self.pageData = pageData
    }
}
