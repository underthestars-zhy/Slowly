//
//  SlwolyModuleConfigPackage.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

enum SlwolyModuleConfigType {
    case slowly
    case file
}

public struct SlwolyModuleConfigPackage {
    let type: SlwolyModuleConfigType
    let moduleClass: SlowlyModuleClassProtocol?
    let moduleFile: String?
}
