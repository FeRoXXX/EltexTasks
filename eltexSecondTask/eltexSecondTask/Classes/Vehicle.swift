//
//  Vehicle.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

class Vehicle {
    
    let make: String
    let model: String
    let year: Int
    let capacity: Int
    let types: [CargoType]?
    var currentLoad: Int?
    var generalCapacity: Int
    var generalCurrentLoad: Int
    
    init(make: String, model: String, year: Int, capacity: Int, types: [CargoType]? = nil) {
        self.make = make
        self.model = model
        self.year = year
        self.capacity = capacity
        self.types = types
        self.generalCapacity = capacity
        self.generalCurrentLoad = 0
    }
    
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
    
    func unloadCargo() {
        if currentLoad == 0 {
            print("Машина уже пуста")
            return
        }
        
        currentLoad = 0
        print("Машина разгружена")
    }
    
    func load(_ currentLoad: Int?, _ types: [CargoType]?, _ cargo: Cargo,_ capacity: Int?) -> (result: Bool, newLoad: Int?, message: String) {
        let capacity = capacity ?? 0
        let newLoad = (currentLoad ?? 0) + cargo.weight
        
        if let types,
           !types.contains(cargo.type) {
            return (false, currentLoad, "Машина не может перевозить груз такого типа")
        }
        
        if newLoad > capacity {
            return (false, currentLoad, "Груз не поместился машину, текущий вес загрузки: \(currentLoad ?? 0)")
        }
        
        return (true, newLoad, "Груз загружен")
    }
}
