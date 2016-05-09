//
//  ViewController.swift
//  Calculator2
//
//  Created by Michael Jannain on 7/10/15.
//  Copyright (c) 2015 Michael Jannain. All rights reserved.
//

import UIKit
import Darwin

// name if class, inherits from UIViewController
class OldViewController: UIViewController
{
    // code for display; since optional
    // no initialization needed
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false
    
    // method for buttons to append digits to display
    // takes parameter of type UIButton
    @IBAction func appendDigit(sender: UIButton) {
        let digit = sender.currentTitle!
        
        var dig = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            switch dig {
            case "π": display.text = display.text! + "\(M_PI)"
            case ".": display.text = display.text! + "."
            default: display.text = display.text! + digit
            }
        } else {
            switch dig {
            case "π": display.text = "\(M_PI)"
            case ".": display.text = "0."
            default: display.text = digit
            }
            userIsInTheMiddleOfTypingANumber = true
        }
        
        //        if userIsInTheMiddleOfTypingANumber {
        //            // handles pi button
        //            if digit == "π" {
        //                var temp = "\(M_PI)"
        //                display.text = display.text! + temp
        //            } else {
        //                display.text = display.text! + digit
        //            }
        //        } else {
        //            // handles pi button
        //            if digit == "π" {
        //                var temp = "\(M_PI)"
        //                display.text = temp
        //                userIsInTheMiddleOfTypingANumber = true
        //            } else {
        //                display.text = digit
        //                userIsInTheMiddleOfTypingANumber = true
        //            }
        //
        //        }
    }
    
    // runs the mult, div, plus, minus buttons
    @IBAction func operate(sender: UIButton) {
        // operation allows button identification
        let operation = sender.currentTitle!
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        switch operation {
        case "×": performOperation() { $0 * $1 }
        case "÷": performOperation() { $1 / $0 }
        case "+": performOperation() { $0 + $1 }
        case "−": performOperation() { $1 - $0 }
        case "√": performOperation() { sqrt($0) }
        case "cos": performOperation() { cos($0) }
        case "sin": performOperation() { sin($0) }
        default: break
        }
    }
    
    // takes two double to perform operation on them
    // used in operate func above
    private func performOperation(operation: (Double, Double) -> Double) {
        if operandStack.count >= 2 {
            // calls performOperation function
            displayValue = operation(operandStack.removeLast(), operandStack.removeLast())
            enter()
        }
    }
    
    // same function as above, only takes one double
    private func performOperation(operation: Double -> Double) {
        if operandStack.count >= 1 {
            displayValue = operation(operandStack.removeLast())
            enter()
        }
    }
    
    var operandStack = Array<Double>()
    
    // function for enter button only
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        operandStack.append(displayValue)
        // arrays can convert to strings
        println("operandStack = \(operandStack)")
    }
    
    // computed property to convert display
    // text to double, can set/get
    var displayValue: Double {
        get {
            // generic number format for double
            return NSNumberFormatter().numberFromString(display.text!)!.doubleValue
        }
        set {
            // newValue is variable in set
            // converts double to string
            display.text = "\(newValue)"
            userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        display.text = "0.00"
        operandStack.removeAll()
        //enter()
        userIsInTheMiddleOfTypingANumber = false
    }
    
    
}

