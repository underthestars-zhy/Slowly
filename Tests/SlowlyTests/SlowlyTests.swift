    import XCTest
    @testable import Slowly

    final class SlowlyTests: XCTestCase {
        func testVariable() {
            let code = [["@main", "var test = 1", "var test2 = 1"]]
            XCTAssertNoThrow(try Slowly.shared.setCompileCode(code).build().end())
        }
        
        func testVariable2() {
            let code2 = [["@main", "var test = 1", "var test = 1"]]
            XCTAssertThrowsError(try Slowly.shared.setCompileCode(code2).build().end())
        }
        
        func testFunc() {
            let code = [["@main" ,"print(items: 101)", "print(101)", "print(-102)", "print(1.222)", "print(1.222e2)", "print(1.22e3)"]]
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
        
        func testFunc2() {
            let code = [["@main", "var items = 11222", "print(items)", "print(items: items)", "var aa = 1.22e4", "print(aa)"]]
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
    }
