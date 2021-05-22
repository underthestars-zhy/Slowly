//
//  SlowlyBasicTypeProtocol.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

protocol SlowlyBasicTypeProtocol {
    static var basicType: SlowlyBasicTypeEnum { get }
    static var name: String { get }
    static var functionNames: [String] { get }
    static var initParameters: [SlowlyFunctionInfo] { get }
    
    static func callFunctions(id: Int, values: [String: Any]) -> SlowlyBasicTypeProtocol?
}
