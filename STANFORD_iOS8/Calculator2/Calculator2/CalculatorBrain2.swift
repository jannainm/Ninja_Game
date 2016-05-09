//
//  CalculatorBrain2.swift
//  Calculator2
//
//  Created by Michael Jannain on 7/13/15.
//  Copyright (c) 2015 Michael Jannain. All rights reserved.
//

import Foundation

// this is the M of MVC...i.e. model
// models are UI independent
class CalculatorBrain2
{
    
    // allows a lookup table/definition for type Op
    // declared in array below
    private enum Op: Printable
    {
        case Operand(Double)    // operands will be type double
        case unaryOperation(String, Double -> Double)   // second argument is func
        case binaryOperation(String, (Double, Double) -> Double)
        var description: String { // reutrns ops as strings
            get {
                switch self {
                case .Operand(let operand):
                    return "\(operand)"
                case .unaryOperation(let symbol, _):
                    return symbol
                case .binaryOperation(let symbol, _ ):
                    return symbol
                }
            }
        }
    }
    
    // data structure, array of type Op
    private var opStack = [Op]()    // [Op] --> Array<Op>()
    
    // knownOps is a Dictionary to lookup the math
    // symbol and apply equation (key: String, value: Op)
    private var knownOps = [String:Op]()    // [String:Op]() --> Dictionary<String, Op>()
    
    // e.g. brain = CalculatorBrain2() calls this initializer
    // initializes knownOps
    init() {
        knownOps["×"] = Op.binaryOperation("×", { $0 * $1 })
        knownOps["÷"] = Op.binaryOperation("÷", { $1 / $0 })
        knownOps["+"] = Op.binaryOperation("+", { $0 + $1 })
        knownOps["−"] = Op.binaryOperation("−", { $1 - $0 })
        knownOps["√"] = Op.unaryOperation("√", { sqrt($0) })
        knownOps["cos"] = Op.unaryOperation("cos", { cos($0) })
        knownOps["sin"] = Op.unaryOperation("sin", { sin($0) })
    }
    
    var program: AnyObject { // guarenteed to be a PropertyList
        get {
            return opStack.map { $0.description }
        }
        set {
            if let opSymbols = newValue as? Array<String> {
                var newOpStack = [Op]()
                for opSymbols in opSymbols {
                    if let op = knownOps[opSymbols] {
                        newOpStack.append(op)
                    } else if let operand = NSNumberFormatter().numberFromString(opSymbols)?.doubleValue {
                        newOpStack.append(.Operand(operand))
                    }
                }
                opStack = newOpStack
            }
        }
    }
    
    // ops is an array of Op enums
    // returns tuple
    private func evaluate(ops: [Op]) -> (result: Double?, remainingOps: [Op])
    {
        if !ops.isEmpty {   // checks ops for empty
            var remainingOps = ops  // need to declare this var so mutable
            let op = remainingOps.removeLast()   // pops off stack
            switch op { // by switching on op we can use enum values from above
            case Op.Operand(let operand):    // assigns const. operand as param
                return (operand, remainingOps)
            case .unaryOperation(_, let operation):
                let operandEvaluation = evaluate(remainingOps) // recursive
                if let operand = operandEvaluation.result { // if allows double
                    return (operation(operand), operandEvaluation.remainingOps )
                }
            case .binaryOperation(_, let operation):
                let op1Evaluation = evaluate(remainingOps)
                if let operand1 = op1Evaluation.result {
                    let op2Evaluation = evaluate(op1Evaluation.remainingOps)
                    if let operand2 = op2Evaluation.result {
                        return (operation(operand1, operand2), op2Evaluation.remainingOps)
                    }
                }
            }
        }
        return (nil, ops)       // if fails, returns nil
    }
    
    // this other evaluate function is used so that we call opStack once
    // but can continue calling evaluate (above) through recursion without
    // changing or saving op stack each time
    func evaluate() -> Double? {
       let (result, remainder) = evaluate(opStack)
        //converts arrays to string, using enum : printable
        println("\(opStack) = \(result) with \(remainder) leftover")
        return result
    }
    
    // pushes operands onto the stack
    func pushOperand(operand: Double) -> Double? {
        opStack.append(Op.Operand(operand))
        return evaluate()
    }
    
    // pushes items onto stack and performs operation
    func performOperation(symbol: String) -> Double? {
        if let operation = knownOps[symbol]  {      // looks up symbol in knownOps
            opStack.append(operation)
        }
        return evaluate()
    }
    
    func clear() {
        opStack.removeAll()
    }
    
}
