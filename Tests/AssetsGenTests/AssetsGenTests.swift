import XCTest
@testable import AssetsGen

final class AssetsGenTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(AssetsGen().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
