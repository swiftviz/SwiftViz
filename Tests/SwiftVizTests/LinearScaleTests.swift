//
//  File.swift
//  
//
//  Created by Joseph Heck on 1/30/20.
//

import Foundation


@testable import SwiftViz
import XCTest

final class LinearScaleTests: XCTestCase {

    func testLinearScaleTicks() {
        let myScale = LinearScale(domain: 0 ... 1.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let testRange = 0 ... 100.0

        let defaultTicks = myScale.ticks(nil, range: testRange)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick))
        }
    }

    func testTimeScale() {
        let start = Date() - TimeInterval(300)
        let end = Date()
        let myTimeScale = TimeScale(domain: start ... end, isClamped: false)

        let testRange = 0 ... 100.0

        let defaultTicks = myTimeScale.ticks(nil, range: testRange)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(testRange.contains(tick))
        }
    }

}




