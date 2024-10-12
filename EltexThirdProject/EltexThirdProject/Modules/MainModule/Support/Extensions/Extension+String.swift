//
//  Extension+String.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 12.10.2024.
//

import Foundation

extension String {
    
    func convertToDouble() -> Double? {
        let formattedText = self.replacingOccurrences(of: ",", with: ".")
        return Double(formattedText)
    }
}
