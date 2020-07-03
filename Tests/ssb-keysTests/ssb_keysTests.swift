import XCTest
@testable import ssb_keys

final class ssb_keysTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ssb_keys().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
