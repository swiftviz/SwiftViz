//
//  LogScaleTests.swift
//  SwiftVizTests
//
//  Created by Joseph Heck on 3/3/20.
//

import XCTest
@testable import SwiftViz

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
        let myScale = LogScale(domain: 0 ... 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0) ... CGFloat(100.0)

        XCTAssertEqual(10.0, myScale.invert(1.0, range: testRange), accuracy: 0.01)
    }

    func testLogScaleTicks() {
        let myScale = LogScale(domain: 1 ... 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0.0) ... CGFloat(100.0)

        let defaultTicks = myScale.ticks(range: testRange)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
        }
    }

}
