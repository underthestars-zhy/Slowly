//
//  SlowlyModuleClassProtocol.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

protocol SlowlyModuleClassProtocol {
    func allClass() -> [String]
    func allStruct() -> [String]
    func allFunctions() -> [String]
    func callFunction(_ name: String, values: [String : SlowlyBasicTypeProtocol]) -> SlowlyBasicTypeProtocol?
    func getFunctionParameter(_ name: String) -> [SlowlyFunctionParameter]
}
