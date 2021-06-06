//
//  SlowlyTranslater.swift
//  
//
//  Created by 朱浩宇 on 2021/5/21.
//

import Foundation

class SlowlyTranslater {
    static let shared = SlowlyTranslater()
    
    init() {}
    
    func interpreter(with code: [String]) throws {
        // Init
        SlowlyInterpreterInfo.initializeCompilationInfo()
        
        do {
            while SlowlyInterpreterInfo.shared.continueToCompile && SlowlyInterpreterInfo.shared.codePointer < code.count {
                // print(code[SlowlyInterpreterInfo.shared.codePointer])
                try SlowlyCodeProcessor.shared.process(with: code[SlowlyInterpreterInfo.shared.codePointer])
            }
        } catch {
            throw error
        }
    }
}
