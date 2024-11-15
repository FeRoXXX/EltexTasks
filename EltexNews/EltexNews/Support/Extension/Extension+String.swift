//
//  Extension+String.swift
//  EltexNews
//
//  Created by Александр Федоткин on 15.11.2024.
//

import Foundation

extension String {
    
    func formatISODate() -> String {
        let inputDateFormatter = ISO8601DateFormatter()
        let outputDateFormatter = DateFormatter()
        
        outputDateFormatter.dateFormat = "d MMMM yyyy"
        outputDateFormatter.locale = Locale(identifier: "ru_RU")
        
        if let date = inputDateFormatter.date(from: self) {
            return outputDateFormatter.string(from: date)
        } else {
            return "Некорректная дата"
        }
    }
}
