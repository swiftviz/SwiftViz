import CloudKit
import Foundation
import Numerics

// =============================================================
//  LinearScale.swift

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
public struct LinearScale<T>: Scale where T: Comparable, T: Numeric {
    public func scale(_ domainValue: T, from: Float, to: Float) -> Float {
        fatalError("Not implemented for \(type(of: T.self))")
        // return Float.nan
    }
    
    public func invert(_ rangeValue: Float, from: Float, to: Float) -> T {
        fatalError("Not implemented for \(type(of: T.self))")
        // return T.nan
    }
    
    public typealias InputType = T
    public typealias OutputType = Float

    public let domainLower: T
    public let domainHigher: T
    public let domainExtent: T

    public let isClamped: Bool
    public let desiredTicks: Int

    public init(from lower: T, to higher: T, isClamped: Bool = false, desiredTicks: Int = 10) {
        precondition(lower < higher)
        self.isClamped = isClamped
        domainLower = lower
        domainHigher = higher
        domainExtent = higher - lower
        self.desiredTicks = desiredTicks
    }
}

extension LinearScale where T == Double {
    public func scale(_ domainValue: T, from lower: Float, to higher: Float) -> Float {
        let normalizedInput = normalize(domainValue, lower: domainLower, higher: domainHigher)
        let result: InputType = interpolate(normalizedInput, lower: Double(lower), higher: Double(higher))
        // if we're clamped, constrain the output to the range
        let clampedValue = clamp(result, lower: Double(lower), higher: Double(higher))
        return Float(clampedValue)
    }

    public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> T {
        // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        let normalizedRangeValue = normalize(Double(rangeValue), lower: Double(lower), higher: Double(higher))
        let mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower, higher: domainHigher)
        let clampedValue = clamp(mappedToDomain, lower: domainLower, higher: domainHigher)
        return clampedValue
    }
}

extension LinearScale where T == Float {
    public func scale(_ domainValue: T, from lower: Float, to higher: Float) -> Float {
        let normalizedInput = normalize(domainValue, lower: domainLower, higher: domainHigher)
        let result: InputType = interpolate(normalizedInput, lower: lower, higher: higher)
        // if we're clamped, constrain the output to the range
        let clampedValue = clamp(result, lower: lower, higher: higher)
        return clampedValue
    }

    public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> T {
        // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
        let mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower, higher: domainHigher)
        let clampedValue = clamp(mappedToDomain, lower: domainLower, higher: domainHigher)
        return clampedValue
    }
}

extension LinearScale where T == Int {
    public func scale(_ domainValue: Int, from lower: Float, to higher: Float) -> Float {
        let convertedDomain = Float(domainValue)
        let convertedDomainLower = Float(Int(domainLower))
        let convertedDomainHigher = Float(Int(domainHigher))
        let normalizedInput = normalize(convertedDomain, lower: convertedDomainLower, higher: convertedDomainHigher)
        let result = interpolate(normalizedInput, lower: Float(lower), higher: Float(higher))
        // if we're clamped, constrain the output to the range
        let clampedValue = clamp(result, lower: Float(lower), higher: Float(higher))
        return Float(clampedValue)
    }

    public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> T {
        // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        let normalizedRangeValue = normalize(Double(rangeValue), lower: Double(lower), higher: Double(higher))
        let mappedToDomain = interpolate(normalizedRangeValue, lower: Double(domainLower), higher: Double(domainHigher))
        let clampedValue = clamp(mappedToDomain, lower: Double(domainLower), higher: Double(domainHigher))
        return Int(clampedValue)
    }
}
