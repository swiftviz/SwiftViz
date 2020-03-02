import Foundation

// =============================================================
//  TimeScale.swift

// https://github.com/d3/d3-scale/blob/master/src/time.js

/// Time scales are similar to linear scales, but use Dates instead
/// of numbers and range is implied/identify from the domain provided

// import { scaleTime } from 'd3-scale';
// const time = scaleTime()
//    .domain([new Date('1910-1-1'), (new Date('1920-1-1'))]);
//
/// / for UTC
// const utc = d3.scaleUtc();
// https://github.com/d3/d3-scale#scaleUtc
// https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Scales.md

public struct TimeScale: Scale {
    public func invert(_ outputValue: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        return 0.0
    }


    public typealias InputType = Date

    public let isClamped: Bool
    public let domain: ClosedRange<InputType>

    public init(domain: ClosedRange<Date>, isClamped: Bool = false) {
        self.isClamped = isClamped
        self.domain = domain
    }

    /// scales the input value (within domain) per the scale to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ inputValue: TimeScale.InputType, range: ClosedRange<CGFloat>) -> CGFloat {
        CGFloat(inputValue.timeIntervalSince1970) // - domain.lowerBound.timeIntervalSince1970)
    }

    public func invert(_ outputValue: CGFloat, range: ClosedRange<CGFloat>) -> Date {
        let attemptedDate = Date(timeIntervalSince1970: Double(outputValue))
        //        if domain.contains(attemptedDate) {
        //            return attemptedDate
        //        }
        return attemptedDate
    }

    /// returns an array of the locations of ticks
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(_ count: Int?, range: ClosedRange<CGFloat>) -> [(CGFloat, CGFloat)] {
        let count = count ?? 10 // default of 10 if no value provided
        var result: [(CGFloat, CGFloat)] = Array()
        for _ in stride(from: 0, through: count, by: 1) {
            result.append( (0.0, 0.0) ) // interpolate(Double(i) / Double(count), range: domain))
        }
        return result
    }
}
