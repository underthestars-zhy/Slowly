    import XCTest
    @testable import Slowly

    final class SlowlyTests: XCTestCase {
        func testVariable() {
            let code = ["var test = 1", "var test2 = 1"]
            XCTAssertNoThrow(try Slowly.shared.setCompileCode(code).build().end())
            let code2 = ["var test = 1", "var test = 1"]
            XCTAssertThrowsError(try Slowly.shared.setCompileCode(code2).build().end())
        }
        
        func testFunc() {
            let code = ["print(items: 101)", "print(101)", "print(-102)"]
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
    }
