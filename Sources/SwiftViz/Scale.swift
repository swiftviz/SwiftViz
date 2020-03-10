import CoreGraphics
import Foundation

// =============================================================
//  Scale.swift

/// Inspired by D3's scale concept - maps input values (domain) to an output range (range)
/// - https://github.com/d3/d3-scale
/// - https://github.com/pshrmn/notes/blob/master/d3/scales.md

// in d3, it's used like:
//  someScale()
//    .domain([....])
//    .range([....])

// .ticks(5) - hint to return 5 ticks - note this is just a hint, not a guarantee, and is
// determined by the scale's domain() values
// - e.g. domain with 3 discrete values would would return 2 or 3 ticks?)

// D3's scale also has a .nice() function that does some pleasant rounding of the domain,
// extending it slightly so that it's nicer to view
public protocol ScaleInputType {
    associatedtype InputType: Comparable
    // sequency, comparable thing
}

public protocol Scale: ScaleInputType {
    associatedtype TickType: Tick
    // this becomes a generic focused protocol - types implementing it will need to define the
    // protocol conformance in coordination with a generic type

    // clamped constrains the output mapping through the input domain to the output range so that it's always
    // inside the outputRange
    var isClamped: Bool { get }

    // input values
    var domain: ClosedRange<InputType> { get }
    // a variant of this might want to use ClosedRange<Int> - or maybe something that isn't even a range...

    // output values
    // var range: ClosedRange<Double> { get }

    /// converts a value between the input "domain" and output "range"
    ///
    /// - Parameter inputValue: a value within the bounds of the
    ///   ClosedRange for domain
    /// - Parameter range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale
    /// - Returns: a value within the bounds of the ClosedRange
    ///   for range, or NaN if it maps outside the bounds
    func scale(_ inputValue: InputType, range: ClosedRange<CGFloat>) -> CGFloat

    /// converts back from the output "range" to a value within
    /// the input "domain". The inverse of scale()
    ///
    /// - Parameter outputValue: a value within the bounds of the
    ///   ClosedRange for range
    /// - Parameter range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale
    /// - Returns: a value within the bounds of the ClosedRange
    ///   for domain, or NaN if it maps outside the bounds
    func invert(_ outputValue: CGFloat, range: ClosedRange<CGFloat>) -> InputType

    /// returns an array of the locations within the ClosedRange of
    /// range to locate ticks for the scale
    ///
    /// - Parameter count: a number of ticks to display, defaulting to 10
    /// - Parameter range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(count: Int, range: ClosedRange<CGFloat>) -> [TickType]

    /// Converts an array of values of the Scale's InputType into a set of Ticks.
    /// Used for manually specifying a series of ticks that you want to have displayed.
    /// - Parameter inputValues: an array of values of the Scale's InputType
    /// - Parameter range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale
    func ticks(_ inputValues: [InputType], range: ClosedRange<CGFloat>) -> [TickType]
}

// NOTE(heckj): commented out while I work on figuring out the correct way to use generics
// and protocols here. The code for `ticks` works above, but the implementation is fundamentally
// the same in all instances... so it feels like it should be perfect for a generic implementation.
// However, I keep running afoul of the compiler not being able to determine that the relevant
// underlying type used by the protocols is the *same* type.
//
// extension Scale {
//
//    /// Converts an array of values of the Scale's InputType into a set of Ticks.
//    /// Used for manually specifying a series of ticks that you want to have displayed.
//    /// - Parameter inputValues: an array of values of the Scale's InputType
//    /// - Parameter range: a ClosedRange representing the representing
//    ///   the range we are mapping the values into with the scale
//    func genericTicks(_ inputValues:[InputType], range: ClosedRange<CGFloat>) -> [TickType] {
//        inputValues.map { inputValue in
//            /* getting the error here:
//
//             Cannot convert value of type 'Self.InputType'
//             (associated type of protocol 'ScaleInputType') to expected argument type
//             'Self.TickType.InputType' (associated type of protocol 'ScaleInputType')
//
//             Fundamentally, the InputTypes aren't known to the be the same to the compiler, so I get
//             why it's telling me this isn't cool. But what I'm not sure of is how to get appropriately
//             tell the compiler they're related.
//
//             I've externalized the typealias for the two protocols so they both "inherit" from
//             the same base protocol, but this doesn't seem to be sufficient to link them for the
//             compiler.
//
//             Can I layer/nest the protocols together so that they use the same associated types?
//             */
//            TickType.init(value: inputValue,
//                          location: scale(inputValue, range: range))
//        }
//
//    }
// }

// NOTE(heckj): OTHER SCALES: make a PowScale (& maybe Sqrt, Log, Ln)

// Quantize scale: Quantize scales use a discrete range and a
// continuous domain. Range mapping is done by dividing the domain
// evenly by the number of elements in the range. Because the range
// is discrete, the values do not have to be numbers.

// Quantile scale: Quantile scales are similar to quantize scales,
// but instead of evenly dividing the domain, they determine threshold
// values based on the domain that are used as the cutoffs between
// values in the range. Quantile scales take an array of values for a
// domain (not just a lower and upper limit) and maps range to be an
// even distribution over the input domain

// Threshold Scale
// Ordinal Scale
// Band Scale
// Point Scale

// MARK: - general functions used in various implementations of Scale

/// normalize(a, b)(x) takes a domain value x in [a,b]
/// and returns the corresponding parameter t in [0,1].
func normalize(_ x: CGFloat, domain: ClosedRange<CGFloat>) -> CGFloat {
    if domain.contains(x) {
        let overallDistance = domain.upperBound - domain.lowerBound
        let foo = (x - domain.lowerBound) / overallDistance
        return foo
    }
    return CGFloat.nan
}

// inspiration - https://github.com/d3/d3-interpolate#interpolateNumber
/// interpolate(a, b)(t) takes a parameter t in [0,1] and
/// returns the corresponding range value x in [a,b].
func interpolate(_ x: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
    range.lowerBound * (1 - x) + range.upperBound * x
}
