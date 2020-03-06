//
//  NormalizeTests.swift
//
//  Created by Joseph Heck on 4/19/19.
//
@testable import SwiftViz
import XCTest

final class NormalizeTests: XCTestCase {
    func testNormalizeMid() {
        let resultValue = normalize(150.0, domain: 100.0 ... 200.0)
        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 0.5, accuracy: 0.01)
    }

    func testNormalizeLower() {
        let resultValue = normalize(100.0, domain: 100.0 ... 200.0)
        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 0.0, accuracy: 0.01)
    }

    func testNormalizeUpper() {
        let resultValue = normalize(199.9, domain: 100.0 ... 200.0)
        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 1.0, accuracy: 0.01)
    }

    func testNormalizeUpperLimit() {
        let resultValue = normalize(200.0, domain: 100.0 ... 200.0)
        XCTAssertFalse(resultValue.isNaN)
        XCTAssertEqual(resultValue, 1.0, accuracy: 0.01)
    }

    func testNormalizeAbove() {
        let resultValue = normalize(201.0, domain: 100.0 ... 200.0)
        XCTAssertTrue(resultValue.isNaN)
    }
}
