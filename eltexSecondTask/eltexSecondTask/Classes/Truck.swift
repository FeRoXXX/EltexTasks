//
//  Truck.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

final class Truck: Vehicle {
    
    //MARK: - Variables features
    var trailerAttached: Bool
    var trailerCapacity: Int?
    var trailerTypes: [CargoType]?
    var trailerCurrentLoad: Int?
    
    //MARK: - Initializer
    init(make: String, model: String, year: Int, capacity: Int, types: [CargoType]? = nil, trailerAttached: Bool, trailerCapacity: Int?, trailerTypes: [CargoType]? = nil, tankCapacity: Int, consumption: Int) {
        self.trailerAttached = trailerAttached
        if trailerAttached {
            self.trailerCapacity = trailerCapacity
        } else {
            self.trailerCapacity = nil
            print("Грузоподъемность трейлера не может существовать без трейлера")
        }
        self.trailerTypes = trailerTypes
        super.init(make: make, model: model, year: year, capacity: capacity, types: types, tankCapacity: tankCapacity, consumption: consumption)
        self.generalCapacity += self.trailerCapacity ?? 0
        print("Грузовик создан")
    }
    
    //MARK: - loadCargo function
    override func loadCargo(cargo: Cargo) {
        let currentLoad = currentLoad ?? 0
        super.loadCargo(cargo: cargo)
        
        if trailerAttached,
           self.currentLoad ?? 0 == currentLoad {
            let loadResult = load(trailerCurrentLoad, trailerTypes, cargo, trailerCapacity)
            if loadResult.result {
                trailerCurrentLoad = loadResult.newLoad
                generalCurrentLoad += cargo.weight
                print("Груз загружен в трейлер")
            } else {
                print(loadResult.message)
            }
        }
    }
    
    //MARK: - checkWay function
    override func checkWay(cargo: Cargo, path: Int) -> Bool {
        let canCurry = super.checkWay(cargo: cargo, path: path)
        
        if !canCurry,
           trailerAttached {
            let remainingFuel = ((Double(path) / 100) * Double(consumption)) * 2
            
            if Double(tankCapacity) >= remainingFuel {
                let result = load(trailerCurrentLoad, trailerTypes, cargo, trailerCapacity)
                return result.result
            }
        }
        
        return canCurry
    }
}
