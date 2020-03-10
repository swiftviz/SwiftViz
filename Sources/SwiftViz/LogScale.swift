//
//  LogScale.swift
//
//  Created by Joseph Heck on 3/3/20.

import CoreGraphics
import Foundation

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
public struct LogScale: Scale {
    public typealias InputType = CGFloat
    public typealias TickType = CGFloatTick

    public let isClamped: Bool
    public let domain: ClosedRange<CGFloat>

    public init(domain: ClosedRange<CGFloat>, isClamped: Bool = false) {
        // for a log scale, the lower value of the input domain *must not* be zero or below
        precondition(domain.lowerBound > 0.0)
        self.isClamped = isClamped
        self.domain = domain
    }

    /// scales the input value (within domain) per the scale
    /// to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ inputValue: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        let logResult = log10(inputValue)
        let logDomain = log10(domain.lowerBound) ... log10(domain.upperBound)
        let normalizedValueOnLogDomain = normalize(logResult, domain: logDomain)
        let valueMappedToRange = interpolate(normalizedValueOnLogDomain, range: range)
        return valueMappedToRange
    }

    /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
    public func invert(_ rangeValue: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        let normalizedRangeValue = normalize(rangeValue, domain: range)
        let logDomain = log10(domain.lowerBound) ... log10(domain.upperBound)
        let linear = interpolate(normalizedRangeValue, range: logDomain)
        return pow(10, linear)
    }

    /// returns an array of the locations of ticks - (value, location)
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(count _: Int = 10, range: ClosedRange<CGFloat>) -> [CGFloatTick] {
        // print("mapping ticks onto range: \(range)")
        var result: [CGFloatTick] = Array()
        for powerOfTen in stride(from: log10(domain.lowerBound), through: log10(domain.upperBound), by: 1) {
            // print("power of ten: ", powerOfTen)
            let regularValue = pow(10, powerOfTen)
            for interpolatedValue in stride(from: regularValue, through: regularValue * 9.0, by: regularValue) {
                if domain.contains(interpolatedValue) {
                    // print("adding tick for value \(interpolatedValue) logvalue: \(log10(interpolatedValue)) at location \(scale(interpolatedValue, range: range))")
                    result.append(CGFloatTick(value: interpolatedValue, location: scale(interpolatedValue, range: range)))
                }
            }
        }
        return result
    }

    public func ticks(_ inputValues: [CGFloat], range: ClosedRange<CGFloat>) -> [CGFloatTick] {
        inputValues.map { inputValue in
            CGFloatTick(value: inputValue,
                        location: scale(inputValue, range: range))
        }
    }
}
