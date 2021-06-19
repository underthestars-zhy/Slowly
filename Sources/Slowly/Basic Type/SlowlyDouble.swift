//
//  SlowlyDouble.swift
//  
//
//  Created by 朱浩宇 on 2021/6/12.
//

import Foundation

struct SlowlyDouble: SlowlyBasicTypeProtocol, Printable {
    // MARK: - External Interface
    static let basicType: SlowlyBasicTypeEnum = .double
    static let name: String = "Double"
    static var functionNames: [String] = []
    static var initParameters: [SlowlyFunctionInfo] = [
        SlowlyFunctionInfo(id: 1, parameter: [
            SlowlyFunctionParameter(name: "source", ignoreName: true, identifier: "source", type: .double)
        ], returnValue: .none),
        SlowlyFunctionInfo(id: 2, parameter: [
            SlowlyFunctionParameter(name: "num", ignoreName: true, identifier: "num", type: .double),
            SlowlyFunctionParameter(name: "power", ignoreName: true, identifier: "power", type: .int)
        ], returnValue: .none)
    ]
    
    static func callFunctions(id: Int, values: [String : Any]) -> SlowlyBasicTypeProtocol? {
        switch id {
        case 1: return SlowlyDouble(value: values["source"] as! Double)
        case 2: return SlowlyDouble(num: values["num"] as! Double, power: values["power"] as! Int)
        default: return nil
        }
    }
    
    let basicType: SlowlyBasicTypeEnum = .double
    
    // MARK: - SlowlyInt
    var value: (molecular: Int, denominator: Int)?
    var isNilInt: Bool
    var isLock = false
    
    // MARK: - Init
    init(value: Double)  {
        self.isNilInt = false
        let string = String(value).split(separator: ".")
        if string.count == 2 {
            self.value = (molecular: Int(string[0] + string[1]) ?? 0, denominator: Int(pow(10, Float(string[1].count))))
        } else {
            self.value = (molecular: Int(value), denominator: 1)
        }
        
        reduce()
    }
    
    init(num: Double, power: Int) {
        self.isNilInt = false
        let string = String(num).split(separator: ".")
        if string.count == 2 {
            self.value = (molecular: (Int(string[0] + string[1]) ?? 0) * Int(pow(10, Float(power))), denominator: Int(pow(10, Float(string[1].count))))
        } else {
            self.value = (molecular: Int(num) * Int(pow(10, Float(power))), denominator: 1)
        }
        
        reduce()
    }
    
    mutating func reduce() {
        guard var molecular = value?.molecular else { return }
        guard var denominator = value?.denominator else { return }
        
        let isOdd = (molecular < 0)
        molecular = isOdd ? -molecular : molecular
        
        if molecular % denominator == 0 {
            value?.molecular = isOdd ? -(molecular / denominator) : molecular / denominator
            value?.denominator = 1
            return
        }
        
        if denominator % molecular == 0 {
            value?.denominator = isOdd ? -(molecular / denominator) : molecular / denominator
            value?.molecular = 1
            return
        }
        
        if ExpandMath.isPrime(molecular) || ExpandMath.isPrime(denominator) { return }
        
        for i in 2..<molecular {
            if molecular % i == 0 && denominator % i == 0 {
                molecular = molecular / i
                denominator = denominator / i
            }
        }
        value?.molecular = isOdd ? -molecular : molecular
        value?.denominator = denominator
    }
    
    // MARK: - Print
    func printString() -> String {
        if isNilInt {
            if let value = self.value {
                return "Optional(\(value.molecular)/\(value.denominator)"
            } else {
                return "Optional(nil)"
            }
        } else {
            return "\(value?.molecular ?? 0)/\(value?.denominator ?? 0)"
        }
    }
}
