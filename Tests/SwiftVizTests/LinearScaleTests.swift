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
        let incoming: TimeInterval = TimeInterval(0.00062460815272012726)
        let outputRange = CGFloat(1)...CGFloat(367)
        // domain appears to be 0..0 in my example where this is failing
        let scale = LinearScale(domain: 0.003 ... 0.056)
        let result = scale.scale(incoming + 0.003, range: outputRange)
        XCTAssertTrue(outputRange.contains(result))
    }
    
    func testLinearScaleTicks() {
        let myScale = LinearScale(domain: 0 ... 1.0)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0) ... CGFloat(100.0)

        let defaultTicks = myScale.ticks(range: testRange)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssert(myScale.domain.contains(tick.value))
        }
    }

    func testLinearScaleManualTicks() {
        let myScale = LinearScale(domain: 0 ... 1.0)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0) ... CGFloat(100.0)
        let manualTicks = myScale.ticks([0.1, 0.5], range: testRange)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssert(myScale.domain.contains(tick.value))
        }
    }

    func testLinearScaleClamp() {
        let scale = LinearScale(domain: 0 ... 10.0)
        let clampedScale = LinearScale(domain: 0 ... 10.0, isClamped: true)
        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = CGFloat(0) ... CGFloat(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(5, range: testRange), 50)
        XCTAssertEqual(clampedScale.scale(5, range: testRange), 50)

        // clamp constrained high
        XCTAssertEqual(scale.scale(11, range: testRange), 110, accuracy: 0.001)
        XCTAssertEqual(clampedScale.scale(11, range: testRange), 100, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.scale(-1, range: testRange), -10)
        XCTAssertEqual(clampedScale.scale(-1, range: testRange), 0)
    }

    func testLinearInvertClamp() {
        let scale = LinearScale(domain: 0 ... 10.0)
        let clampedScale = LinearScale(domain: 0 ... 10.0, isClamped: true)
        XCTAssertFalse(scale.isClamped)
        XCTAssertTrue(clampedScale.isClamped)
        let testRange = CGFloat(0) ... CGFloat(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, range: testRange), 5)
        XCTAssertEqual(clampedScale.invert(50, range: testRange), 5)

        // clamp constrained high
        XCTAssertEqual(scale.invert(110, range: testRange), 11, accuracy: 0.001)
        XCTAssertEqual(clampedScale.invert(110, range: testRange), 10, accuracy: 0.001)

        // clamp constrained low
        XCTAssertEqual(scale.invert(-10, range: testRange), -1)
        XCTAssertEqual(clampedScale.invert(-10, range: testRange), 0)
    }
}
