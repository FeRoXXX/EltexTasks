//
//  MainViewModel.swift
//  EltexThirdProject
//
//  Created by Александр Федоткин on 09.10.2024.
//

import Foundation

final class MainViewModel {
    
    //MARK: - Private properties
    private var ui: IMainViewController?
    private let dataSource: MainCollectionViewDataSource
    private var lastAction: String = ""
    
    //MARK: - Initialize
    init(dataSource: MainCollectionViewDataSource) {
        self.dataSource = dataSource
        setupDataSourceAction()
    }
}

private extension MainViewModel {
    
    //MARK: - Setup closure function
    func setupDataSourceAction() {
        dataSource.userAction = { [weak self] text in
            self?.showAction(text: text)
        }
    }
    
    //MARK: - Show action function
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
        case ",":
            checkComma(currentText)
        default:
            if lastAction != "=" {
                switch currentText {
                case "0", "+0":
                    ui?.setupText(text)
                case "-0":
                    ui?.setupText("-" + text)
                default:
                    ui?.setupText(currentText + text)
                }
            } else {
                ui?.setupText(text)
            }
        }
        lastAction = text
    }
    
    //MARK: - Add operators function
    func addOperators(_ currentText: String, _ text: String) {
        guard let lastSymbol = currentText.last else { return }
        var currentText = currentText
        
        switch lastSymbol {
        case "+", "-", "×", "÷", ",":
            currentText.removeLast()
            ui?.setupText(currentText + text)
        default:
            ui?.setupText(currentText + text)
        }
    }
    
    //MARK: - Toggle sign function
    func toggleSign(_ text: String) {
        var separatorNumber = text.components(separatedBy: ["+", "-", "×", "÷"])
        var separatorOperations = getOperations(text)

        if separatorOperations.isEmpty { ui?.setupText("-" + text)}
        
        guard let previousOperator = separatorOperations.last else {
            return
        }

        if previousOperator == "-" {
            separatorOperations.removeLast()
            separatorOperations.append("+")
        } else if previousOperator == "+" {
            separatorOperations.removeLast()
            separatorOperations.append("-")
        } else {
            separatorOperations.append("-")
            separatorNumber.append("")
            separatorNumber.swapAt(separatorNumber.count - 1, separatorNumber.count - 2)
        }

        var result = separatorNumber[0]
        for (index, element) in separatorOperations.enumerated() {
            result += element + separatorNumber[index + 1]
        }

        ui?.setupText(result)
    }

    //MARK: - Make action function
    func makeAction(_ text: String) {
        var separatorNumber = text.components(separatedBy: ["+", "-", "×", "÷"])
        var separatorOperation = getOperations(text)
        
        for i in (0..<separatorNumber.count).reversed() {
            if separatorNumber[i].isEmpty, i + 1 < separatorNumber.count {
                separatorNumber[i + 1] = separatorOperation[i] + separatorNumber[i + 1]
                separatorOperation.remove(at: i)
                separatorNumber.remove(at: i)
            }
        }
        
        var index = 0
        while index < separatorOperation.count {
            let operation = separatorOperation[index]
            if operation == "×" || operation == "÷" {
                
                let leftNumber = separatorNumber[index].convertToDouble() ?? 0
                let rightNumber = separatorNumber[index + 1].convertToDouble() ?? 0
                var result: Double = 0
                
                switch operation {
                case "×":
                    result = leftNumber * rightNumber
                case "÷":
                    if rightNumber == 0 {
                        ui?.setupText("ERROR")
                        return
                    }
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
        var result = separatorNumber[0].convertToDouble() ?? 0
        while index < separatorOperation.count {
            let operation = separatorOperation[index]
            let nextNumber = separatorNumber[index + 1].convertToDouble() ?? 0
            
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
        
        ui?.setupText(result.formatNumber())
    }

    //MARK: - Make percent function
    func makePercent(_ text: String) {
        var separatorNumber = text.components(separatedBy: ["+", "-", "×", "÷"])
        let separatorOperations = getOperations(text)
        
        guard let percentNumberString = separatorNumber.last,
              let percentNumberDouble = Double(percentNumberString) else { return }
        
        let convertNumber = percentNumberDouble * 0.01
        
        separatorNumber[separatorNumber.count - 1] = convertNumber.formatNumber()
        
        var result = separatorNumber[0]
        for (index, element) in separatorOperations.enumerated() {
            result += element + separatorNumber[index + 1]
        }
        
        ui?.setupText(result)
    }
    
    //MARK: - Check comma function
    func checkComma(_ text: String) {
        let separatorNumber = text.components(separatedBy: ["+", "-", "×", "÷"])
        
        guard let lastNumber = separatorNumber.last else { return }
        if lastNumber.contains(",") || lastNumber == "" || lastNumber == "0" {
            return
        } else {
            ui?.setupText(text + ",")
        }
    }
    
    //MARK: - Get operations function
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
    
    //MARK: - Protocol functions
    func viewLoaded(ui: IMainViewController) {
        self.ui = ui
    }
}
