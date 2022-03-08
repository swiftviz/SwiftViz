//
//  LinearScaleTests.swift

@testable import SwiftViz
import XCTest

final class LinearScaleTests: XCTestCase {
    func testScaleExampleValues() {
        // this is coming out as -18.503, which is VERY wrong...
        // incoming value example: stddev    NSTimeInterval    0.00062460815272012726
        // range to process that within: 1 ... 367
        // resulting value SHOULD be between those - not negative!
        let incoming = TimeInterval(0.00062460815272012726)
        let outputRange = Float(1) ... Float(367)
        // domain appears to be 0..0 in my example where this is failing
        let scale = LinearScale.DoubleScale(from: 0.003, to: 0.056)
        let result = scale.scale(incoming + 0.003, from: Float(1.0), to: Float(367.0))
        XCTAssertTrue(outputRange.contains(result))
    }

    func testLinearScaleTicks() {
        let myScale = LinearScale.DoubleScale(from: 0.0, to: 1.0)
        XCTAssertFalse(myScale.isClamped)

        let testRange = Float(0) ... Float(100.0)
        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testLinearScaleManualTicks() {
        let myScale = LinearScale.DoubleScale(from: 0.0, to: 10.0)
        XCTAssertFalse(myScale.isClamped)

        let testRange = Float(0) ... Float(100.0)
        let manualTicks = myScale.ticks([0.1, 0.5], range: testRange)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testLinearScaleClamp() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0)
        let clampedScale = LinearScale.DoubleScale(from: 0.0, to: 10.0, isClamped: true)
        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        XCTAssertEqual(scale.scale(11, from: testRange.lowerBound, to: testRange.upperBound), 110, accuracy: 0.001)
        XCTAssertEqual(clampedScale.scale(11, from: testRange.lowerBound, to: testRange.upperBound), 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), -10)
        XCTAssertEqual(clampedScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), 0)
    }

    func testLinearInvertClamp() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0)
        let clampedScale = LinearScale.DoubleScale(from: 0.0, to: 10.0, isClamped: true)
        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)

        // clamp constrained high
        XCTAssertEqual(scale.invert(110, from: testRange.lowerBound, to: testRange.upperBound), 11, accuracy: 0.001)
        XCTAssertEqual(clampedScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound), 10, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), -1)
        XCTAssertEqual(clampedScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), 0)
    }
}
