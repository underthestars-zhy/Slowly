//
//  SlowlyInt.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

struct SlowlyInt: SlowlyBasicTypeProtocol, Printable {
    // MARK: - External Interface
    static let basicType: SlowlyBasicTypeEnum = .int
    static let name: String = "Int"
    static var functionNames: [String] = []
    static var initParameters: [SlowlyFunctionInfo] = [
        SlowlyFunctionInfo(id: 1, parameter: [
            SlowlyFunctionParameter(name: "source", ignoreName: true, identifier: "source", type: .int)
        ], returnValue: .none)
    ]
    
    static func callFunctions(id: Int, values: [String : Any]) -> SlowlyBasicTypeProtocol? {
        switch id {
        case 1: return SlowlyInt(value: values["source"] as! Int)
        default: return nil
        }
    }
    
    let basicType: SlowlyBasicTypeEnum = .int
    
    // MARK: - SlowlyInt
    var value: Int?
    var isNilInt: Bool
    
    // MARK: - Init
    init(value: Int) {
        self.isNilInt = false
        self.value = value
    }
    
    // MARK: - Print
    func printString() -> String {
        if isNilInt {
            if let value = self.value {
                print("Optional(\(value)")
            } else {
                print("Optional(nil)")
            }
        } else {
            return String(value!)
        }
    }
}
