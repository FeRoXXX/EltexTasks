//
//  MainViewModel.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import Foundation

final class MainViewModel {
    
    private var ui: IMainViewController?
    private let dataSource: MainCollectionViewDataSource
    
    init(dataSource: MainCollectionViewDataSource) {
        self.dataSource = dataSource
        setupDataSourceAction()
    }
}

private extension MainViewModel {
    
    func setupDataSourceAction() {
        dataSource.userAction = { [weak self] text in
            self?.showAction(text: text)
        }
    }
    
    func showAction(text: String) {
        let currentText = ui?.getText() ?? "0"
        if text != "AC",
           currentText.count >= 20{
            return
        }
        
        switch text {
        case "AC":
            ui?.setupText("0")
        case "=":
            makeAction(currentText)
        case "%":
            makePercent(currentText)
        case "+/-":
            toggleSign(currentText)
        case "+", "-", "×", "÷":
            addOperators(currentText, text)
        default:
            switch currentText {
            case "0", "+0":
                ui?.setupText(text)
            case "-0":
                ui?.setupText("-" + text)
            default:
                ui?.setupText(currentText + text)
            }
        }
    }
    
    func addOperators(_ currentText: String, _ text: String) {
        guard let lastSymbol = currentText.last else { return }
        var currentText = currentText
        
        switch lastSymbol {
        case "+", "-", "×", "÷":
            currentText.removeLast()
            ui?.setupText(currentText + text)
        default:
            ui?.setupText(currentText + text)
        }
    }
    
    func toggleSign(_ currentText: String) {
        var separatorNumber = currentText.components(separatedBy: ["+", "-", "×", "÷"])
        var separatorOperation = getOperations(currentText)
        
        if separatorOperation.isEmpty {
            ui?.setupText("-" + currentText)
            return
        }
        
        guard let number = Double(separatorOperation[separatorOperation.count - 1] + separatorNumber[separatorNumber.count - 1]) else { return }
        //TODO: - Добавить проверку на умножение и деление
        separatorOperation.removeLast()
        
        if number > 0 {
            separatorOperation.append("-")
        } else {
            separatorOperation.append("+")
        }
        
        if separatorNumber.count == 1 {
            var result = separatorOperation[0]
            for (index, element) in separatorOperation.enumerated() {
                result += element + separatorNumber[index + 1]
            }
            ui?.setupText(result)
        } else {
            var result = separatorNumber[0]
            for (index, element) in separatorOperation.enumerated() {
                result += element + separatorNumber[index + 1]
            }
            ui?.setupText(result)
        }
    }
    
    func makeAction(_ text: String) {
        var separatorNumber = text.components(separatedBy: ["+", "-", "×", "÷"])
        var separatorOperation = getOperations(text)
        
        var index = 0
        while index < separatorOperation.count {
            let operation = separatorOperation[index]
            if operation == "×" || operation == "÷" {
                
                let leftNumber = Double(separatorNumber[index]) ?? 0
                let rightNumber = Double(separatorNumber[index + 1]) ?? 0
                var result: Double = 0
                
                switch operation {
                case "×":
                    result = leftNumber * rightNumber
                case "÷":
                    result = leftNumber / rightNumber
                default:
                    break
                }
                
                separatorNumber[index] = String(result)
                separatorNumber.remove(at: index + 1)
                separatorOperation.remove(at: index)
            } else {
                index += 1
            }
        }
        
        index = 0
        var result = Double(separatorNumber[0]) ?? 0
        while index < separatorOperation.count {
            let operation = separatorOperation[index]
            let nextNumber = Double(separatorNumber[index + 1]) ?? 0
            
            switch operation {
            case "+":
                result += nextNumber
            case "-":
                result -= nextNumber
            default:
                break
            }
            
            index += 1
        }
        
        ui?.setupText(String(result))
    }
    
    func makePercent(_ text: String) {
        var separatorNumber = text.components(separatedBy: ["+", "-", "×", "÷"])
        let separatorOperations = getOperations(text)
        
        guard let percentNumberString = separatorNumber.last,
              let percentNumberDouble = Double(percentNumberString) else { return }
        
        let convertNumber = percentNumberDouble * 0.01
        
        separatorNumber[separatorNumber.count - 1] = String(convertNumber)
        
        var result = separatorNumber[0]
        for (index, element) in separatorOperations.enumerated() {
            result += element + separatorNumber[index + 1]
        }
        
        ui?.setupText(result)
    }
    
    func getOperations(_ text: String) -> [String] {
        
        var separatorOperation: [String] = []
        for element in text {
            if ["+", "-", "×", "÷", "%"].contains(element) {
                separatorOperation.append(String(element))
            }
        }
        return separatorOperation
    }
}

extension MainViewModel: IMainViewModel {
    
    func viewLoaded(ui: IMainViewController) {
        self.ui = ui
    }
}
