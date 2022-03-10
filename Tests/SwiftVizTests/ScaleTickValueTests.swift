//
//  ScaleTickValueTests.swift
//
//
//  Created by Joseph Heck on 3/9/22.
//

import SwiftViz
import XCTest

class ScaleTickValueTests: XCTestCase {
    func testValidatingTickLabelValues() throws {
        let scale = LinearScale.DoubleScale(from: 0, to: 10)
        let clampedScale = LinearScale.DoubleScale(from: 0, to: 10, transform: .clamp)
        let dropScale = LinearScale.DoubleScale(from: 0, to: 10, transform: .drop)
        XCTAssertEqual(scale.transformType, .none)
        XCTAssertEqual(clampedScale.transformType, .clamp)
        XCTAssertEqual(dropScale.transformType, .drop)

        let tickValues = [(-1.0, "low"), (5.0, "middle"), (11.0, "high")]
        XCTAssertEqual(scale.labeledTickValues(tickValues, from: 0, to: 10).count, 1)
        XCTAssertEqual(clampedScale.labeledTickValues(tickValues, from: 0, to: 10).count, 1)
        XCTAssertEqual(dropScale.labeledTickValues(tickValues, from: 0, to: 10).count, 1)
    }
}
