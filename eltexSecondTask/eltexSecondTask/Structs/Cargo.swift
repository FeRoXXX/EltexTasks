//
//  Cargo.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

struct Cargo {
    
    //MARK: - Constants features
    let description: String
    let weight: Int
    let type: CargoType
    
    //MARK: - Initializer
    init?(description: String, weight: Int, type: CargoType) {
        guard weight >= 0 else {
            return nil
        }
        self.description = description
        self.weight = weight
        self.type = type
    }
}
