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

        public var transformType: DomainDataTransform
        public let desiredTicks: Int

        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        // MARK: - Double

        public func scale(_ domainValue: Double, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let normalizedInput = normalize(domainValue, lower: domainLower, higher: domainHigher)
                let result: InputType = interpolate(normalizedInput, lower: Double(lower), higher: Double(higher))
                return Float(result)
            }
            return nil
        }

        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> Double? {
            // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
            let normalizedRangeValue = normalize(Double(rangeValue), lower: Double(lower), higher: Double(higher))
            let mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower, higher: domainHigher)
            return transformAgainstDomain(mappedToDomain)
        }
    }

    /// A linear scale is created using a continuous input of type float  converting to an output of type float.
    public struct FloatScale: Scale {
        public typealias InputType = Float
        public typealias OutputType = Float

        public let domainLower: Float
        public let domainHigher: Float
        public let domainExtent: Float

        public var transformType: DomainDataTransform
        public let desiredTicks: Int

        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        // MARK: - Float

        public func scale(_ domainValue: Float, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let normalizedInput = normalize(domainValue, lower: domainLower, higher: domainHigher)
                let result: InputType = interpolate(normalizedInput, lower: lower, higher: higher)
                return result
            }
            return nil
        }

        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> Float? {
            // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
            let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
            let mappedToDomain = interpolate(normalizedRangeValue, lower: domainLower, higher: domainHigher)
            return transformAgainstDomain(mappedToDomain)
        }
    }

    /// A linear scale is created using a continuous input of type int  converting to an output of type float.
    public struct IntScale: Scale {
        public typealias InputType = Int
        public typealias OutputType = Float

        public let domainLower: Int
        public let domainHigher: Int
        public let domainExtent: Int

        public var transformType: DomainDataTransform
        public let desiredTicks: Int

        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        // MARK: - Int

        public func scale(_ domainValue: Int, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let convertedDomain = Float(domainValue)
                let convertedDomainLower = Float(Int(domainLower))
                let convertedDomainHigher = Float(Int(domainHigher))
                let normalizedInput = normalize(convertedDomain, lower: convertedDomainLower, higher: convertedDomainHigher)
                let result = interpolate(normalizedInput, lower: Float(lower), higher: Float(higher))
                return result
            }
            return nil
        }

        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> Int? {
            // inverts the scale, taking a value in the output range and returning the relevant value from the input domain
            let normalizedRangeValue = normalize(Double(rangeValue), lower: Double(lower), higher: Double(higher))
            let mappedToDomain = interpolate(normalizedRangeValue, lower: Double(domainLower), higher: Double(domainHigher))
            return transformAgainstDomain(Int(mappedToDomain))
        }
    }
    
    // MARK: - Factory (convenience) Methods
    
    // Double
    
    /// Creates a linear scale that maps values between the lower and upper bounds you provide.
    /// - Parameters:
    ///   - low: The lower bounds of the domain.
    ///   - high: The upper bounds of the domain.
    public static func create(_ low: Double, _ high: Double) -> LinearScale.DoubleScale {
        LinearScale.DoubleScale(from: low, to: high)
    }

    /// Creates a linear scale that maps values within the range you provide.
    /// - Parameter range: The range of the domain.
    public static func create(_ range: ClosedRange<Double>) -> LinearScale.DoubleScale {
        LinearScale.DoubleScale(from: range.lowerBound, to: range.upperBound)
    }
    
    /// Creates a linear scale that maps values from 0 to the upper bound you provide.
    /// - Parameter high: The upper bounds of the domain.
    public static func create(_ high: Double) -> LinearScale.DoubleScale {
        LinearScale.DoubleScale(from: 0, to: high)
    }
    
    /// Creates a linear scale for dates that maps values between the lower and upper bounds you provide.
    /// - Parameters:
    ///   - low: The lower bounds of the domain.
    ///   - high: The upper bounds of the domain.
    public static func create(_ low: Date, _ high: Date) -> LinearScale.DoubleScale {
        LinearScale.DoubleScale(from: low.timeIntervalSince1970, to: high.timeIntervalSince1970)
    }
    
    /// Creates a linear scale for dates that maps values within the range you provide.
    /// - Parameter range: The range of the domain.
    public static func create(_ range: ClosedRange<Date>) -> LinearScale.DoubleScale {
        LinearScale.DoubleScale(from: range.lowerBound.timeIntervalSince1970, to: range.upperBound.timeIntervalSince1970)
    }

    // Float

    /// Creates a linear scale that maps values between the lower and upper bounds you provide.
    /// - Parameters:
    ///   - low: The lower bounds of the domain.
    ///   - high: The upper bounds of the domain.
    public static func create(_ low: Float, _ high: Float) -> LinearScale.FloatScale {
        LinearScale.FloatScale(from: low, to: high)
    }

    /// Creates a linear scale that maps values within the range you provide.
    /// - Parameter range: The range of the domain.
    public static func create(_ range: ClosedRange<Float>) -> LinearScale.FloatScale {
        LinearScale.FloatScale(from: range.lowerBound, to: range.upperBound)
    }

    /// Creates a linear scale that maps values from 0 to the upper bound you provide.
    /// - Parameter high: The upper bounds of the domain.
    public static func create(_ high: Float) -> LinearScale.FloatScale {
        LinearScale.FloatScale(from: 0, to: high)
    }

    // Int

    /// Creates a linear scale that maps values between the lower and upper bounds you provide.
    /// - Parameters:
    ///   - low: The lower bounds of the domain.
    ///   - high: The upper bounds of the domain.
    public static func create(_ low: Int, _ high: Int) -> LinearScale.IntScale {
        LinearScale.IntScale(from: low, to: high)
    }

    /// Creates a linear scale that maps values from 0 to the upper bound you provide.
    /// - Parameter high: The upper bounds of the domain.
    public static func create(_ high: Int) -> LinearScale.IntScale {
        LinearScale.IntScale(from: 0, to: high)
    }

    /// Creates a linear scale that maps values within the range you provide.
    /// - Parameter range: The range of the domain.
    public static func create(_ range: ClosedRange<Int>) -> LinearScale.IntScale {
        LinearScale.IntScale(from: range.lowerBound, to: range.upperBound)
    }


}
