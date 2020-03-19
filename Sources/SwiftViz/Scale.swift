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
public protocol Scale {
    associatedtype InputType: Comparable
    associatedtype TickType: Tick
    // this becomes a generic focused protocol - types implementing it will need to define the
    // protocol conformance in coordination with a generic type

    /*
     tape("linear.clamp(true) restricts output values to the range", function(test) {
       test.equal(d3.scale.linear().clamp(true).range([10, 20])(2), 20);
       test.equal(d3.scale.linear().clamp(true).range([10, 20])(-1), 10);
       test.end();
     });

     tape("linear.clamp(true) restricts input values to the domain", function(test) {
       test.equal(d3.scale.linear().clamp(true).range([10, 20]).invert(30), 1);
       test.equal(d3.scale.linear().clamp(true).range([10, 20]).invert(0), 0);
       test.end();
     });
     */

    // clamped forces constraints on both the domain and the range. Any scaled values
    // will be constrained the output range, and any inverted values will be constrained
    // to the input domain.
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
}

extension ClosedRange {
    public func constrainedToRange(_ value: Bound) -> Bound {
        if (value > self.upperBound) {
            return self.upperBound
        }
        if (value < self.lowerBound) {
            return self.lowerBound
        }
        return value
    }
}

extension Scale {
    // returns the a constrained value to the provided IF isClamped is true
    public func clampDomain(_ value: InputType, withinRange: ClosedRange<InputType>) -> InputType {
        if (self.isClamped) {
            return withinRange.constrainedToRange(value)
        }
        return value
    }
    
    public func clampRange(_ value: CGFloat, withinRange: ClosedRange<CGFloat>) -> CGFloat {
        if (self.isClamped) {
            return withinRange.constrainedToRange(value)
        }
        return value
    }
}

extension Scale where InputType == TickType.InputType {
    /// Converts an array of values of the Scale's InputType into a set of Ticks.
    /// Used for manually specifying a series of ticks that you want to have displayed.
    ///
    /// Any values presented for display that are *not* within the domain of the scale
    /// are ignored and dropped.
    /// - Parameter inputValues: an array of values of the Scale's InputType
    /// - Parameter range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale
    public func ticks(_ inputValues: [InputType], range: ClosedRange<CGFloat>) -> [TickType] {
        inputValues.compactMap { inputValue in
            if domain.contains(inputValue) {
                return TickType(value: inputValue,
                                location: scale(inputValue, range: range))
            }
            return nil
        }
    }

    /// Takes an set of labelled input values and returns the relevant set of TickLabels converted
    /// to the correct location values associated with the provided range.
    /// - Parameters:
    ///   - inputValues: A tuple of (InputValue, String) that is the labelled value
    ///   - range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale
    public func labeledTickValues(_ inputValues: [(InputType, String)], range: ClosedRange<CGFloat>) -> [TickLabel] {
        inputValues.compactMap { inputTuple in
            let (inputValue, stringValue) = inputTuple
            if domain.contains(inputValue) {
                let location = scale(inputValue, range: range)
                if !location.isNaN {
                    return TickLabel(rangeLocation: location, value: stringValue)
                }
            }
            return nil
        }
    }

    /// Validates a set of TickLabels against a given scale, removing any that don't match the scale's domain.
    ///
    /// - Parameter inputTickLabels: an array of TickLabels to validate against the scale
    /// - Parameter range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale.
    public func validatedTickLabels(_ inputTickLabels: [TickLabel], range: ClosedRange<CGFloat>) -> [TickLabel] {
        inputTickLabels.compactMap { tick in
            let inputValue = invert(tick.rangeLocation, range: range)
            if domain.contains(inputValue) {
                return tick
            }
            return nil
        }
    }
}

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

/// normalize(x, a ... b) takes a value x and normalizes it across the domain a...b
/// It returns the corresponding parameter within the range [0...1] if it was within the domain of the scale
/// If the value provided is outside of the domain of the scale, the resulting normalized value will be extrapolated
func normalize(_ x: CGFloat, domain: ClosedRange<CGFloat>) -> CGFloat {
        let rangeDistance = domain.upperBound - domain.lowerBound
        return (x - domain.lowerBound) / rangeDistance
}

// inspiration - https://github.com/d3/d3-interpolate#interpolateNumber
/// interpolate(a, b)(t) takes a parameter t in [0,1] and
/// returns the corresponding range value x in [a,b].
func interpolate(_ x: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
    range.lowerBound * (1 - x) + range.upperBound * x
}
