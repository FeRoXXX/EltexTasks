//
//  CollectionData.swift
//  EltexCustomLayoutTask
//
//  Created by Александр Федоткин on 08.11.2024.
//

import Foundation

enum Size: Float {

    case small = 0.2
    case normal = 0.4
}

enum Alignment {

    case center
    case left
    case right
}

struct CollectionData {

    let alignment: Alignment
    let elements: [[Size]]
}
