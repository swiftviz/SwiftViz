import CloudKit
import Foundation
import Numerics

// =============================================================
//  LinearScale.swift

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
public struct LinearScale: Scale {
    public typealias InputType = Double
    public typealias OutputType = Float

    public let domainLower: Double
    public let domainHigher: Double
    public let domainExtent: Double

    public let isClamped: Bool
    public let desiredTicks: Int

    public init(from lower: Double, to higher: Double, isClamped: Bool = false, desiredTicks: Int = 10) {
        precondition(lower < higher)
        self.isClamped = isClamped
        domainLower = lower
        domainHigher = higher
        domainExtent = higher - lower
        self.desiredTicks = desiredTicks
    }

    public func scale(_ domainValue: Double, from lower: Float, to higher: Float) -> Float {
        let normalizedInput = normalize(domainValue, lower: domainLower, higher: domainHigher)
        let result: InputType = interpolate(normalizedInput, lower: Double(lower), higher: Double(higher))
        // if we're clamped, constrain the output to the range
        let clampedValue = clamp(result, lower: Double(lower), higher: Double(higher))
        return Float(clampedValue)
    }

    public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> Double {
        // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        let normalizedRangeValue = normalize(Double(rangeValue), lower: Double(lower), higher: Double(higher))
        let mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower, higher: domainHigher)
        let clampedValue = clamp(mappedToDomain, lower: domainLower, higher: domainHigher)
        return clampedValue
    }
}
