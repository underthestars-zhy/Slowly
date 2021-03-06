//
//  SlowlyModule.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

struct SlowlyModule: SlowlyModuleClassProtocol {
    static let shared = SlowlyModule()
    
    init() {}
    
    // MARK: - Follow the SlowlyModuleClassProtocol
    func allClass() -> [String] {
        return []
    }
    
    func allStruct() -> [String] {
        return ["SlowlyInt"]
    }
    
    func allFunctions() -> [String] {
        return ["print#1"]
    }
    
    func callFunction(_ name: String, values: [String : SlowlyBasicTypeProtocol]) -> SlowlyBasicTypeProtocol? {
        switch name {
        case "print#1":
            if let value = values["items"] as? Printable {
                print(value.printString())
            } else {
                
            }
            
            return nil
        default:
            return nil
        }
    }
    
    func getFunctionParameter(_ name: String) -> [SlowlyFunctionParameter] {
        switch name {
        case "print#1":
            let item = [
                SlowlyFunctionParameter(name: "items", ignoreName: true, identifier: "items", defaults: nil, type: .any)
            ]
            return item
        default:
            return []
        }
    }
}
