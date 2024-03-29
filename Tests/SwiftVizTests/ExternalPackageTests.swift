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
        let ticks = scale.tickValues([2.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 1)
    }

    func testManualTicksOutsideRangeNone() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .none)
        let ticks = scale.tickValues([2.0, 4.0, 8.0, 16.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTicksOutsideRangeClamped() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .clamp)
        let ticks = scale.tickValues([2.0, 4.0, 8.0, 16.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTicksOutsideRangeDropped() {
        let scale = LinearScale.DoubleScale(from: 0.0, to: 10.0, transform: .drop)
        let ticks = scale.tickValues([2.0, 4.0, 8.0, 16.0], from: 0.0, to: 10.0)
        XCTAssertEqual(ticks.count, 3)
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
