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
        switch code {
        case SlowlyRegex.defineVariables.rawValue.r: self.defineVariables(code)
        default: throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
    }
    
    // MARK: - Define variables
    func defineVariables(_ code: String) {
        let valueInfo = SlowlyRegex.defineVariables.rawValue.r?.findFirst(in: code)
        let name = valueInfo?.group(at: 1)
        let value = valueInfo?.group(at: 2)
    }
    
    func creatVariable(name: String, value: String) {
        
    }
}
