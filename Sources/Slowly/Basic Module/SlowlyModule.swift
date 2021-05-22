//
//  SlowlyModule.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

class SlowlyModule: SlowlyModuleClassProtocol {
    static let shared = SlowlyModule()
    
    allStruct = [""]
    
    init() {}
    
    // MARK: - Follow the SlowlyModuleClassProtocol
    func allClass() -> [String] {
        return []
    }
    
    func allStruct() -> [SlowlyBasicTypeProtocol] {
        return [SlowlyInt, SlowlyIntNil]
    }
}
