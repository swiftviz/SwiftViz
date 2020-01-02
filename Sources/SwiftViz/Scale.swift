//
//  Scale.swift
//
//  Created by Joseph Heck on 4/19/19.
//

import Foundation

/// Inspired by D3's scale concept - maps input values (domain) to an output range (range)
/// - https://github.com/d3/d3-scale
/// - https://github.com/pshrmn/notes/blob/master/d3/scales.md

// NOTE(heckj): I'm trying to define a protocol for this, using Protocols and Associated Types
// I find it a bit confusing, although there's a pretty good article on it at
// https://www.hackingwithswift.com/articles/74/understanding-protocol-associated-types-and-their-constraints

public protocol Scale {
    associatedtype InputDomain: Comparable // input domain
    associatedtype OutputRange: Comparable // output range

    var isClamped: Bool { get }

    // input values
    var domain: ClosedRange<InputDomain> { get }

    // output values
    var range: ClosedRange<OutputRange> { get }

    /// converts a value between the input "domain" and output "range"
    ///
    /// - Parameter inputValue: a value within the bounds of the ClosedRange for domain
    /// - Returns: a value within the bounds of the ClosedRange for range, or NaN if it maps outside the bounds
    func scale(_ inputValue: InputDomain) -> OutputRange

    /// converts back from the output "range" to a value within the input "domain". The inverse of scale()
    ///
    /// - Parameter outputValue: a value within the bounds of the ClosedRange for range
    /// - Returns: a value within the bounds of the ClosedRange for domain, or NaN if it maps outside the bounds
    func invert(_ outputValue: OutputRange) -> InputDomain

    /// returns an array of the locations within the ClosedRange of range to locate ticks for the scale
    ///
    /// - Parameter count: a number of ticks to display, defaulting to 10
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(count: Int) -> [OutputRange]
}

// NOTE(heckj): OTHER SCALES: make a PowScale (& maybe Sqrt, Log, Ln)

// Quantize scale: Quantize scales use a discrete range and a continuous domain.
//   Range mapping is done by dividing the domain domain evenly by the number of elements
//   in the range. Because the range is discrete, the values do not have to be numbers.

// Quantile scale: Quantile scales are similar to quantize scales, but instead of evenly
//   dividing the domain, they determine threshold values based on the domain that are
//   used as the cutoffs between values in the range.
//   Quantile scales take an array of values for a domain (not just a lower and upper limit)
//   and maps range to be an even distribution over the input domain

// Threshold Scale

// Time Scale
// - https://github.com/d3/d3-scale/blob/master/src/time.js
// - D3 has a time format (https://github.com/d3/d3-time-format), but we can probably use
//   IOS/MacOS NSTime, NSDate formatters and calendrical mechanisms

// Ordinal Scale
// Band Scale
// Point Scale

// MARK: - general functions used in various implementations of Scale

/// normalize(a, b)(x) takes a domain value x in [a,b] and returns the corresponding parameter t in [0,1].
func normalize(_ x: Double, domain: ClosedRange<Double>) -> Double {
    if domain.contains(x) {
        let overallDistance = domain.upperBound - domain.lowerBound
        let foo = (x - domain.lowerBound) / overallDistance
        return foo
    }
    return Double.nan
}

// inspiration - https://github.com/d3/d3-interpolate#interpolateNumber
/// interpolate(a, b)(t) takes a parameter t in [0,1] and returns the corresponding range value x in [a,b].
func interpolate(_ x: Double, range: ClosedRange<Double>) -> Double {
    range.lowerBound * (1 - x) + range.upperBound * x
}
