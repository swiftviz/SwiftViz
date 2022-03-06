//import Numerics
//import Foundation
//
//// =============================================================
////  TimeScale.swift
//
//// https://github.com/d3/d3-scale/blob/master/src/time.js
//
///// Time scales are similar to linear scales, but use Dates instead
///// of numbers and range is implied/identify from the domain provided
//
//// import { scaleTime } from 'd3-scale';
//// const time = scaleTime()
////    .domain([new Date('1910-1-1'), (new Date('1920-1-1'))]);
////
///// / for UTC
//// const utc = d3.scaleUtc();
//// https://github.com/d3/d3-scale#scaleUtc
//// https://github.com/d3/d3-3.x-api-reference/blob/master/Time-Scales.md
//// Time Scale
//// - https://github.com/d3/d3-scale/blob/master/src/time.js
//// - D3 has a time format (https://github.com/d3/d3-time-format), but we can probably use
////   IOS/MacOS NSTime, NSDate formatters and calendrical mechanisms
//
//public struct DateScale: Scale {
//    public typealias InputType = TimeInterval
//    public typealias TickType = DateTick
//
//    public let isClamped: Bool
//    public let domain: ClosedRange<InputType>
//
//    public init(domain: ClosedRange<TimeInterval>, isClamped: Bool = false) {
//        self.isClamped = isClamped
//        self.domain = domain
//    }
//
//    /// scales the input value (within domain) per the scale to the relevant output (using range)
//    ///
//    /// - Parameter x: value within the domain
//    /// - Returns: scaled value
//    public func scale(_ inputValue: DateScale.InputType, range: ClosedRange<Float>) -> Float {
////        let inputAsFloat = Float(inputValue.timeIntervalSince1970)
////        let dateDomainAsFloat = Float(domain.lowerBound.timeIntervalSince1970) ... Float(domain.upperBound.timeIntervalSince1970)
//        let valueMappedToRange = interpolate(normalize(inputValue, domain: domain), range: range)
//        return clamp(valueMappedToRange, within: range)
//    }
//
//    /// converts back from the output "range" to a value within
//    /// the input "domain". The inverse of scale()
//    ///
//    /// - Parameter outputValue: a value within the bounds of the
//    ///   ClosedRange for range
//    /// - Returns: a value within the bounds of the ClosedRange
//    ///   for domain, or NaN if it maps outside the bounds
//    public func invert(_ outputValue: Float, range: ClosedRange<Float>) -> Date {
//        let normalizedFloatFromRange = normalize(outputValue, domain: range)
//        let interpolatedInterval = Float(domain.lowerBound.timeIntervalSince1970) * (1 - normalizedFloatFromRange) + Float(domain.upperBound.timeIntervalSince1970) * normalizedFloatFromRange
//        let attemptedDate = Date(timeIntervalSince1970: TimeInterval(interpolatedInterval))
//        return clamp(attemptedDate, within: domain)
//    }
//
//    func interpolateDate(_ x: Float, range: ClosedRange<Date>) -> Date {
//        // let timeInterval = someDate.timeIntervalSince1970 // timeInterval is an alias for a Double
//        let interpolatedInterval = Float(range.lowerBound.timeIntervalSince1970) * (1 - x) + Float(range.upperBound.timeIntervalSince1970) * x
//        return Date(timeIntervalSince1970: Double(interpolatedInterval))
//    }
//
//    /// returns an array of the locations of ticks
//    ///
//    /// - Parameter count: number of steps to take in the ticks, default of 10
//    /// - Returns: array of the locations of the ticks within self.range
//    public func ticks(count: Int = 10, range: ClosedRange<Float>) -> [DateTick] {
//        var result: [DateTick] = Array()
//        for i in stride(from: 0, through: count, by: 1) {
//            let tickDomainValue = interpolateDate(Float(i) / Float(count), range: domain)
//            result.append(DateTick(value: tickDomainValue,
//                                   location: scale(tickDomainValue, range: range)))
//        }
//        return result
//    }
//}
