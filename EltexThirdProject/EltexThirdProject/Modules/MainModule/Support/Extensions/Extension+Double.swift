//
//  Extension+Double.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 12.10.2024.
//

import Foundation

extension Double {
    
    func formatNumber() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        formatter.maximumFractionDigits = 8
        formatter.minimumFractionDigits = 0
        
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
