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
        shared.value = []
        shared.module = [
            .init(type: .slowly, moduleClass: SlowlyModule.shared, moduleFile: nil)
        ]
    }
    
    // MARK: - Data that needs to be confirmed before compilation
    var module = [SlwolyModuleConfigPackage]()
    
    // MARK: - It needs to be stored and recalled at any time during operation
    var value = [SlowlyValue]()
}
