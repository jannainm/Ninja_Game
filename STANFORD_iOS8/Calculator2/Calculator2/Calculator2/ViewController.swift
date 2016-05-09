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
class ViewController: UIViewController
{
    // code for display; since optional
    // no initialization needed
    @IBOutlet weak var display: UILabel!
    
    var userIsInTheMiddleOfTypingANumber = false

    // in MVC this would be the green arrow that
    // goes from the controller to model
    var brain = CalculatorBrain2()
    
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
    }
    
    // MODEL START
    
    // runs the mult, div, plus, minus buttons
    @IBAction func operate(sender: UIButton) {
        if userIsInTheMiddleOfTypingANumber {
            enter()
        }
        // operation allows button identification
        if let operation = sender.currentTitle {
            if let result = brain.performOperation(operation) {
                displayValue = result
            } else {
                displayValue = 0
            }
        }
    }
    
    
    // function for enter button only
    @IBAction func enter() {
        userIsInTheMiddleOfTypingANumber = false
        // pushes operand onto stack of CalculatorBrain2
        if let result = brain.pushOperand(displayValue) {
            displayValue = result
        } else {
            displayValue = 0
        }
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
            //userIsInTheMiddleOfTypingANumber = false
        }
    }
    
    @IBAction func clear(sender: UIButton) {
        display.text = "0.00"
        brain.clear()
        //operandStack.removeAll()
        userIsInTheMiddleOfTypingANumber = false
    }
    

}

