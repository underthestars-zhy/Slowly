//
//  SlowlyString.swift
//  
//
//  Created by 朱浩宇 on 2021/6/13.
//

import Foundation

struct SlowlyString: SlowlyBasicTypeProtocol, Printable {
    // MARK: - External Interface
    static let basicType: SlowlyBasicTypeEnum = .string
    static let name: String = "String"
    static var functionNames: [String] = []
    static var initParameters: [SlowlyFunctionInfo] = [
        SlowlyFunctionInfo(id: 1, parameter: [
            SlowlyFunctionParameter(name: "source", ignoreName: true, identifier: "source", type: .string)
        ], returnValue: .none)
    ]
    
    static func callFunctions(id: Int, values: [String : Any]) -> SlowlyBasicTypeProtocol? {
        switch id {
        case 1: return SlowlyString(value: values["source"] as! String)
        default: return nil
        }
    }
    
    let basicType: SlowlyBasicTypeEnum = .string
    
    // MARK: - SlowlyInt
    var value: String?
    var isNilInt: Bool
    
    // MARK: - Init
    init(value: String) {
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
