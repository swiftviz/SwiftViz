//
//  LogScale.swift
//
//  Created by Joseph Heck on 3/3/20.

 import Numerics
 import Foundation

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
 public struct LogScale: Scale {
     public typealias InputType = Double
     public typealias OutputType = Float

     public let domainLower: Double
     public let domainHigher: Double
     public let domainExtent: Double

     public let isClamped: Bool
     public let desiredTicks: Int

     public init(from lower: Double, to higher: Double, isClamped: Bool = false, desiredTicks: Int = 10) {
        // for a log scale, the lower value of the input domain *must not* be zero or below
        precondition(higher > lower)
         precondition(lower > 0.0)
        self.isClamped = isClamped
         self.domainLower = lower
         self.domainHigher = higher
         self.domainExtent = higher - lower
        self.desiredTicks = desiredTicks
    }

    /// scales the input value (within domain) per the scale
    /// to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ domainValue: Double, from lower: Float, to higher: Float) -> Float {
        let logDomainValue = log10(domainValue)
        let logDomainLower = log10(domainLower)
        let logDomainHigher = log10(domainHigher)
        let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
        let valueMappedToRange = interpolate(Float(normalizedValueOnLogDomain), lower: lower, higher: higher)
        let clampedValue = clamp(valueMappedToRange, lower: lower, higher: higher)
        return clampedValue
    }

    /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
    public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> Double {
        let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
        let logDomainLower = log10(domainLower)
        let logDomainHigher = log10(domainHigher)
        let linear = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
        return clamp(pow(10, linear), lower: domainLower, higher: domainHigher)
    }
 }
