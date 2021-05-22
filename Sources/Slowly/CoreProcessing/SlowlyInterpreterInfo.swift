//
//  SlowlyInterpreterInfo.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

struct SlowlyInterpreterInfo {
    static var shared = SlowlyInterpreterInfo()
    
    var codePointer = 0 // Indicate where to compile
    var continueToCompile = true // Determine whether you need to continue to compile the code
    
    // MARK: - Initialize the compilation information and restore the information to the default value
    static func initializeCompilationInfo() {
        shared.codePointer = 0
        shared.continueToCompile = true
    }
}
