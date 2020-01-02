//
//  LinearScale.swift
//
//  Created by Joseph Heck on 4/22/19.
//

import Foundation

/// A linear scale takes input from a continuous domain and maps it to a continuous range.
public struct LinearScale: Scale {
    public typealias InputDomain = Double
    public typealias OutputRange = Double

    public let isClamped: Bool
    public let domain: ClosedRange<InputDomain>
    public let range: ClosedRange<OutputRange>

    init(domain: ClosedRange<InputDomain>, range: ClosedRange<OutputRange>, isClamped: Bool = false) {
        self.isClamped = isClamped
        self.domain = domain
        self.range = range
    }

    /// scales the input value (within domain) per the scale to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ inputValue: InputDomain) -> OutputRange {
        interpolate(normalize(inputValue, domain: domain), range: range)
    }

    public func invert(_ outputValue: OutputRange) -> InputDomain {
        interpolate(normalize(outputValue, domain: range), range: domain)
    }

    /// returns an array of the locations of ticks
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(count: Int = 10) -> [OutputRange] {
        var result: [OutputRange] = Array()
        for i in stride(from: 0, through: count, by: 1) {
            result.append(interpolate(OutputRange(i) / OutputRange(count), range: domain))
        }
        return result
    }
}
