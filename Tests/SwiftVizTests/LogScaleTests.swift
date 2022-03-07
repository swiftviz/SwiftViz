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
        let myScale = LogScale(from: 1.0, to: 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)
        let testRange = Float(0) ... Float(100.0)
        XCTAssertEqual(50.0, myScale.scale(10.0, from: testRange.lowerBound, to: testRange.upperBound), accuracy: 0.01)
    }

    func testLogScale_invert() {
        let myScale = LogScale(from: 1.0, to: 100.0,  isClamped: false)
        XCTAssertFalse(myScale.isClamped)
        let testRange = Float(0) ... Float(100.0)
        let result = myScale.invert(50.0, from: testRange.lowerBound, to: testRange.upperBound)
        XCTAssertEqual(10, result, accuracy: 0.01)
    }

    func testLogScaleTicks() {
        let myScale = LogScale(from: 0.01, to: 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = Float(0.0) ... Float(100.0)

        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 37)
        for tick in defaultTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value)
            XCTAssertTrue(myScale.domainHigher >= tick.value)
        }
    }

    func testLogScaleManualTicks() {
        let myScale = LogScale(from: 0.01, to: 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = Float(0) ... Float(100.0)

        let manualTicks = myScale.ticks([0.1, 1, 10], range: testRange)

        XCTAssertEqual(manualTicks.count, 3)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value)
            XCTAssertTrue(myScale.domainHigher >= tick.value)
        }
    }

    func testLogScaleTicksWeirdDomain() {
        let myScale = LogScale(from: 0.8, to: 999.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = Float(0.0) ... Float(100.0)

        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 28)
        for tick in defaultTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value)
            XCTAssertTrue(myScale.domainHigher >= tick.value)
        }
    }

    func testLogScaleTicksOutsideDomain() {
        let myScale = LogScale(from: 10.0, to: 1000.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = Float(0.0) ... Float(100.0)

        let manualTicks = myScale.ticks([0.1, 1, 10, 100, 1000], range: testRange)

        XCTAssertEqual(manualTicks.count, 3)
        for tick in manualTicks {
            // every tick should be from within the scale's range (output area)
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(myScale.domainLower <= tick.value)
            XCTAssertTrue(myScale.domainHigher >= tick.value)
        }
    }

    func testLogScaleClamp() {
        let scale = LogScale(from: 1.0, to: 100.0)
        let clampedScale = LogScale(from: 1.0, to: 100.0, isClamped: true)

        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(10, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(10, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        XCTAssertEqual(scale.scale(1000, from: testRange.lowerBound, to: testRange.upperBound), 150, accuracy: 0.001)
        XCTAssertEqual(clampedScale.scale(1000, from: testRange.lowerBound, to: testRange.upperBound), 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.scale(0.1, from: testRange.lowerBound, to: testRange.upperBound), -50)
        XCTAssertEqual(clampedScale.scale(0.1, from: testRange.lowerBound, to: testRange.upperBound), 0)
    }

    func testLogInvertClamp() {
        let scale = LogScale(from: 1.0, to: 100.0)
        let clampedScale = LogScale(from: 1.0, to: 100.0, isClamped: true)

        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 10)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 10)

        // clamp constrained high
        XCTAssertEqual(scale.invert(150, from: testRange.lowerBound, to: testRange.upperBound), 1000, accuracy: 0.001)
        XCTAssertEqual(clampedScale.invert(150, from: testRange.lowerBound, to: testRange.upperBound), 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.invert(-50, from: testRange.lowerBound, to: testRange.upperBound), 0.1)
        XCTAssertEqual(clampedScale.invert(-50, from: testRange.lowerBound, to: testRange.upperBound), 1.0)
    }
 }
