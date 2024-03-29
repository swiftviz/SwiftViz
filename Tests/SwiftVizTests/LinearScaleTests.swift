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
        guard let result = scale.scale(incoming + 0.003, from: Float(1.0), to: Float(367.0)) else {
            XCTFail()
            return
        }
        XCTAssertTrue(outputRange.contains(result))
    }

    func testDoubleLinearScaleTicks() {
        let myScale = LinearScale.DoubleScale(from: 0.0, to: 1.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 6)
        for tick in defaultTicks {
            print(tick)
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testFloatLinearScaleTicks() {
        let myScale = LinearScale.FloatScale(from: 0.0, to: 1.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let defaultTicks = myScale.ticks(rangeLower: testRange.lowerBound, rangeHigher: testRange.upperBound)
        XCTAssertEqual(defaultTicks.count, 6)
        for tick in defaultTicks {
            print(tick)
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testDoubleLinearScaleManualTicks() {
        let myScale = LinearScale.DoubleScale(from: 0.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let manualTicks = myScale.tickValues([0.1, 0.5], from: testRange.lowerBound, to: testRange.upperBound)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testFloatLinearScaleManualTicks() {
        let myScale = LinearScale.FloatScale(from: 0.0, to: 10.0)
        XCTAssertEqual(myScale.transformType, .none)

        let testRange = Float(0) ... Float(100.0)
        let manualTicks = myScale.tickValues([0.1, 0.5], from: testRange.lowerBound, to: testRange.upperBound)

        XCTAssertEqual(manualTicks.count, 2)
        for tick in manualTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick.rangeLocation))
            XCTAssertTrue(tick.value >= myScale.domainLower)
            XCTAssertTrue(tick.value <= myScale.domainHigher)
        }
    }

    func testDoubleLinearScaleClamp() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0)
        let clampedScale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .clamp)
        let dropScale = LinearScale.DoubleScale(from: 0, to: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        guard let scaledValue = scale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(scaledValue, 110, accuracy: 0.001)
        guard let clampedScaleValue = clampedScale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(clampedScaleValue, 100, accuracy: 0.001)
        XCTAssertNil(dropScale.scale(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), -10)
        XCTAssertEqual(clampedScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testFloatLinearScaleClamp() {
        let scale = LinearScale.FloatScale(from: 0.0, to: 10.0)
        let clampedScale = LinearScale.FloatScale(from: 0.0, to: 10.0, transform: .clamp)
        let dropScale = LinearScale.FloatScale(from: 0, to: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        guard let scaledValue = scale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(scaledValue, 110, accuracy: 0.001)
        guard let clampedScaleValue = clampedScale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(clampedScaleValue, 100, accuracy: 0.001)
        XCTAssertNil(dropScale.scale(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), -10)
        XCTAssertEqual(clampedScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testIntLinearScaleClamp() {
        let scale = LinearScale.IntScale(from: 0, to: 10)
        let clampedScale = LinearScale.IntScale(from: 0, to: 10, transform: .clamp)
        let dropScale = LinearScale.IntScale(from: 0, to: 10, transform: .drop)

        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)

        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)
        XCTAssertEqual(clampedScale.scale(5, from: testRange.lowerBound, to: testRange.upperBound), 50)

        // clamp constrained high
        guard let scaledValue = scale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(scaledValue, 110, accuracy: 0.001)
        guard let clampedScaleValue = clampedScale.scale(11, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(clampedScaleValue, 100, accuracy: 0.001)
        XCTAssertNil(dropScale.scale(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), -10)
        XCTAssertEqual(clampedScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.scale(-1, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testDoubleLinearInvertClamp() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0)
        let clampedScale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .clamp)
        let dropScale = LinearScale.DoubleScale(from: 0, to: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)

        // clamp constrained high
        guard let invertedValue = scale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedValue, 11, accuracy: 0.001)
        guard let invertedClampedValue = clampedScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedClampedValue, 10, accuracy: 0.001)
        XCTAssertNil(dropScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), -1)
        XCTAssertEqual(clampedScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testFloatLinearInvertClamp() {
        let scale = LinearScale.FloatScale(from: 0.0, to: 10.0)
        let clampedScale = LinearScale.FloatScale(from: 0.0, to: 10.0, transform: .clamp)
        let dropScale = LinearScale.FloatScale(from: 0, to: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)

        // clamp constrained high
        guard let invertedValue = scale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedValue, 11, accuracy: 0.001)
        guard let invertedClampedValue = clampedScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedClampedValue, 10, accuracy: 0.001)
        XCTAssertNil(dropScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), -1)
        XCTAssertEqual(clampedScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound))
    }

    func testIntLinearInvertClamp() {
        let scale = LinearScale.IntScale(from: 0, to: 10)
        let clampedScale = LinearScale.IntScale(from: 0, to: 10, transform: .clamp)
        let dropScale = LinearScale.IntScale(from: 0, to: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)
        let testRange = Float(0) ... Float(100.0)

        // no clamp effect
        XCTAssertEqual(scale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)
        XCTAssertEqual(clampedScale.invert(50, from: testRange.lowerBound, to: testRange.upperBound), 5)

        // clamp constrained high
        guard let invertedValue = scale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedValue, 11)
        guard let invertedClampedValue = clampedScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound) else {
            XCTFail()
            return
        }
        XCTAssertEqual(invertedClampedValue, 10)
        XCTAssertNil(dropScale.invert(110, from: testRange.lowerBound, to: testRange.upperBound))

        // clamp constrained low
        XCTAssertEqual(scale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), -1)
        XCTAssertEqual(clampedScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound), 0)
        XCTAssertNil(dropScale.invert(-10, from: testRange.lowerBound, to: testRange.upperBound))
    }
}
