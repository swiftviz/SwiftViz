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
        let myScale = LinearScale(domain: 0 ... 1.0, range: 0 ... 100.0, isClamped: false)
        XCTAssertFalse(myScale.isClamped)

        let defaultTicks = myScale.ticks(nil)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(myScale.range.contains(tick))
        }
    }

    func testTimeScale() {
        let start = Date() - TimeInterval(300)
        let end = Date()
        let myTimeScale = TimeScale(domain: start ... end, range: 0 ... 100.0, isClamped: false)

        let defaultTicks = myTimeScale.ticks(nil)
        XCTAssertEqual(defaultTicks.count, 11)
        for tick in defaultTicks {
            // every tick should be from within the scale's domain (input) range
            XCTAssertTrue(myTimeScale.range.contains(tick))
        }
    }

}




