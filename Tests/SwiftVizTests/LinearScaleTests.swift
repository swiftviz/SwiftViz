//
//  LinearScaleTests.swift

@testable import SwiftViz
import XCTest

final class LinearScaleTests: XCTestCase {
    func testLinearScaleTicks() {
        let myScale = LinearScale(domain: 0 ... 1.0, isClamped: false)
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
        let myScale = LinearScale(domain: 0 ... 1.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = CGFloat(0) ... CGFloat(100.0)
        let manualTicks = myScale.manualTicks([0.1, 0.5], range: testRange)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssert(myScale.domain.contains(tick.value))
        }
    }

    @available(OSX 10.12, *)
    func testTimeScale() {
        let start = Date() - TimeInterval(300)
        let end = Date()
        let myTimeScale = TimeScale(domain: start ... end, isClamped: false)

        let testRange = CGFloat(0) ... CGFloat(100.0)

        // print("range is \(myTimeScale.domain)")
        let defaultTicks = myTimeScale.ticks(range: testRange)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            // XCTAssert(myTimeScale.domain.contains(tick.value))
            // print("tick \(tick.value) at location \(tick.rangeLocation)")
        }
    }
}
