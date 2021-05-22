//
//  File.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

struct SlowlyInterpreterInfo {
    static var shared = SlowlyInterpreterInfo()
    
    static func initializeCompilationInfo() {
        shared.codePointer = 0
        shared.continueToCompile = true
    }
    
    var codePointer = 0 // Indicate where to compile
    var continueToCompile = true // Determine whether you need to continue to compile the code
}
