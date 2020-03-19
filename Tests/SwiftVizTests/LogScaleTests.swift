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

    func testLogScaleManualTicks() {
        let myScale = LogScale(domain: 0.01 ... 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0) ... CGFloat(100.0)

        let manualTicks = myScale.ticks([0.1, 1, 10], range: testRange)

        XCTAssertEqual(manualTicks.count, 3)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
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

    func testLogScaleTicksOutsideDomain() {
        let myScale = LogScale(domain: 10 ... 1000.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0.0) ... CGFloat(100.0)

        let manualTicks = myScale.ticks([0.1, 1, 10, 100, 1000], range: testRange)

        XCTAssertEqual(manualTicks.count, 3)
        for tick in manualTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssert(myScale.domain.contains(tick.value))
        }
    }

    func testLogScaleClamp() {
        let scale = LogScale(domain: 1 ... 100.0)
        let clampedScale = LogScale(domain: 1 ... 100.0, isClamped: true)
        
        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = CGFloat(0) ... CGFloat(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(10, range: testRange), 50)
        XCTAssertEqual(clampedScale.scale(10, range: testRange), 50)

        // clamp constrained high
        XCTAssertEqual(scale.scale(1000, range: testRange), 150, accuracy: 0.001)
        XCTAssertEqual(clampedScale.scale(1000, range: testRange), 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.scale(0.1, range: testRange), -50)
        XCTAssertEqual(clampedScale.scale(0.1, range: testRange), 0)
    }

    func testLogInvertClamp() {
        let scale = LogScale(domain: 1 ... 100.0)
        let clampedScale = LogScale(domain: 1 ... 100.0, isClamped: true)

        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = CGFloat(0) ... CGFloat(100.0)


        // no clamp effect
        XCTAssertEqual(scale.invert(50, range: testRange), 10)
        XCTAssertEqual(clampedScale.invert(50, range: testRange), 10)

        // clamp constrained high
        XCTAssertEqual(scale.invert(150, range: testRange), 1000, accuracy: 0.001)
        XCTAssertEqual(clampedScale.invert(150, range: testRange), 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.invert(-50, range: testRange), 0.1)
        XCTAssertEqual(clampedScale.invert(-50, range: testRange), 1.0)
    }
}
