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
        // verifies the method is visible externally - else this won't compile
        let ticks = scale.ticks([2.0, 4.0, 8.0, 16.0], range: 0 ... 10.0)
        XCTAssertEqual(ticks.count, 3)
    }

    func testManualTickLabelValidation() {
        let scale = LinearScale(domain: 0 ... 10.0, isClamped: false)
        // verifies the method is visible externally - else this won't compile
        let manualLabels = [
            TickLabel(rangeLocation: -1.0, value: "-1.0"),
            TickLabel(rangeLocation: 1.0, value: "1.0"),
            TickLabel(rangeLocation: 10.0, value: "10.0"),
            TickLabel(rangeLocation: 100.0, value: "100.0"),
        ]
        let validatedSet = scale.validatedTickLabels(manualLabels, range: 0 ... 10.0)
        XCTAssertEqual(validatedSet.count, 2)
    }

}
