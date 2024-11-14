//
//  NewsGeneralModel.swift
//  EltexNews
//
//  Created by Александр Федоткин on 13.11.2024.
//

import Foundation

struct NewsListGeneralModel: Codable {
    
    let status: String
    let totalResults: Int
    let articles: [NewsGeneralModel]
}

struct NewsGeneralModel: Codable {
    
    let source: Source
    let author: String?
    let title, description: String
    let url: String
    let urlToImage: String?
    let publishedAt: String
    let content: String
}

struct Source: Codable {
    let id: String?
    let name: String
}
