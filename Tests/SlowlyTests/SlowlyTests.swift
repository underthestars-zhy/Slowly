    import XCTest
    @testable import Slowly

    final class SlowlyTests: XCTestCase {
        func testVariable() {
            let code = [["@main", "var test = 1", "var test2 = 1", "let text3 = 1.33", "test4 := 11"]]
            XCTAssertNoThrow(try Slowly.shared.setCompileCode(code).build().end())
        }
        
        func testVariable2() {
            let code = [["@main", "var test = 1", "test := 1"]]
            XCTAssertThrowsError(try Slowly.shared.setCompileCode(code).build().end())
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
            let code = [["@main", "var items = 11222", "print(items)", "print(items: items)", "var aa = 1.22e4", "print(aa)", "let bb = 145", "print(bb)", "cc := 1.45", "print(cc)"]]
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
        
        func testUpdateValue() {
            let code = [["@main", "a := 1.1", "print(a)", "a = 2.2", "print(a)"]]
            
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
        
        func testUpdateValue2() {
            let code = [["@main", "a := 1", "print(a)", "a = 2.1", "print(a)"]]
            XCTAssertThrowsError(try Slowly.shared.setCompileCode(code).build().end())
        }
        
        func testUpdateValue3() {
            let code = [["@main", "A := 2", "print(A)", "a = 3", "print(A)"]]
            XCTAssertThrowsError(try Slowly.shared.setCompileCode(code).build().end())
        }
        
        func testString() {
            let code = [["@main", #"a := "hi""#, "print(a)", #"a = "hello""#, "print(a)"]]
            
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
        
        func testString2() {
            let code = [["@main", #"a := ""hi"""#, "print(a)"]]
            XCTAssertThrowsError(try Slowly.shared.setCompileCode(code).build().end())
        }
        
        func testNote() {
            let code = [["@main", #"a := "note // note" // sss"#, "print(a)", "// ddddd"]]
            
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
        
        func testDouble() {
            let code = [["@main", #"a := 1.1"#, "print(a)", "print(1.0)"]]
            
            do {
                try Slowly.shared.setCompileCode(code).build().end()
            } catch {
                print(error)
            }
        }
    }
