//
//  TickLabelTests.swift
//
//  Created by Joseph Heck on 3/14/20.
//

@testable import SwiftViz
import XCTest

final class TickLabelTests: XCTestCase {
    func testTickLabelInit() {
        let result = TickLabel(id: UUID(), rangeLocation: 1.0, value: "one")
        XCTAssertNotNil(result)
        XCTAssertNotNil(result.id)
        XCTAssertEqual("one", result.value)
        XCTAssertEqual(1.0, result.rangeLocation)
    }

    func testTickLabelConvenienceInit() {
        let result = TickLabel(rangeLocation: 1.0, value: "one")
        XCTAssertNotNil(result)
        XCTAssertNotNil(result.id)
        XCTAssertEqual("one", result.value)
        XCTAssertEqual(1.0, result.rangeLocation)
    }

    func testTickLabelConvenienceInitWithDefaultFormatter() throws {
        let formatter = TickLabel<Double>.makeDefaultFormatter()
        let value = 1.0
        let result = TickLabel(rangeLocation: CGFloat(value), value: formatter.string(for: value)!)
        XCTAssertNotNil(result)
        XCTAssertNotNil(result.id)
        XCTAssertEqual("1.0", result.value)
        XCTAssertEqual(1.0, result.rangeLocation)
    }
}
