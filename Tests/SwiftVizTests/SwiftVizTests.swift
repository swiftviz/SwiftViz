import XCTest
@testable import SwiftViz

final class SwiftVizTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(SwiftViz().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
