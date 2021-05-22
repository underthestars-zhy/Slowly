//
//  SlowlyCodeProcessor.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation
import Regex

enum SlowlyRegex: String {
    case defineVariables = #"^var ([A-z|_]\S*) = (\S+)$"#
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
            default: throw SlowlyCompileError.cannotParseStatement(statement: code)
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Define variables
    func defineVariables(_ code: String) throws {
        let valueInfo = SlowlyRegex.defineVariables.rawValue.r?.findFirst(in: code)
        let name = valueInfo?.group(at: 1)
        let value = valueInfo?.group(at: 2)
        
        guard let name = name else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let value = value else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        self.creatVariable(name: name, value: value)
    }
    
    func creatVariable(name: String, value: String) {
        
    }
}
