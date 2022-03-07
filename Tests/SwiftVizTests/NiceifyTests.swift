//
//  NiceifyTests.swift
//
//
//  Created by Joseph Heck on 3/6/22.
//
@testable import SwiftViz
import XCTest

class NiceifyTests: XCTestCase {
    func testNiceify1() {
        XCTAssertEqual(0, niceify(0, round: false))
        XCTAssertEqual(0, niceify(0, round: true))
    }

    func testNiceify2() {
        XCTAssertEqual(0.1, niceify(0.1, round: false))
        XCTAssertEqual(0.1, niceify(0.1, round: true))
    }

    func testNiceify3() {
        XCTAssertEqual(0.5, niceify(0.3, round: false))
        XCTAssertEqual(0.2, niceify(0.3, round: true))
    }

    func testNiceify4() {
        XCTAssertEqual(1.0, niceify(0.6, round: false))
        XCTAssertEqual(0.5, niceify(0.6, round: true))
    }

    func testNiceify5() {
        XCTAssertEqual(1.0, niceify(0.8, round: false))
        XCTAssertEqual(1.0, niceify(0.8, round: true))
    }

    func testNiceify6() {
        XCTAssertEqual(2.0, niceify(1.1, round: false))
        XCTAssertEqual(1.0, niceify(1.1, round: true))
    }

    func testNiceify7() {
        XCTAssertEqual(2.0, niceify(1.6, round: false))
        XCTAssertEqual(2.0, niceify(1.6, round: true))
    }

    func testNiceify8() {
        XCTAssertEqual(10.0, niceify(9.1, round: false))
        XCTAssertEqual(10.0, niceify(9.1, round: true))
    }

    func testNiceify9() {
        XCTAssertEqual(20.0, niceify(11.1, round: false))
        XCTAssertEqual(10.0, niceify(11.1, round: true))
    }

    func testNiceify10() {
        XCTAssertEqual(20.0, niceify(14.9, round: false))
        XCTAssertEqual(10.0, niceify(14.9, round: true))
    }

    func testNiceify11() {
        XCTAssertEqual(20.0, niceify(15.1, round: false))
        XCTAssertEqual(20.0, niceify(15.1, round: true))
    }

    func testNiceify12() {
        XCTAssertEqual(50.0, niceify(21.1, round: false))
        XCTAssertEqual(20.0, niceify(21.1, round: true))
    }

    func testNiceifySeq1() {
        let inputs = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        let niced_results = inputs.map {
            niceify($0, round: false)
        }
        let niced_rounded_results = inputs.map {
            niceify($0, round: true)
        }
        XCTAssertEqual(niced_results,         [0.0, 1.0, 2.0, 5.0, 5.0, 5.0, 10.0, 10.0, 10.0, 10.0, 10.0])
        XCTAssertEqual(niced_rounded_results, [0.0, 1.0, 2.0, 5.0, 5.0, 5.0,  5.0, 10.0, 10.0, 10.0, 10.0])
    }
}
