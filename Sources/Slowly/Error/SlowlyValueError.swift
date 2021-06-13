//
//  SlowlyValueError.swift
//  
//
//  Created by 朱浩宇 on 2021/6/6.
//

import Foundation

public enum SlowlyValueError: Error {
    case unableToCreateVariable(name: String, value: String)
    case theVariableAlreadyExistsInTheCurrentContext(name: String)
    case unableToFindTheValue(name: String)
    case typeDoesNotMatchWhenAssigning(name: String)
    case couldNotParseString(string: String)
}
