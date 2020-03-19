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
        let scale = LinearScale(domain: 0 ... 10.0, isClamped: false)
        // verifies the method is visible externally - else this won't compile
        let ticks = scale.ticks([2.0], range: 0 ... 10.0)
        XCTAssertEqual(ticks.count, 1)
    }

    func testManualTicksOutsideRange() {
        let scale = LinearScale(domain: 0 ... 10.0, isClamped: false)
        let ticks = scale.ticks([2.0, 4.0, 8.0, 16.0], range: 0 ... 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTickLabelValidation() {
        let scale = LinearScale(domain: 0 ... 10.0, isClamped: false)
        let manualLabels = [
            TickLabel(rangeLocation: -1.0, value: "-1.0"),
            TickLabel(rangeLocation: 1.0, value: "1.0"),
            TickLabel(rangeLocation: 10.0, value: "10.0"),
            TickLabel(rangeLocation: 100.0, value: "100.0"),
        ]
        let validatedSet = scale.validatedTickLabels(manualLabels, range: 0 ... 10.0)
        XCTAssertEqual(validatedSet.count, 2)
    }

    func testManualTickLabelsThroughScale() {
        let scale = LinearScale(domain: 0 ... 10.0, isClamped: false)
        let labeledValues = [
            (CGFloat(-1.0), "-1"),
            (CGFloat(1.0), "1"),
            (CGFloat(10.0), "10"),
            (CGFloat(100.0), "100"),
        ]
        let validatedSet = scale.labeledTickValues(labeledValues, range: 0 ... 10.0)
        XCTAssertEqual(validatedSet.count, 2)
        XCTAssertEqual(validatedSet[0].value, "1")
        XCTAssertEqual(validatedSet[1].value, "10")
    }

    func testScaleClamp() {
        let scale = LinearScale(domain: 5 ... 10.0)
        // default isClamped is false - no clamping
        XCTAssertEqual(scale.clampRange(11.0, withinRange: 5 ... 10.0), 11.0)
        XCTAssertEqual(scale.clampRange(1.0, withinRange: 5 ... 10.0), 1.0)
        XCTAssertEqual(scale.clampRange(7.0, withinRange: 5 ... 10.0), 7.0)

        let cScale = LinearScale(domain: 5 ... 10.0, isClamped: true)
        XCTAssertEqual(cScale.clampDomain(11.0, withinRange: 5 ... 10.0), 10.0)
        XCTAssertEqual(cScale.clampDomain(1.0, withinRange: 5 ... 10.0), 5.0)
        XCTAssertEqual(scale.clampDomain(7.0, withinRange: 5 ... 10.0), 7.0)
    }
}
