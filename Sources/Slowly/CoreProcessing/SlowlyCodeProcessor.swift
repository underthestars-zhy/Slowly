//
//  SlowlyCodeProcessor.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation
import Regex

enum SlowlyRegex: String {
    case defineVariables = #"^var ([A-z|_]\S*) = (\S+)$"#
    case basicNumbers = #"(-)?\d"#
    case eNumbers = #""#
    case basicFunction = #"([A-z|_]\S*)\((.*)\)"#
}

class SlowlyCodeProcessor {
    static let shared = SlowlyCodeProcessor()
    
    init() {}
    
    func process(with _code: String) throws {
        // Remove spaces and newlines
        let code = _code.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // Find the code belongs to
        do {
            switch code {
            case SlowlyRegex.defineVariables.rawValue.r: try self.defineVariables(code)
            case SlowlyRegex.basicFunction.rawValue.r: let _ = try self.callFunction(code)
            default:
                SlowlyInterpreterInfo.shared.continueToCompile = false
                throw SlowlyCompileError.cannotParseStatement(statement: code)
            }
        } catch {
            SlowlyInterpreterInfo.shared.continueToCompile = false
            throw error
        }
        
        // Prepare for the next interpretation statement
        SlowlyInterpreterInfo.shared.codePointer += 1
    }
    
    // MARK: - Define variables
    private func defineVariables(_ code: String) throws {
        let valueInfo = SlowlyRegex.defineVariables.rawValue.r?.findFirst(in: code)
        
        guard let name = valueInfo?.group(at: 1) else  {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let value = valueInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        do {
            try creatVariable(name: name, value: value)
        } catch {
            throw error
        }
    }
    
    private func creatVariable(name: String, value: String) throws {
        guard !variableHasBeenAdded(name: name) else {
            throw SlowlyValueError.theVariableAlreadyExistsInTheCurrentContext(name: name)
        }
        
        
        do {
            SlowlyInterpreterInfo.shared.value.append(.init(type: .variable, name: name, value: try getValue(value)))
        } catch {
            throw error
        }
    }
    
    // MARK: - Call functions
    private func callFunction(_ code: String) throws -> SlowlyBasicTypeProtocol? {
        let funcInfo = SlowlyRegex.basicFunction.rawValue.r?.findFirst(in: code)
        
        guard let funcName = funcInfo?.group(at: 1) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let funcParameter = funcInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        for module in SlowlyInterpreterInfo.shared.module {
            if module.type == .slowly {
                // 模型是基于Swift实现的
                
                if let processClass = module.moduleClass {
                    // 获得核心处理器: processClass
                    
                    // 遍历所有模型中的函数
                    for function in processClass.allFunctions() {
                        if function.split(with: "#")[0] == funcName {
                            // 函数名称符合
                            let parameters = processClass.getFunctionParameter(function)
                            if funcParameter == "" {
                                if parameters.isEmpty {
                                    // 无需参数
                                    return processClass.callFunction(function, values: [:])
                                }
                            }
                            
                            let allParameters = funcParameter.split(with: ",") // 分割参数
                            
                            var verification = [Bool](repeating: false, count: parameters.count) // 用于验证是否已经设置数据
                            
                            var values = [String : SlowlyBasicTypeProtocol]() // 函数的传入数
                            
                            // 遍历输入的参数
                            for p in allParameters {
                                let inputParameter = p.split(with: ":") // 获得输入
                                if inputParameter.count == 1 {
                                    var _find = false
                                    
                                    for (index, parameter) in parameters.enumerated() {
                                        if parameter.ignoreName && !verification[index] {
                                            // 允许使用_
                                            verification[index] = true
                                            _find = true
                                            do {
                                                values[parameter.identifier] = try getValue(p) // 设置值
                                            } catch {
                                                throw error
                                            }
                                        }
                                    }
                                    
                                    if !_find { // 错误处理
                                        break
                                    }
                                } else if inputParameter.count == 2 {
                                    // 标准输入
                                    
                                } else {
                                    throw SlowlyFunctionError.unrecognizedIncomingParameters(parameters: p)
                                }
                            }
                            
                            for (index, value) in verification.enumerated() {
                                if !value {
                                    // 用户没有输入
                                    if let v = parameters[index].defaults {
                                        values[parameters[index].identifier] = v
                                    } else {
                                        break // 错误处理
                                    }
                                }
                            }
                            
                            if verification.filter({ !$0 }).count == 0 {
                                // 所有参数已经填入
                                return processClass.callFunction(function, values: values)
                            }
                        }
                    }
                } else {
                    // 无法获得核心处理器
                    throw SlowlyModelError.unableToGetDodelProcessor(name: module.name)
                }
                
            } else if module.type == .file {
                // 模型是基于Slowly代码实现的
                
            } else {
                // 错误处理，好吧一般没问题
                throw SlowlyModelError.unableToGetModelAnalysisMethod(name: module.name)
            }
        }
        
        // 对没有寻找到函数做处理
        throw SlowlyFunctionError.cannotFindFunction(funcName: funcName)
    }
    
    // MARK: - Share
    private func variableHasBeenAdded(name: String) -> Bool {
        for valueItem in SlowlyInterpreterInfo.shared.value {
            if valueItem.name == name {
                return true
            }
        }
        return false
    }
    
    private func getValue(_ _code: String) throws -> SlowlyBasicTypeProtocol {
        let code = _code.trimmingCharacters(in: .whitespacesAndNewlines)
        switch code {
        case SlowlyRegex.basicNumbers.rawValue.r:
            return SlowlyInt(value: Int(code) ?? 0)
        default:
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
    }
}

extension String {
    func split(with str : String) -> [String] {
        var quotesCount = 0
        var doubleQuotesCount = 0
        var splitItem = [String]()
        
        var strArray = [String]()
        for c in self {
            strArray.append(String(c))
        }
        
        var _str = ""
        
        var _count = 0
        while _count < strArray.count {
            if strArray[_count] == "'" {
                quotesCount += 1
            } else if strArray[_count] == "\"" {
                doubleQuotesCount += 1
            }
            
            if strArray[_count] == str && (quotesCount % 2 == 0) && (doubleQuotesCount % 2 == 0) {
                splitItem.append(_str)
                _str = ""
            } else {
                _str += strArray[_count]
            }
            
            _count += 1
        }
        
        if _str.trimmingCharacters(in: .whitespacesAndNewlines) != "" {
            splitItem.append(_str)
        }
        
        return splitItem
    }
}
