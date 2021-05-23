//
//  SlowlyCompileError.swift
//  
//
//  Created by 朱浩宇 on 2021/5/21.
//

import Foundation

public enum SlowlyCompileError: Error {
    case noCompiledContent
    case cannotParseStatement(statement: String)
    case unableToCreateVariable(name: String, value: String)
    case variablesAreDddedRepeatedly(name: String)
    case unableToGetTheIntroduction(name: String)
    case duplicateNameParameter(parameter: String)
}
