//
//  ImageListDataModel.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import Foundation

typealias ImageList = [ImageListDataModel]

//MARK: - ImageListDataModel

struct ImageListDataModel: Codable, Equatable {
    let id: Int
    let name: String
    let alternativeText, caption: String?
    let width, height: Int
    let formats: Formats
    let hash, ext, mime: String
    let size: Double
    let url: String
    let previewURL: String?
    let provider: String
    let providerMetadata: String?
    let createdAt, updatedAt: String

    enum CodingKeys: String, CodingKey {
        case id, name, alternativeText, caption, width, height, formats, hash, ext, mime, size, url
        case previewURL = "previewUrl"
        case provider
        case providerMetadata = "provider_metadata"
        case createdAt, updatedAt
    }
    
}

// MARK: - Formats

struct Formats: Codable, Equatable {
    let large: Large?
    let small: Large?
    let medium: Large?
    let thumbnail: Large?
}

// MARK: - Large

struct Large: Codable, Equatable {
    let ext, url, hash, mime: String
    let name: String
    let path: String?
    let size: Double
    let width, height: Int
}
