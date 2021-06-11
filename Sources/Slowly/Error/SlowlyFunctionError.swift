//
//  SlowlyFunctionError.swift
//  
//
//  Created by 朱浩宇 on 2021/6/11.
//

import Foundation

public enum SlowlyFunctionError: Error {
    case cannotFindFunction(funcName: String)
}
