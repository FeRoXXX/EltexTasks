//
//  ImageListCellDataModel.swift
//  EltexStorageTask
//
//  Created by Александр Федоткин on 27.11.2024.
//

import UIKit

struct ImageListCellDataModel: Codable {
    let image: UIImage

    enum CodingKeys: String, CodingKey {
        case image
    }

    //MARK: - Initialization
    
    init(image: UIImage) {
        self.image = image
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let imageData = try container.decode(Data.self, forKey: .image)
        guard let decodedImage = UIImage(data: imageData) else {
            throw DecodingError.dataCorrupted(
                DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Unable to decode image data.")
            )
        }
        self.image = decodedImage
    }
    
    //MARK: - Encode method
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        guard let imageData = image.pngData() else {
            throw EncodingError.invalidValue(
                image,
                EncodingError.Context(codingPath: encoder.codingPath, debugDescription: "Unable to encode image to data.")
            )
        }
        try container.encode(imageData, forKey: .image)
    }
}

