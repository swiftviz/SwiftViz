//
//  LogScale.swift
//
//  Created by Joseph Heck on 3/3/20.

import Foundation
import Numerics

/// A collection of logrithmic scales.
public enum LogScale {
    /// A logrithmic scale created with a continuous input domain that provides methods to convert values within that domain to an output range.
    public struct DoubleScale: Scale {
        public typealias InputType = Double
        public typealias OutputType = Float

        public let domainLower: InputType
        public let domainHigher: InputType
        public let domainExtent: InputType

        public let transformType: DomainDataTransform
        public let desiredTicks: Int

        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            precondition(lower > 0.0)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        /// scales the input value (within domain) per the scale
        /// to the relevant output (using range)
        ///
        /// - Parameter x: value within the domain
        /// - Returns: scaled value
        public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let logDomainValue = log10(domainValue)
                let logDomainLower = log10(domainLower)
                let logDomainHigher = log10(domainHigher)
                let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
                let valueMappedToRange = interpolate(Float(normalizedValueOnLogDomain), lower: lower, higher: higher)
                return valueMappedToRange
            }
            return nil
        }

        /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> InputType? {
            let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
            let logDomainLower = log10(domainLower)
            let logDomainHigher = log10(domainHigher)
            let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
            let domainValue = pow(10, linearInterpolatedValue)
            return transformAgainstDomain(domainValue)
        }
    }
    
    public struct FloatScale: Scale {
        public typealias InputType = Float
        public typealias OutputType = Float

        public let domainLower: InputType
        public let domainHigher: InputType
        public let domainExtent: InputType

        public let transformType: DomainDataTransform
        public let desiredTicks: Int

        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            precondition(lower > 0.0)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        /// scales the input value (within domain) per the scale
        /// to the relevant output (using range)
        ///
        /// - Parameter x: value within the domain
        /// - Returns: scaled value
        public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let logDomainValue = log10(domainValue)
                let logDomainLower = log10(domainLower)
                let logDomainHigher = log10(domainHigher)
                let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
                let valueMappedToRange = interpolate(Float(normalizedValueOnLogDomain), lower: lower, higher: higher)
                return valueMappedToRange
            }
            return nil
        }

        /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> InputType? {
            let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
            let logDomainLower = log10(domainLower)
            let logDomainHigher = log10(domainHigher)
            let linearInterpolatedValue = interpolate(Float(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
            let domainValue = pow(10, linearInterpolatedValue)
            return transformAgainstDomain(domainValue)
        }
    }
    
    public struct IntScale: Scale {
        public typealias InputType = Int
        public typealias OutputType = Float

        public let domainLower: InputType
        public let domainHigher: InputType
        public let domainExtent: InputType

        public let transformType: DomainDataTransform
        public let desiredTicks: Int

        public init(from lower: InputType, to higher: InputType, transform: DomainDataTransform = .none, desiredTicks: Int = 10) {
            precondition(lower < higher)
            precondition(lower > 0)
            transformType = transform
            domainLower = lower
            domainHigher = higher
            domainExtent = higher - lower
            self.desiredTicks = desiredTicks
        }

        /// scales the input value (within domain) per the scale
        /// to the relevant output (using range)
        ///
        /// - Parameter x: value within the domain
        /// - Returns: scaled value
        public func scale(_ domainValue: InputType, from lower: Float, to higher: Float) -> Float? {
            if let domainValue = transformAgainstDomain(domainValue) {
                let logDomainValue = log10(Double(domainValue))
                let logDomainLower = log10(Double(domainLower))
                let logDomainHigher = log10(Double(domainHigher))
                let normalizedValueOnLogDomain = normalize(logDomainValue, lower: logDomainLower, higher: logDomainHigher)
                let valueMappedToRange = interpolate(Float(normalizedValueOnLogDomain), lower: lower, higher: higher)
                return valueMappedToRange
            }
            return nil
        }

        /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
        public func invert(_ rangeValue: Float, from lower: Float, to higher: Float) -> InputType? {
            let normalizedRangeValue = normalize(rangeValue, lower: lower, higher: higher)
            let logDomainLower = log10(Double(domainLower))
            let logDomainHigher = log10(Double(domainHigher))
            let linearInterpolatedValue = interpolate(Double(normalizedRangeValue), lower: logDomainLower, higher: logDomainHigher)
            let domainValue = pow(10, linearInterpolatedValue)
            return transformAgainstDomain(Int(domainValue))
        }
    }
}
