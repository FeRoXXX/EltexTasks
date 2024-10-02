//
//  main.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

let man = Truck(make: "Man", model: "1201", year: 2010, capacity: 200, trailerAttached: true, trailerCapacity: 2000)
man.loadCargo(cargo: Cargo(description: "Voilock", weight: 300, type: .perishable(temperature: 12))!)
man.loadCargo(cargo: Cargo(description: "Glass", weight: 100, type: .fragile(sizeLength: 10, sizeWidth: 10, sizeHeight: 10))!)

let honda = Vehicle(make: "Honda", model: "Accord", year: 2008, capacity: 200, types: [.fragile(sizeLength: 10, sizeWidth: 10, sizeHeight: 10)])
honda.loadCargo(cargo: Cargo(description: "Glass", weight: 100, type: .fragile(sizeLength: 10, sizeWidth: 10, sizeHeight: 10))!)
//honda.loadCargo(cargo: Cargo(description: "Glass", weight: 100, type: .bulk(density: 10))!)

let firstFleet: Fleet = Fleet(allVehicle: [honda, man])
firstFleet.info()
