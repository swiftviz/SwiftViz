////
////  LogScale.swift
////
////  Created by Joseph Heck on 3/3/20.
//
//import Numerics
//import Foundation
//
///// A linear scale is created using a continuous input domain and provides methods to
///// convert values within that domain to an output range.
//public struct LogScale: Scale {
//    public typealias InputType = Float
//    public typealias OutputType = Float
//    public func cast(value: Float) -> Float {
//        return value
//    }
//    public func cast(range: ClosedRange<Float>) -> ClosedRange<Float> {
//        return range
//    }
//    
//    public let isClamped: Bool
//    public let domain: ClosedRange<InputType>
//    public let desiredTicks: Int
//
//    public init(domain: ClosedRange<InputType>, desiredTicks: Int = 10, isClamped: Bool = false) {
//        // for a log scale, the lower value of the input domain *must not* be zero or below
//        precondition(domain.lowerBound > 0.0)
//        self.isClamped = isClamped
//        self.domain = domain
//        self.desiredTicks = desiredTicks
//    }
//
//    /// scales the input value (within domain) per the scale
//    /// to the relevant output (using range)
//    ///
//    /// - Parameter x: value within the domain
//    /// - Returns: scaled value
//    public func scale(_ inputValue: InputType, range: ClosedRange<OutputType>) -> OutputType {
//        let logResult = log10(inputValue)
//        let logDomainLower = log10(domain.lowerBound)
//        let logDomainHigher = log10(domain.upperBound)
//        let normalizedValueOnLogDomain = normalize(logResult, lower: logDomainLower, higher: logDomainHigher)
//        let valueMappedToRange = interpolate(normalizedValueOnLogDomain, lower: range.lowerBound, higher:range.upperBound)
//        return clamp(valueMappedToRange, within: range)
//    }
//
////    /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
////    public func invert(_ rangeValue: OutputType, domain: ClosedRange<InputType>) -> InputType {
////        let normalizedRangeValue = normalize(rangeValue, lower: domain.lowerBound, higher: domain.upperBound)
////        let logDomainLower = log10(domain.lowerBound)
////        let logDomainHigher = log10(domain.upperBound)
//////        let logDomain = log10(domain.lowerBound) ... log10(domain.upperBound)
////        let linear = interpolate(normalizedRangeValue, lower: logDomainLower, higher: logDomainHigher)
////        return clamp(pow(10, linear), within: domain)
////    }
//
//    /// returns an array of the locations of ticks - (value, location)
//    ///
//    /// - Parameter count: number of steps to take in the ticks, default of 10
//    /// - Returns: array of the locations of the ticks within self.range
//    public func ticks(range: ClosedRange<OutputType>) -> [Tick<InputType,OutputType>] {
//        // print("mapping ticks onto range: \(range)")
//        var result: [Tick<InputType,OutputType>] = Array()
//        for powerOfTen in stride(from: log10(domain.lowerBound), through: log10(domain.upperBound), by: 1) {
//            // print("power of ten: ", powerOfTen)
//            let regularValue = pow(10, powerOfTen)
//            for interpolatedValue in stride(from: regularValue, through: regularValue * 9.0, by: regularValue) {
//                if domain.contains(interpolatedValue) {
//                    // print("adding tick for value \(interpolatedValue) logvalue: \(log10(interpolatedValue)) at location \(scale(interpolatedValue, range: range))")
//                    result.append(Tick(value: interpolatedValue, location: scale(interpolatedValue, range: range)))
//                }
//            }
//        }
//        return result
//    }
//}
