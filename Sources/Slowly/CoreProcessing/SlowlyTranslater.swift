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
    
    var main = [String]()
    var code = [[String]]()
    
    func interpreter(with code: [[String]]) throws {
        // Init
        self.clear()
        
        for _code in code {
            if _code.firstIndex(of: "@main") != nil {
                self.main = _code
            } else {
                self.code.append(_code)
            }
        }
        
        do {
            while SlowlyInterpreterInfo.shared.continueToCompile && SlowlyInterpreterInfo.shared.codePointer < self.main.count {
                // print(code[SlowlyInterpreterInfo.shared.codePointer])
                try SlowlyCodeProcessor.shared.process(with: self.main[SlowlyInterpreterInfo.shared.codePointer])
            }
        } catch {
            throw error
        }
    }
    
    private func clear() {
        SlowlyInterpreterInfo.initializeCompilationInfo()
        SlowlyCodeProcessor.shared.clear()
        self.code = []
        self.main = []
    }
}
