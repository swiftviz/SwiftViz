import CloudKit
import Foundation
import Numerics

/// A collection of linear scales.
public enum LinearScale {
    /// A linear scale is created using a continuous input of type double converting to an output of type float.
    public struct DoubleScale: Scale {

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

        // MARK: - Double
        
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
    
    /// A linear scale is created using a continuous input of type float  converting to an output of type float.
    public struct FloatScale: Scale {

        public typealias InputType = Float
        public typealias OutputType = Float

        public let domainLower: Float
        public let domainHigher: Float
        public let domainExtent: Float

        public let isClamped: Bool
        public let desiredTicks: Int

        public init(from lower: Float, to higher: Float, isClamped: Bool = false, desiredTicks: Int = 10) {
            precondition(lower < higher)
            self.isClamped = isClamped
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        // MARK: - Float

        public func scale(_ domainValue: Float, from lower: Float, to higher: Float) -> Float {
                let normalizedInput = normalize(domainValue, lower: domainLower, higher: domainHigher)
                let result: InputType = interpolate(normalizedInput, lower: lower, higher: higher)
                // if we're clamped, constrain the output to the range
                let clampedValue = clamp(result, lower: lower, higher: higher)
                return clampedValue
            }

            public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> Float {
                // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
                let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
                let mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower, higher: domainHigher)
                let clampedValue = clamp(mappedToDomain, lower: domainLower, higher: domainHigher)
                return clampedValue
            }
    }
    
    /// A linear scale is created using a continuous input of type int  converting to an output of type float.
    public struct IntScale: Scale {

        public typealias InputType = Int
        public typealias OutputType = Float

        public let domainLower: Int
        public let domainHigher: Int
        public let domainExtent: Int

        public let isClamped: Bool
        public let desiredTicks: Int

        public init(from lower: Int, to higher: Int, isClamped: Bool = false, desiredTicks: Int = 10) {
            precondition(lower < higher)
            self.isClamped = isClamped
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        // MARK: - Int

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

        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> Int {
            // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
            let normalizedRangeValue = normalize(Double(rangeValue), lower: Double(lower), higher: Double(higher))
            let mappedToDomain = interpolate(normalizedRangeValue, lower: Double(domainLower), higher: Double(domainHigher))
            let clampedValue = clamp(mappedToDomain, lower: Double(domainLower), higher: Double(domainHigher))
            return Int(clampedValue)
        }
    }
    
}
