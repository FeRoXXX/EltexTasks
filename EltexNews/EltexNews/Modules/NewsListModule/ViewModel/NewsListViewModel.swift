//
//  NewsListViewModel.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import Foundation
import Combine

final class NewsListViewModel {
    
    //MARK: - Private properties
    
    @Published private(set) var newsList: [NewsGeneralModel] = []
    private var bindings = Set<AnyCancellable>()
    
    private var sortingBy: String = ""
    private var query: String = ""
    
    func search(_ query: String) {
        self.query = query
        
        if !sortingBy.isEmpty {
            getNewsWithSorting(query: query)
        } else {
            getNewsWithoutSorting(query)
        }
    }
    
    func searchWithSorting(_ sortingBy: String) {
        self.sortingBy = sortingBy
        getNewsWithSorting(sortingBy: sortingBy)
    }
    
    func navigateTo(_ index: IndexPath) {
        print(index)
    }
}

private extension NewsListViewModel {
    
    func getNewsWithoutSorting(_ query: String) {
        
        NetworkService.getPostsWithoutSort(searchString: query)
            .fetch()
            .receive(on: DispatchQueue.global())
            .sink { _ in } receiveValue: { [weak self] model in
                print(model)
                self?.newsList = model.articles
            }
            .store(in: &bindings)
    }
    
    func getNewsWithSorting(query: String? = nil, sortingBy: String? = nil) {
        
        if let query, let sortingBy {
            NetworkService.getPostsWithSort(searchingString: query, sort: sortingBy)
                .fetch()
                .receive(on: DispatchQueue.global())
                .sink { _ in } receiveValue: { [weak self] model in
                    print(model)
                    self?.newsList = model.articles
                }
                .store(in: &bindings)
        } else if let query {
            NetworkService.getPostsWithSort(searchingString: query, sort: self.sortingBy)
                .fetch()
                .receive(on: DispatchQueue.global())
                .sink { _ in } receiveValue: { [weak self] model in
                    print(model)
                    self?.newsList = model.articles
                }
                .store(in: &bindings)
        } else if let sortingBy {
            NetworkService.getPostsWithSort(searchingString: self.query, sort: sortingBy)
                .fetch()
                .receive(on: DispatchQueue.global())
                .sink { _ in } receiveValue: { [weak self] model in
                    print(model)
                    self?.newsList = model.articles
                }
                .store(in: &bindings)
        }
    }
}
