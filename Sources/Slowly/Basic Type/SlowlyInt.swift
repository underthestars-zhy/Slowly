//
//  SlowlyInt.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

struct SlowlyInt: SlowlyBasicTypeProtocol {
    // MARK: - External Interface
    static let basicType: SlowlyBasicTypeEnum = .int
    static let name: String = "Int"
    static var functionNames: [String] = []
    static var initParameters: [SlowlyFunctionInfo] = [
        SlowlyFunctionInfo(id: 1, parameter: [
            SlowlyFunctionParameter(name: nil, identifier: "source", type: .int(nil: false))
        ], returnValue: .none)
    ]
    
    // MARK: - SlowlyInt
    var value: Int
    var isNil: Bool
}
