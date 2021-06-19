//
//  ExpandMath.swift
//  
//
//  Created by 朱浩宇 on 2021/6/18.
//

import Foundation

struct ExpandMath {
    static func isPrime(_ num: Int) -> Bool {
        if num == 1 {
            return false
        }
        for i in 2..<(Int(sqrt(Double(num))) + 1) {
            if num % i == 0 {
                return false
            }
        }
        return true
    }
}
