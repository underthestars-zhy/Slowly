//
//  SlowltDataPackaging.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation

enum SlowlyValueType {
    case constant
    case variable
}

struct SlowlyValue {
    let type: SlowlyValueType
    let name: String
    var value: SlowlyBasicTypeProtocol
}
