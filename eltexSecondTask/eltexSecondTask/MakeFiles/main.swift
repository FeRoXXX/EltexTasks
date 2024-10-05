//
//  main.swift
//  eltexSecondTask
//
//  Created by Александр Федоткин on 02.10.2024.
//

import Foundation

//MARK: - Создаем 2 машины и 3 грузовика
let toyotaCorona = Vehicle(make: "Toyota",
                           model: "Corona Premio",
                           year: 1996,
                           capacity: 400,
                           tankCapacity: 60,
                           consumption: 8)

let hondaCivic = Vehicle(make: "Honda",
                         model: "Civic Ferio",
                         year: 2001,
                         capacity: 400,
                         types: [.perishable(temperature: 30)],
                         tankCapacity: 60,
                         consumption: 5)

let man = Truck(make: "Man",
                model: "1312",
                year: 2010,
                capacity: 600,
                trailerAttached: true,
                trailerCapacity: 2000,
                tankCapacity: 150,
                consumption: 20)

let mercedes = Truck(make: "Mercedes",
                     model: "Heavy",
                     year: 2008,
                     capacity: 700,
                     trailerAttached: false,
                     trailerCapacity: 0,
                     tankCapacity: 160,
                     consumption: 15)

let volvo = Truck(make: "Volvo",
                  model: "MS-100",
                  year: 2015,
                  capacity: 600,
                  types: [.bulk(density: 100)],
                  trailerAttached: true,
                  trailerCapacity: 3000,
                  trailerTypes: [.perishable(temperature: 21)],
                  tankCapacity: 300,
                  consumption: 30)

//MARK: - Cоздаем автопарк с заданными машинами
let firstFleet = Fleet(allVehicle: [toyotaCorona, hondaCivic, man, mercedes, volvo])
firstFleet.info()

let cargoFirst = Cargo(description: "Glass", weight: 100, type: .fragile(sizeLength: 10, sizeWidth: 10, sizeHeight: 10))
//MARK: - Проверка на загрузку в машину
if let cargoFirst {
    toyotaCorona.loadCargo(cargo: cargoFirst)
}
//MARK: - Проверка на загрузку в машину груза с неправильным типом
if let cargoFirst {
    hondaCivic.loadCargo(cargo: cargoFirst)
}

let cargoSecond = Cargo(description: "Sand", weight: 300, type: .bulk(density: 100))
//MARK: - Проверка на загрузку в машину с правильным типом
if let cargoSecond {
    volvo.loadCargo(cargo: cargoSecond)
}

let cargoThird = Cargo(description: "Sand", weight: 400, type: .perishable(temperature: 21))
//MARK: - Проверка на загрузку в прицеп
if let cargoThird {
    volvo.loadCargo(cargo: cargoThird)
}

firstFleet.info() // Часть 1
//MARK: - Проверяем можем ли мы доехать с правильными условиями
if let cargoFirst,
   let cargoSecond,
   let cargoThird {
    print(firstFleet.canGo(cargo: [cargoFirst, cargoSecond, cargoThird], path: 100))
}
//MARK: - Т.к функция не является функцией загрузки, а просто проверки, она не должна загружать машины во время проверки
firstFleet.info()

//MARK: - Проверка неправильных условий
if let cargoFirst,
   let cargoSecond,
   let cargoThird {
    print(firstFleet.canGo(cargo: [cargoFirst, cargoSecond, cargoThird], path: 1000))
}

firstFleet.info()
