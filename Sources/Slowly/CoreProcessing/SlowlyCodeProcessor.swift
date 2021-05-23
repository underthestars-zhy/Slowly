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
            case SlowlyRegex.basicFunction.rawValue.r: try self.callFunction(code)
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
            throw SlowlyCompileError.variablesAreDddedRepeatedly(name: name)
        }
        
        
        do {
            SlowlyInterpreterInfo.shared.value.append(.init(type: .variable, name: name, value: try getValue(value)))
        } catch {
            throw error
        }
    }
    
    // MARK: - Call basic functions
    private func callFunction(_ code: String) throws {
        let funcInfo = SlowlyRegex.basicFunction.rawValue.r?.findFirst(in: code)
        
        guard let funcName = funcInfo?.group(at: 1) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        guard let funcParameter = funcInfo?.group(at: 2) else {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
        
        var successfulRequestFunction = false
        
        // Query function
        for module in SlowlyInterpreterInfo.shared.module {
            if module.type == .slowly {
                guard let moduleClass = module.moduleClass else {
                    throw SlowlyCompileError.unableToGetTheIntroduction(name: module.name)
                }
                
                for _funcName in moduleClass.allFunctions() {
                    if funcName == _funcName.split(separator: "#")[0] {
                        let parametersStringArray = funcParameter.split(with: ",")
                        
                        if parametersStringArray.count == 0 {
                            var allHaveDefaultValues = true
                            for _item in moduleClass.getFunctionParameter(_funcName) {
                                allHaveDefaultValues = allHaveDefaultValues || _item.defaults != nil
                            }
                            
                            if allHaveDefaultValues {
                                successfulRequestFunction = true
                                var values = [String : SlowlyBasicTypeProtocol]()
                                for p in moduleClass.getFunctionParameter(_funcName) {
                                    guard let defaults = p.defaults else {
                                        throw SlowlyCompileError.cannotParseStatement(statement: code)
                                    }
                                    values[p.identifier] = defaults
                                }
                                let _ = moduleClass.callFunction(_funcName, values: values)
                            } else {
                                continue
                            }
                        } else {
                            successfulRequestFunction = true
                            var values = [String : SlowlyBasicTypeProtocol]()
                            let parameters = moduleClass.getFunctionParameter(_funcName)
                            var _valueSetArray = Array(repeating: false, count: parameters.count)
                            
                            for item in parametersStringArray {
                                let _itemArray = item.split(with: ":")
                                if _itemArray.count == 1 {
                                    var _count = 0
                                    var _ok = false
                                    for p in parameters {
                                        if p.name == "_" && !_valueSetArray[_count] {
                                            _valueSetArray[_count] = true
                                            do { values[p.identifier] = try getValue(_itemArray[0]) } catch { throw error }
                                            _ok = true
                                            break
                                        }
                                        
                                        _count += 1
                                    }
                                    
                                    if !_ok {
                                        throw SlowlyCompileError.cannotParseStatement(statement: code)
                                    }
                                } else if _itemArray.count < 1 {
                                    throw SlowlyCompileError.cannotParseStatement(statement: code)
                                } else {
                                    
                                }
                            }
                            
                            let _ = moduleClass.callFunction(_funcName, values: values)
                        }
                        
                        break
                    }
                }
            } else {
                
            }
        }
        
        if !successfulRequestFunction {
            throw SlowlyCompileError.cannotParseStatement(statement: code)
        }
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
