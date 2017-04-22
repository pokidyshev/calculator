//
//  ViewController.swift
//  Calculator
//
//  Created by Nikita Pokidyshev on 28/03/17.
//  Copyright © 2017 Nikita Pokidyshev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBOutlet weak var display: UILabel!
    @IBOutlet weak var operations: UILabel!
    @IBOutlet weak var buttonClear: UIButton!
    
    var displayValue: Double {
        get {
            return Double(display.text!)!
        }
        set {
            var text = String(newValue)
            if text.hasSuffix(".0") {
                let endIndex = text.index(text.endIndex, offsetBy: -2)
                text = text.substring(to: endIndex)
            }
            display.text = text
        }
    }
    
    private var brain = CalculatorBrain()
    private var userIsInTheMiddleOfTyping = false {
        willSet {
            let newTitle = newValue == false ? "AC" : "C"
            buttonClear.setTitle(newTitle, for: UIControlState.normal)
        }
    }
    private var touchedOperation: UIButton? {
        willSet {
            // remove frame
        }
        didSet {
            // add frame
        }
    }
    
    @IBAction func touchDigit(_ sender: UIButton) {
        touchedOperation = nil
        
        let digit = sender.currentTitle!
        if userIsInTheMiddleOfTyping {
            let textCurrenlyInDisplay = display.text!
            display.text = textCurrenlyInDisplay + digit
        } else {
            display.text = digit
            userIsInTheMiddleOfTyping = digit != "0"
        }
    }
    
    @IBAction func touchClear(_ sender: UIButton) {
        if userIsInTheMiddleOfTyping {
            brain.clear()
            userIsInTheMiddleOfTyping = false
        } else {
            brain.clearAll()
        }
        display.text = "0"
    }
    
    @IBAction func performOperation(_ sender: UIButton) {
        touchedOperation = sender
        
        if userIsInTheMiddleOfTyping {
            brain.setOperand(displayValue)
            userIsInTheMiddleOfTyping = false
        }
        if let mathematicalSymbol = sender.currentTitle {
            brain.performOperation(mathematicalSymbol)
        }
        if let result = brain.result {
            displayValue = result
        }
    }
    
    @IBAction func touchDot(_ sender: UIButton) {
        if touchedOperation != nil {
            display.text = "0."
            touchedOperation = nil
        }
        else if let text = display.text, !text.contains(".") {
            display.text = text + "."
        }
        userIsInTheMiddleOfTyping = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}
