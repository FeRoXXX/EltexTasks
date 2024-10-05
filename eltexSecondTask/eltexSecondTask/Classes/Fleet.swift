//
//  Fleet.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

final class Fleet {
    
    //MARK: - Private features
    private var allVehicle: [Vehicle]
    
    //MARK: - Initializer
    init(allVehicle: [Vehicle]) {
        self.allVehicle = allVehicle
    }
    
    //MARK: - addVehicle function
    func addVehicle(_ vehicle: Vehicle) {
        allVehicle.append(vehicle)
        print("Машина добавлена в автопарк")
    }
    
    //MARK: - totalCapacity function
    func totalCapacity() -> Int {
        var result = 0
        allVehicle.forEach{ result += $0.generalCapacity }
        return result
    }
    
    //MARK: - totalCurrentLoad function
    func totalCurrentLoad() -> Int {
        var result = 0
        allVehicle.forEach { result += $0.generalCurrentLoad }
        return result
    }
    
    //MARK: - canGo function
    func canGo(cargo: [Cargo], path: Int) -> Bool {
        var remainingCargo = cargo
                
        for vehicle in allVehicle {
            var vehicleCurrentLoad = vehicle.generalCurrentLoad
            
            remainingCargo = remainingCargo.filter { item in
                let potentialNewLoad = vehicleCurrentLoad + item.weight
                
                if potentialNewLoad <= vehicle.generalCapacity,
                   vehicle.checkWay(cargo: item, path: path) {
                    vehicleCurrentLoad = potentialNewLoad
                    return false
                } else {
                    print("\(vehicle.make) \(vehicle.model) не может перевезти груз \(item.type) весом \(item.weight) кг.")
                    return true
                }
            }
        }
        
        if remainingCargo.isEmpty {
            print("Все грузы могут быть перевезены на указанное расстояние.")
            return true
        } else {
            print("Не удалось перевезти все грузы.")
            return false
        }
    }
    
    //MARK: - info function
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
