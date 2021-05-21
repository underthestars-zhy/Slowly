import Foundation

public struct Slowly {
    static let shared = Slowly()
    
    private var compileCode = [String]()
    
    // MARK: - Start to compile the compiled content
    func build() throws -> Slowly {
        do {
            try _build()
        } catch {
            throw error
        }
        
        return self
    }
    
    func build() throws {
        do {
            try _build()
        } catch {
            throw error
        }
    }
    
    func _build() throws {
        guard self.compileCode.count > 0 else {
            throw SlowlyCompileError.NoCompiledContent
        }
    }
    
    // MARK: - Set the string information to be compiled
    mutating func setCompileCode(_ code: [String]) -> Slowly {
        _setCompileCode(code)
        
        return self
    }
    
    mutating func setCompileCode(_ code: [String]) {
        _setCompileCode(code)
    }
    
    mutating func _setCompileCode(_ code: [String]) {
        self.compileCode = code
    }
}
