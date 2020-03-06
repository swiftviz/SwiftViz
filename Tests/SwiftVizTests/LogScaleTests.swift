//
//  LogScaleTests.swift
//  SwiftVizTests
//
//  Created by Joseph Heck on 3/3/20.
//

@testable import SwiftViz
import XCTest

class LogScaleTests: XCTestCase {
    override func setUp() {
        // Put setup code here. This method is called before the
        // invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the
        // invocation of each test method in the class.
    }

    func testLogScale_scale() {
        let myScale = LogScale(domain: 1 ... 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0) ... CGFloat(100.0)

        XCTAssertEqual(50.0, myScale.scale(10.0, range: testRange), accuracy: 0.01)
    }

    func testLogScale_invert() {
        let myScale = LogScale(domain: 1 ... 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)
        let testRange = CGFloat(0) ... CGFloat(100.0)
        let result = myScale.invert(50.0, range: testRange)
        XCTAssertEqual(10, result, accuracy: 0.01)
    }

    func testLogScaleTicks() {
        let myScale = LogScale(domain: 0.01 ... 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0.0) ... CGFloat(100.0)

        let defaultTicks = myScale.ticks(range: testRange)
        XCTAssertEqual(defaultTicks.count, 37)
        for tick in defaultTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssert(myScale.domain.contains(tick.value))
        }
    }

    func testLogScaleTicksWeirdDomain() {
        let myScale = LogScale(domain: 0.8 ... 999.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0.0) ... CGFloat(100.0)

        let defaultTicks = myScale.ticks(range: testRange)
        XCTAssertEqual(defaultTicks.count, 28)
        for tick in defaultTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssert(myScale.domain.contains(tick.value))
        }
    }
}
