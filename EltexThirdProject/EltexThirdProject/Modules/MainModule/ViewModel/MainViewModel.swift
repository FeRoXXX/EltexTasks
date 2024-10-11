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
        default:
            if currentText != "0" {
                ui?.setupText(currentText + text)
            } else {
                ui?.setupText(text)
            }
        }
    }
    
    func makeAction(_ text: String) {
        var separatorNumber = text.components(separatedBy: ["+", "-", "*", "×", "÷", "%"])
        var separatorOperation: [String] = []
            
        for element in text {
            if ["+", "-", "×", "÷", "%"].contains(element) {
                separatorOperation.append(String(element))
            }
        }
        var index = 0
        while index < separatorOperation.count {
            let operation = separatorOperation[index]
            if operation == "*" || operation == "×" || operation == "÷" || operation == "%" {
                // Выполняем операцию
                let leftNumber = Double(separatorNumber[index]) ?? 0
                let rightNumber = Double(separatorNumber[index + 1]) ?? 0
                var result: Double = 0
                
                switch operation {
                case "*", "×":
                    result = leftNumber * rightNumber
                case "÷":
                    result = leftNumber / rightNumber
                case "%":
                    result = leftNumber.truncatingRemainder(dividingBy: rightNumber)
                default:
                    break
                }
                
                // Обновляем массив чисел и удаляем использованную операцию
                separatorNumber[index] = String(result)
                separatorNumber.remove(at: index + 1)
                separatorOperation.remove(at: index)
            } else {
                index += 1
            }
        }
        
        // Применение операций с низким приоритетом (сложение и вычитание)
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
        
        print(result)
    }
    
    func makePercent(_ text: String) {
        var separatorNumber = text.components(separatedBy: ["+", "-", "*", "×", "÷"])
        guard let percentNumber = separatorNumber.last else { return }
        
        
    }
}

extension MainViewModel: IMainViewModel {
    
    func viewLoaded(ui: IMainViewController) {
        self.ui = ui
    }
}
