//
//  SlowlyModelError.swift
//  
//
//  Created by 朱浩宇 on 2021/6/11.
//

import Foundation

public enum SlowlyModelError: Error {
    case unableToGetModelAnalysisMethod(name: String)
    case unableToGetDodelProcessor(name: String)
}
