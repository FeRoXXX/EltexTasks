//
//  Vehicle.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

class Vehicle {
    
    //MARK: - Constants features
    let make: String
    let model: String
    let year: Int
    let capacity: Int
    let types: [CargoType]?
    let tankCapacity: Int
    
    //MARK: - Variables features
    var consumption: Int
    var currentLoad: Int?
    var generalCapacity: Int
    var generalCurrentLoad: Int
    
    //MARK: - Initializer
    init(make: String, model: String, year: Int, capacity: Int, types: [CargoType]? = nil, tankCapacity: Int, consumption: Int) {
        self.make = make
        self.model = model
        self.year = year
        self.capacity = capacity
        self.types = types
        self.generalCapacity = capacity
        self.generalCurrentLoad = 0
        self.tankCapacity = tankCapacity
        self.consumption = consumption
    }
    
    //MARK: - loadCargo function
    func loadCargo(cargo: Cargo) {
        
        let loadResult = load(currentLoad, types, cargo, capacity)
        
        if loadResult.result {
            currentLoad = loadResult.newLoad
            generalCurrentLoad += cargo.weight
            print(loadResult.message)
        } else {
            print(loadResult.message)
        }
    }
    
    //MARK: - unloadCargo function
    func unloadCargo() {
        currentLoad = 0
        print("Машина разгружена")
    }
    
    //MARK: - load function
    func load(_ currentLoad: Int?, _ types: [CargoType]?, _ cargo: Cargo,_ capacity: Int?) -> (result: Bool, newLoad: Int?, message: String) {
        let capacity = capacity ?? 0
        let newLoad = (currentLoad ?? 0) + cargo.weight
        
        if let types,
           !types.contains(cargo.type) {
            return (false, currentLoad, "Машина/прицеп не может перевозить груз такого типа")
        }
        
        if newLoad > capacity {
            return (false, currentLoad, "Груз не поместился машину/прицеп, текущий вес загрузки: \(currentLoad ?? 0)")
        }
        
        return (true, newLoad, "Груз загружен")
    }
    
    //MARK: - checkWay function
    func checkWay(cargo: Cargo, path: Int) -> Bool {
        let remainingFuel = ((Double(path) / 100) * Double(consumption)) * 2
        
        if Double(tankCapacity) < remainingFuel {
            return false
        }
        
        let result = load(currentLoad, types, cargo, capacity)
        
        return result.result
    }
}
