    import XCTest
    @testable import Slowly

    final class SlowlyTests: XCTestCase {
        func TestVariable() {
            let code = ["var value = 1"]
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
