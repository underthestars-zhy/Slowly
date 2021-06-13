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
        ], returnValue: .none)
    ]
    
    static func callFunctions(id: Int, values: [String : Any]) -> SlowlyBasicTypeProtocol? {
        switch id {
        case 1: return SlowlyDouble(value: values["source"] as! Double)
        default: return nil
        }
    }
    
    let basicType: SlowlyBasicTypeEnum = .double
    
    // MARK: - SlowlyInt
    var value: Double?
    var isNilInt: Bool
    
    // MARK: - Init
    init(value: Double) {
        self.isNilInt = false
        self.value = value
    }
    
    // MARK: - Print
    func printString() -> String {
        if isNilInt {
            if let value = self.value {
                return "Optional(\(value))"
            } else {
                return "Optional(nil)"
            }
        } else {
            return String(value!)
        }
    }
}
