//
//  SlowlyCodeProcessor.swift
//  
//
//  Created by 朱浩宇 on 2021/5/22.
//

import Foundation
import Regex

enum SlowlyRegex: String {
    case defineVariables = #"^var ([A-z|_]\S*) = (.+)$"#
    case defineConstant = #"^let ([A-z|_]\S*) = (.+)$"#
    case fastMeasurement = #"^([A-z|_]\S*) := (.+)$"#
    case assignment = #"^([A-z|_]\S*) = (.+)$"#
    case basicNumbers = #"^-?\d+$"#
    case basicString = #"^"(.*)"$"#
    case basicDouble = #"^-?\d+\.\d+$"#
    case eNumbers = #"^-?(\d+\.?\d*)e(\d+)$"#
    case basicFunction = #"^([A-z|_]\S*)\((.*)\)$"#
}

class SlowlyCodeProcessor {
    static let shared = SlowlyCodeProcessor()
    
    init() {}
    
    private var findMain = false
    
    func process(with _code: String) throws {
        // Remove spaces and newlines
        let code = constructionNotes( _code.trimmingCharacters(in: .whitespacesAndNewlines))
        
        // 是否为空行
        guard code != "" else {
            SlowlyInterpreterInfo.shared.codePointer += 1
            return
        }
        
        // 检测开始开始
        if findMain {
            if code == "@main" {
                throw SlowlyCompileError.repeatedStartIdentifier
            }
        } else {
            if code == "@main" {
                self.findMain = true
            }
            SlowlyInterpreterInfo.shared.codePointer += 1
            return
        }
        
        // Find the code belongs to
        do {
            switch code {
            case SlowlyRegex.defineVariables.rawValue.r: try self.defineVariables(code)
            case SlowlyRegex.defineConstant.rawValue.r: try self.defineConstant(code)
            case SlowlyRegex.fastMeasurement.rawValue.r: try self.fastMeasurement(code)
            case SlowlyRegex.assignment.rawValue.r: try self.assignment(code)
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
    
    func clear() {
        self.findMain = false
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
    
    // MARK: - Define constant
    
    private func defineConstant(_ code: String) throws {
        let valueInfo = SlowlyRegex.defineConstant.rawValue.r?.findFirst(in: code)
        
        guard let name = valueInfo?.group(at: 1) else  {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let value = valueInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        do {
            try creatConstant(name: name, value: value)
        } catch {
            throw error
        }
    }
    
    private func creatConstant(name: String, value: String) throws {
        guard !variableHasBeenAdded(name: name) else {
            throw SlowlyValueError.theVariableAlreadyExistsInTheCurrentContext(name: name)
        }
        
        do {
            SlowlyInterpreterInfo.shared.value.append(.init(type: .constant, name: name, value: try getValue(value)))
        } catch {
            throw error
        }
    }
    
    // MARK: - Fast measurement
    
    private func fastMeasurement(_ code: String) throws {
        let valueInfo = SlowlyRegex.fastMeasurement.rawValue.r?.findFirst(in: code)
        
        guard let name = valueInfo?.group(at: 1) else  {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let value = valueInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        do {
            if name.uppercased() == name {
                // 说明快速定义常量
                try self.creatConstant(name: name, value: value)
            } else {
                // 说明快速定义变量
                try self.creatVariable(name: name, value: value)
            }
        } catch {
            throw error
        }
    }
    
    // MARK: - Usage value
    private func getValueValue(name: String) -> SlowlyBasicTypeProtocol? {
        for value in SlowlyInterpreterInfo.shared.value {
            if name == value.name {
                return value.value
            }
        }
        return nil
    }
    
    private func getValueIndex(name: String) -> Int {
        for (index, value) in SlowlyInterpreterInfo.shared.value.enumerated() {
            if name == value.name {
                return index
            }
        }
        return 0
    }
    
    // MARK: - Update Value
    private func updateValue(name: String, value: SlowlyBasicTypeProtocol) throws {
        if value.basicType == getValueValue(name: name)?.basicType || value.basicType == .any {
            SlowlyInterpreterInfo.shared.value[getValueIndex(name: name)].value = value
        } else {
            throw SlowlyValueError.typeDoesNotMatchWhenAssigning(name: name)
        }
    }
    
    // MARK: - Assignment
    private func assignment(_ code: String) throws {
        let assignmentInfo = SlowlyRegex.assignment.rawValue.r?.findFirst(in: code)
        
        guard let name = assignmentInfo?.group(at: 1) else  {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let expression = assignmentInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard variableHasBeenAdded(name: name) else {
            throw SlowlyValueError.unableToFindTheValue(name: name)
        }
        
        do {
            let value = try getValue(expression)
            try updateValue(name: name, value: value)
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
                                        do {
                                            let _v = try getValue(p)
                                            if parameter.ignoreName && !verification[index] && (parameter.type == .any || parameter.type == _v.basicType) {
                                                // 允许使用_
                                                verification[index] = true
                                                _find = true
                                                values[parameter.identifier] = _v // 设置值
                                            }
                                        } catch {
                                            throw error
                                        }
                                    }
                                    
                                    if !_find { // 错误处理
                                        break
                                    }
                                } else if inputParameter.count == 2 {
                                    // 标准输入
                                    
                                    var _find = false
                                    
                                    for (index, parameter) in parameters.enumerated() {
                                        do {
                                            let _v = try getValue(inputParameter[1])
                                            if parameter.name == inputParameter[0] && !verification[index] && (parameter.type == .any || parameter.type == _v.basicType) {
                                                // 匹配
                                                verification[index] = true
                                                _find = true
                                                values[parameter.identifier] = _v // 设置值
                                            }
                                        } catch {
                                            throw error
                                        }
                                    }
                                    
                                    if !_find { // 错误处理
                                        break
                                    }
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
    
    private func creatBasicString(_ str: String) throws -> SlowlyString {
        guard let newString = SlowlyRegex.basicString.rawValue.r?.findFirst(in: str)?.group(at: 1) else {
            throw SlowlyValueError.couldNotParseString(string: str)
        }
        
        guard newString.firstIndex(of: #"""#) == nil else {
            throw SlowlyValueError.couldNotParseString(string: str)
        }
        
        return SlowlyString(value: newString)
    }
    
    private func creatENumber(_ code: String) throws -> SlowlyDouble {
        let eNumberInfo = SlowlyRegex.eNumbers.rawValue.r?.findFirst(in: code)
        
        guard let num = eNumberInfo?.group(at: 1) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let numIndex = eNumberInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        var value = Double(num) ?? 0
        
        for _ in 0..<(Int(numIndex) ?? 0) {
            value *= 10
        }
        
        if code.hasPrefix("-") {
            // 负数
            return SlowlyDouble(value: -value)
        } else {
            // 正数
            return SlowlyDouble(value: value)
        }
    }
    
    private func getValue(_ _code: String) throws -> SlowlyBasicTypeProtocol {
        let code = _code.trimmingCharacters(in: .whitespacesAndNewlines)
        switch code {
        case SlowlyRegex.basicNumbers.rawValue.r:
            return SlowlyInt(value: Int(code) ?? 0)
        case SlowlyRegex.basicDouble.rawValue.r:
            return SlowlyDouble(value: Double(code) ?? 0.0)
        case SlowlyRegex.eNumbers.rawValue.r:
            do { return try creatENumber(code) } catch { throw error }
        case SlowlyRegex.basicString.rawValue.r:
            do { return try self.creatBasicString(code) } catch { throw error }
        default:
            if let value = getValueValue(name: code) {
                return value
            }
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
    }
    
    private func constructionNotes(_ code: String) -> String {
        return String(code.split(with: "/").first ?? "")
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
