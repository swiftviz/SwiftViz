//
//  ScaleFactoryTests.swift
//  
//
//  Created by Joseph Heck on 3/9/22.
//

import XCTest
import SwiftViz

class ScaleFactoryTests: XCTestCase {

    func testIntScaleFactoryMethods() throws {
        let low: Int = 6
        let high: Int = 124
        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)
        let scale3 = LinearScale.create(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testFloatScaleFactoryMethods() throws {
        let low: Float = 6
        let high: Float = 124

        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)
        let scale3 = LinearScale.create(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }

    func testDoubleScaleFactoryMethods() throws {
        let low: Double = 6
        let high: Double = 124

        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)
        let scale3 = LinearScale.create(high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, 6)
        XCTAssertEqual(scale3.domainLower, 0)
    }
    
    func testDateScaleFactoryMethods() throws {
        let low: Date = Date(timeIntervalSince1970: 123456789)
        let high: Date = low.addingTimeInterval(5 * 60)

        let scale1 = LinearScale.create(low, high)
        let scale2 = LinearScale.create(low ... high)

        XCTAssertEqual(scale1.domainLower, scale2.domainLower)
        XCTAssertEqual(scale1.domainExtent, scale2.domainExtent)
        XCTAssertEqual(scale1.domainLower, low.timeIntervalSince1970)
    }

}
