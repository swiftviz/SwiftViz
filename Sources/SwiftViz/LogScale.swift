//
//  LogScale.swift
//
//  Created by Joseph Heck on 3/3/20.

import Foundation

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
public struct LogScale: Scale {

    public let isClamped: Bool
    public let domain: ClosedRange<CGFloat>

    public init(domain: ClosedRange<CGFloat>, isClamped: Bool = false) {
        self.isClamped = isClamped
        self.domain = domain
    }

    /// scales the input value (within domain) per the scale
    /// to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ inputValue: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        var logResult = log10(inputValue)
        if (logResult < 0) {
            logResult = 0.0
        }
        let logDomain = log10(domain.lowerBound)...log10(domain.upperBound)
        let valueMappedToRange = interpolate(normalize(logResult, domain: logDomain), range: range)
        return valueMappedToRange
    }

    /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
    public func invert(_ outputValue: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        let linear = interpolate(normalize(outputValue, domain: range), range: domain)
        return pow(10, linear)
    }

    /// returns an array of the locations of ticks - (value, location)
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(count: Int = 10, range: ClosedRange<CGFloat>) -> [Tick] {
        var result: [Tick] = Array()
        for i in stride(from: 0, through: count, by: 1) {
            // let tickRangeValue = interpolate(CGFloat(i) / CGFloat(count), range: range)
            let tickDomainValue = interpolate(CGFloat(i) / CGFloat(count), range: domain)
            result.append(Tick(value: tickDomainValue,
                               location: scale(tickDomainValue, range: range)))
        }
        return result
    }
}
