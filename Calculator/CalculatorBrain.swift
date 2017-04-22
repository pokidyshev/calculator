//
//  CalculatorBrain.swift
//  Calculator
//
//  Created by Nikita Pokidyshev on 01.04.17.
//  Copyright © 2017 Nikita Pokidyshev. All rights reserved.
//

import Foundation

struct CalculatorBrain {
    var result: Double? {
        get {
            return accumulator
        }
    }
    var resultIsPending: Bool {
        get {
            return pendingBinaryOperation != nil
        }
    }
    var description: String?

    private var accumulator: Double?
    private var pendingBinaryOperation: PendingBinaryOperation?
    private var operations: Dictionary<String, Operation> = [
        "π" : Operation.constant(Double.pi),
        "±" : Operation.unary(-),
        "%" : Operation.unary({ $0 / 100 }),
        "×" : Operation.binary(*),
        "÷" : Operation.binary(/),
        "–" : Operation.binary(-),
        "+" : Operation.binary(+),
        "=" : Operation.equals,
    ]
    
    mutating func setOperand(_ operand: Double) {
        accumulator = operand
        let operandAsString = " \(operand)"
        if description != nil {
            description! += operandAsString
        } else {
            description = operandAsString
        }
    }
    
    mutating func performOperation(_ symbol: String) {
        if let operation = operations[symbol] {
            switch operation {
            case .constant(let value):
                accumulator = value
            case .unary(let function):
                accumulator = function(accumulator ?? 0)
            case .binary(let function):
                performPendingBinaryOpertaion()
                if accumulator != nil {
                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
                    accumulator = nil
                }
            case .equals:
                performPendingBinaryOpertaion()
            }
        }
    }
    
    mutating func clear() {
        accumulator = nil
    }
    
    mutating func clearAll() {
        clear()
        pendingBinaryOperation = nil
        description = nil
    }
    
    private mutating func performPendingBinaryOpertaion() {
        if resultIsPending && accumulator != nil {
            accumulator = pendingBinaryOperation!.perform(with: accumulator!)
            pendingBinaryOperation = nil
        }
    }
    
    private enum Operation {
        case constant(Double)
        case unary((Double) -> Double)
        case binary((Double, Double) -> Double)
        case equals
    }
    
    private struct PendingBinaryOperation {
        let function: (Double, Double) -> Double
        let firstOperand: Double
        
        func perform(with secondOperand: Double) -> Double {
            return function(firstOperand, secondOperand)
        }
    }
}
