//
//  SlowlyModule.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

struct SlowlyModule: SlowlyModuleClassProtocol {
    static let shared = SlowlyModule()
    
    init() {}
    
    // MARK: - Follow the SlowlyModuleClassProtocol
    func allClass() -> [String] {
        return []
    }
    
    func allStruct() -> [String] {
        return ["SlowlyInt"]
    }
}
