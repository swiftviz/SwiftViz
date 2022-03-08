//
//  NiceValueTests.swift
//  
//
//  Created by Joseph Heck on 3/7/22.
//

import XCTest

class NiceValueTests: XCTestCase {

    func testNiceValuesOfSequence() {
        let inputs: [Double] = [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0]
        let lower_niced_results = inputs.map {
            Double.niceVersion(for: $0, min: true)
        }
        let higher_niced_results = inputs.map {
            Double.niceVersion(for: $0, min: false)
        }
        XCTAssertEqual(lower_niced_results,  [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0])
        XCTAssertEqual(higher_niced_results, [0.0, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 7.0, 8.0, 9.0, 10.0])
    }

    func testNicerValuesOfSequenceWithOffsets() {
        let inputs: [Double] = [0.1, 1.1, 2.2, 3.3, 4.4, 5.5, 6.6, 7.7, 8.8, 9.9, 10.0]
        let lower_niced_results = inputs.map {
            Double.nicerVersion(for: $0, min: true)
        }
        let higher_niced_results = inputs.map {
            Double.nicerVersion(for: $0, min: false)
        }
        XCTAssertEqual(lower_niced_results,  [0.1, 1.0, 2.0, 5.0, 5.0,  5.0,  5.0, 10.0, 10.0, 10.0, 10.0])
        XCTAssertEqual(higher_niced_results, [0.1, 2.0, 5.0, 5.0, 5.0, 10.0, 10.0, 10.0, 10.0, 10.0, 10.0])
    }

}
