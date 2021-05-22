import Foundation

public struct Slowly {
    static var shared = Slowly()
    
    private var compileCode = [String]()
    
    // MARK: - Start to compile the compiled content
    func build() throws -> Slowly {
        guard self.compileCode.count > 0 else {
            throw SlowlyCompileError.noCompiledContent
        }
        
        // Start compiling
        do {
            try SlowlyTranslater.shared.interpreter(with: self.compileCode)
        } catch {
            throw error
        }
        
        return self
    }
    
    // MARK: - Set the string information to be compiled
    mutating func setCompileCode(_ code: [String]) -> Slowly {
        self.compileCode = code
        
        return self
    }
    
    // MARK: - End
    func end() {}
}
