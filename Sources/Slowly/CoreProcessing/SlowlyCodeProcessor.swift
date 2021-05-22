//
//  SlowlyCodeProcessor.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation
import Regex

enum SlowlyRegex: String {
    case defineVariables = #"^var ([A-z|_].*) = (\S+)$"#
    case basicNumbers = #"(-)?\d"#
    case basicFunction = #"([A-z|_].*)\(.*\)"#
}

class SlowlyCodeProcessor {
    static let shared = SlowlyCodeProcessor()
    
    init() {}
    
    func process(with _code: String) throws {
        // Remove spaces and newlines
        let code = _code.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Find the code belongs to
        do {
            switch code {
            case SlowlyRegex.defineVariables.rawValue.r: try self.defineVariables(code)
            case SlowlyRegex.basicFunction.rawValue.r: try self.callFunction(code)
            default: throw SlowlyCompileError.cannotParseStatement(statement: code)
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Define variables
    func defineVariables(_ code: String) throws {
        let valueInfo = SlowlyRegex.defineVariables.rawValue.r?.findFirst(in: code)
        
        guard let name = valueInfo?.group(at: 1) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let value = valueInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        do {
            try creatVariable(name: name, value: value)
        } catch {
            throw error
        }
    }
    
    func creatVariable(name: String, value: String) throws {
        switch value {
        case SlowlyRegex.basicNumbers.rawValue.r:
            SlowlyInterpreterInfo.shared.value.append(.init(type: .variable, name: name, value: SlowlyInt(value: Int(value) ?? 0)))
        default:
            throw SlowlyCompileError.unableToCreateVariable(name: name, value: value)
        }
    }
    
    // MARK: - Call basic functions
    func callFunction(_ code: String) throws {
        let funcInfo = SlowlyRegex.basicFunction.rawValue.r?.findFirst(in: code)
        
        guard let funcName = funcInfo?.group(at: 1) {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let funcParameter = funcInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
    }
}
