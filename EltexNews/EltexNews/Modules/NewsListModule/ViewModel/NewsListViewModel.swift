//
//  NewsListViewModel.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import Foundation
import Combine

enum NewsListRequestState {
    case loading
    case finished
}

final class NewsListViewModel {
    
    //MARK: - Private properties
    
    @Published private(set) var newsList: [NewsGeneralModel] = []
    @Published private(set) var navigateItem: NavigateItem? = nil
    @Published private(set) var state: NewsListRequestState = .finished
    @Published private(set) var stateCollection: NewsListRequestState = .finished
    private var bindings = Set<AnyCancellable>()
    
    private var sortingBy: String = ""
    private var query: String = ""
    private var model: NewsListGeneralModel?
    private var currentPage: Int = 1
}

//MARK: - Private extension

private extension NewsListViewModel {
    
    func getNewsWithoutSorting(_ query: String? = nil) {
        
        NetworkService.getPostsWithoutSort(searchString: query ?? self.query, pageNumber: currentPage)
            .fetch()
            .receive(on: DispatchQueue.global())
            .sink { _ in } receiveValue: { [weak self] model in
                self?.state = .finished
                self?.stateCollection = .finished
                model.articles.forEach { self?.newsList.append($0) }
            }
            .store(in: &bindings)
    }
    
    func getNewsWithSorting(query: String? = nil, sortingBy: String? = nil) {
        
        NetworkService.getPostsWithSort(searchingString: query ?? self.query, pageNumber: self.currentPage, sort: sortingBy ?? self.sortingBy)
            .fetch()
            .receive(on: DispatchQueue.global())
            .sink { _ in } receiveValue: { [weak self] model in
                self?.state = .finished
                self?.stateCollection = .finished
                model.articles.forEach { self?.newsList.append($0) }
            }
            .store(in: &bindings)
    }
}

//MARK: - Public extension

extension NewsListViewModel {
    
    //MARK: - Search functions
    
    func search(_ query: String) {
        self.query = query
        self.currentPage = 1
        newsList.removeAll()
        
        state = .loading
        if !sortingBy.isEmpty {
            getNewsWithSorting(query: query)
        } else {
            getNewsWithoutSorting(query)
        }
    }
    
    func searchWithSorting(_ sortingBy: String) {
        self.sortingBy = sortingBy
        newsList.removeAll()
        self.currentPage = 1
        state = .loading
        getNewsWithSorting(sortingBy: sortingBy)
    }
    
    //MARK: - Navigate function
    
    func navigateTo(_ index: IndexPath) {
        let itemAtIndex = newsList[index.row]
        navigateItem = NavigateItem(title: itemAtIndex.title, content: itemAtIndex.content, date: itemAtIndex.publishedAt.formatISODate(), author: itemAtIndex.author)
    }
    
    //MARK: - Data initialize function
    
    func addNewResults() {
        currentPage += 1
        stateCollection = .loading
        if sortingBy.isEmpty {
            getNewsWithoutSorting()
        } else {
            getNewsWithSorting()
        }
    }
}
