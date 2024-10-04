//
//  CargoType.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

enum CargoType: Equatable {
    
    case fragile(sizeLength: Int, sizeWidth: Int, sizeHeight: Int)
    case perishable(temperature: Int)
    case bulk(density:Int)
}
