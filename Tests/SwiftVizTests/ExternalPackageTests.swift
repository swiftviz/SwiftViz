//
//  ExternalPackageTests.swift
//
//  Created by Joseph Heck on 3/10/20.
//

// black box tests to validate using this as an external package... I hope
import Foundation
import SwiftViz
import XCTest

final class PackagingTests: XCTestCase {
    func testManualTicks() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .none)
        // verifies the method is visible externally - else this won't compile
        let ticks = scale.ticks([2.0], range: 0 ... 10.0)
        XCTAssertEqual(ticks.count, 1)
    }

    func testManualTicksOutsideRangeNone() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .none)
        let ticks = scale.ticks([2.0, 4.0, 8.0, 16.0], range: 0 ... 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTicksOutsideRangeClamped() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .clamp)
        let ticks = scale.ticks([2.0, 4.0, 8.0, 16.0], range: 0 ... 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTicksOutsideRangeDropped() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .drop)
        let ticks = scale.ticks([2.0, 4.0, 8.0, 16.0], range: 0 ... 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTickLabelValidation() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .none)
        let manualLabels = [
            TickLabel(rangeLocation: Float(-1.0), value: "-1.0"),
            TickLabel(rangeLocation: Float(1.0), value: "1.0"),
            TickLabel(rangeLocation: Float(10.0), value: "10.0"),
            TickLabel(rangeLocation: Float(100.0), value: "100.0"),
        ]
        let validatedSet = scale.validatedTickLabels(manualLabels, from: 0.0, to: 10.0)
        XCTAssertEqual(validatedSet.count, 2)
    }

    func testManualTickLabelsThroughScale() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .none)
        let labeledValues = [
            (Double(-1.0), "-1"),
            (Double(1.0), "1"),
            (Double(10.0), "10"),
            (Double(100.0), "100"),
        ]
        let validatedSet = scale.labeledTickValues(labeledValues, from: 0.0, to: 10.0)
        XCTAssertEqual(validatedSet.count, 2)
        XCTAssertEqual(validatedSet[0].value, "1")
        XCTAssertEqual(validatedSet[1].value, "10")
    }

    func testScaleTransform() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .none)
        // default isClamped is false - no clamping
        let inputs = [11.0, 1.0, 7.0]
        XCTAssertEqual(inputs.map { scale.transformAgainstDomain($0) }, inputs)

        let cScale = LinearScale.DoubleScale(from: 5.0, to: 10.0, transform: .clamp)
        XCTAssertEqual(inputs.map { cScale.transformAgainstDomain($0) }, [10.0, 5.0, 7.0])

        let dScale = LinearScale.DoubleScale(from: 5.0, to: 10.0, transform: .drop)
        XCTAssertEqual(inputs.map { dScale.transformAgainstDomain($0) }, [nil, nil, 7.0])

    }
}
