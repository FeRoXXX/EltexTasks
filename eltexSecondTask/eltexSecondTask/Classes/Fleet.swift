//
//  Fleet.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

final class Fleet {
    
    var allVehicle: [Vehicle]
    
    init(allVehicle: [Vehicle]) {
        self.allVehicle = allVehicle
    }
    
    func addVehicle(_ vehicle: Vehicle) {
        allVehicle.append(vehicle)
        print("Машина добавлена в автопарк")
    }
    
    func totalCapacity() -> Int {
        var result = 0
        allVehicle.forEach{ result += $0.generalCapacity }
        return result
    }
    
    func totalCurrentLoad() -> Int {
        var result = 0
        allVehicle.forEach { result += $0.generalCurrentLoad }
        return result
    }
    
    func info() {
        print(
                """
                Автопарк содержит \(allVehicle.count) машин
                Общая грузоподъемность \(totalCapacity())
                Текущая загруженность \(totalCurrentLoad())
                """
        )
    }
}

extension Fleet: CustomStringConvertible {
    var description: String {
        return 
                """
                Автопарк содержит \(allVehicle.count) машин
                Общая грузоподъемность \(totalCapacity())
                Текущая загруженность \(totalCurrentLoad())
                """
    }
}
