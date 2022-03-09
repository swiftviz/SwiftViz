import Foundation
import Numerics

// =============================================================
//  Scale.swift

// Inspired by D3's scale concept - maps input values (domain) to an output range (range)
// - https://github.com/d3/d3-scale
// - https://github.com/pshrmn/notes/blob/master/d3/scales.md

// .ticks(5) - hint to return 5 ticks - note this is just a hint, not a guarantee, and the specific number
// is determined by the scale's domain() values.
// - e.g. domain with 3 discrete values would would return 2 or 3 ticks?)
//
// D3's scale also has a .nice() function that does some pleasant rounding of the domain,
// extending it slightly so that it's nicer to view

/* Idea for structuring this from Tekl - inverting the generics on this and making the LinearScalable a protocol, and conform the types I'm interested in to those protocos:

 protocol LinearScalable {
     // whatever operations you need these things to do
 }

 struct LinearScale<T: LinearScalable> { … }

 extension Double: LinearScalable {}
 extension Float: LinearScalable {}
 extension Int: LinearScalable {}

 */

/// A collection of methods for dealing with data transformation when displaying against a scale.
public enum DomainDataTransform {
    /// Data processed against a scale isn't influenced by the scale's domain.
    case none
    /// Data processed against a scale is dropped if the value is outside of the scale's domain.
    case drop
    /// Data processed against a scale is clamped to the upper and lower values of the scale's domain.
    case clamp
}

/// A type that maps values from an input _domain_ to an output _range_ and provides generation and validation methods for values within those ranges.
public protocol Scale {
    associatedtype InputType: Numeric, Comparable, NiceValue
    associatedtype OutputType: Numeric, Comparable, NiceValue
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

    /// The number of ticks desired when creating the scale.
    ///
    /// This number may not match the number of ticks returned by ``Scale/ticks(_:range:)``.
    var desiredTicks: Int { get }

    /// A boolean value that indicates whether the output vales are constrained to the min and max of the output range.
    ///
    /// If `true`, values processed by the scale are constrained to the output range, and values processed backwards through the scale
    /// are constrained to the input domain.
    var transformType: DomainDataTransform { get }

    /// The range of input values
    var domainLower: InputType { get }
    var domainHigher: InputType { get }
    var domainExtent: InputType { get }

    /// Returns a Boolean value that indicates whether the value you provided is within the scale's domain.
    /// - Parameter value: The value to compare.
    /// - Returns: `true` if the value is between the lower and upper domain values.
    func domainContains(_ value: InputType) -> Bool

    /// Converts a value between the input _domain_ and output _range_.
    ///
    /// Before scaling the value, the scale may transform or drop the value based on the setting of ``Scale/transformType``.
    ///
    /// - Parameter inputValue: The value to be scaled.
    /// - Parameter from: The lower bounding value of the range to transform to.
    /// - Parameter to: The higher bounding value of the range to transform to.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func scale(_ domainValue: InputType, from: OutputType, to: OutputType) -> OutputType?

    /// Converts back from the output _range_ to a value within the input _domain_.
    ///
    /// The inverse of ``Scale/scale(_:from:to:)``.
    /// After converting the data back to the domain range, the scale may transform or drop the value based on the setting of ``Scale/transformType``.
    ///
    /// - Parameter rangeValue: The value to be scaled back from the range values to the domain.
    /// - Parameter from: The lower bounding value of the range to transform from.
    /// - Parameter to: The higher bounding value of the range to transform from.
    /// - Returns: a value within the bounds of the range values you provide, or `nil` if the value was dropped.
    func invert(_ rangeValue: OutputType, from: OutputType, to: OutputType) -> InputType?
}

public extension Scale {
    /// Processes a value against the scale, potentially constraining or dropping the value.
    ///
    /// The value is transformed based on the scale's ``Scale/transformType`` setting.
    /// | ``Scale/transformType`` | transform effect |
    /// | ------------------------ | --------- |
    /// | ``DomainDataTransform/none`` | The method doesn't adjusted or drop the value. |
    /// | ``DomainDataTransform/drop`` | Values outside the scale's domain are dropped. |
    /// | ``DomainDataTransform/clamp`` | Values outside the scale's domain are adjusted to match the highest or lowest values of the domain. |
    ///
    /// - Parameters:
    ///   - value: The value to transform against the domain of the scale.
    /// - Returns: An updated value, or `nil` if the value was dropped.
    func transformAgainstDomain(_ value: InputType) -> InputType? {
        switch transformType {
        case .none:
            return value
        case .drop:
            if value > domainHigher || value < domainLower {
                return nil
            }
            return value
        case .clamp:
            if value > domainHigher {
                return domainHigher
            } else if value < domainLower {
                return domainLower
            }
            return value
        }
    }
}

public extension Scale where OutputType: Real {
    /// Returns a Boolean value that indicates whether the value you provided is within the scale's domain.
    /// - Parameter value: The value to compare.
    /// - Returns: `true` if the value is between the lower and upper domain values.
    func domainContains(_ value: InputType) -> Bool {
        value >= domainLower && value <= domainHigher
    }

    /// Converts an array of values that matches the scale's input type to a list of ticks that are within the scale's domain.
    ///
    /// Used for manually specifying a series of ticks that you want to have displayed.
    ///
    /// Values presented for display that are *not* within the domain of the scale are dropped.
    /// Values that scale outside of the range you provide are adjusted based on the setting of ``Scale/transformType``.
    /// - Parameter inputValues: an array of values of the Scale's InputType
    /// - Parameter lower: The lower value of the range the scale maps to.
    /// - Parameter higher: The higher value of the range the scale maps to.
    /// - Returns: A list of tick values validated against the domain, and range based on the setting of ``Scale/transformType``
    func ticks(_ inputValues: [InputType], from lower: OutputType, to higher: OutputType) -> [Tick<InputType, OutputType>] {
        inputValues.compactMap { inputValue in
            if domainContains(inputValue),
               let rangeValue = scale(inputValue, from: lower, to: higher)
            {
                switch transformType {
                case .none:
                    return Tick(value: inputValue, location: rangeValue)
                case .drop:
                    if rangeValue > higher || rangeValue < lower {
                        return nil
                    }
                    return Tick(value: inputValue, location: rangeValue)
                case .clamp:
                    if rangeValue > higher {
                        return Tick(value: inputValue, location: higher)
                    } else if rangeValue < lower {
                        return Tick(value: inputValue, location: lower)
                    }
                    return Tick(value: inputValue, location: rangeValue)
                }
            }
            return nil
        }
    }

    /// Converts an array of values with matching strings, that are within the scale's domain and returns a list of tick labels using the strings you provide.
    ///
    /// Takes an set of labelled input values and returns the relevant set of TickLabels converted
    /// to the correct location values associated with the provided range.
    /// - Parameters:
    ///   - inputValues: A tuple of (InputValue, String) that is the labelled value
    ///   - range: a ClosedRange representing the representing
    ///   the range we are mapping the values into with the scale
    func labeledTickValues(_ inputValues: [(InputType, String)], from lower: OutputType, to higher: OutputType) -> [TickLabel<OutputType>] {
        inputValues.compactMap { inputTuple in
            let (inputValue, stringValue) = inputTuple
            if domainContains(inputValue) {
                if let location = scale(inputValue, from: lower, to: higher) {
                    switch transformType {
                    case .none:
                        return TickLabel(rangeLocation: location, value: stringValue)
                    case .drop:
                        if location > higher || location < lower {
                            return nil
                        }
                        return TickLabel(rangeLocation: location, value: stringValue)
                    case .clamp:
                        if location > higher {
                            return TickLabel(rangeLocation: higher, value: stringValue)
                        } else if location < lower {
                            return TickLabel(rangeLocation: lower, value: stringValue)
                        }
                        return TickLabel(rangeLocation: location, value: stringValue)
                    }
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
    func validatedTickLabels(_ inputTickLabels: [TickLabel<OutputType>], from lower: OutputType, to higher: OutputType) -> [TickLabel<OutputType>] {
        inputTickLabels.compactMap { tickLabel in
            guard let inputValue = invert(tickLabel.rangeLocation, from: lower, to: higher) else {
                return nil
            }
            if domainContains(inputValue) {
                return tickLabel
            }
            return nil
        }
    }
}

public extension Scale where InputType == Int, OutputType: Real {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    ///
    /// - Parameter range: a ClosedRange representing the representing the range we are mapping the values into with the scale
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(rangeLower: OutputType, rangeHigher: OutputType) -> [Tick<InputType, OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation)
            }
            return nil
        }
    }
}

public extension Scale where InputType == Float, OutputType: Real {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    ///
    /// - Parameter range: a ClosedRange representing the representing the range we are mapping the values into with the scale
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(rangeLower: OutputType, rangeHigher: OutputType) -> [Tick<InputType, OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, from: rangeLower, to: rangeHigher) {
                return Tick(value: tickValue, location: tickRangeLocation)
            }
            return nil
        }
    }
}

public extension Scale where InputType == Double, OutputType: Real {
    /// Returns an array of the locations within the output range to locate ticks for the scale.
    ///
    /// - Parameter range: a ClosedRange representing the representing the range we are mapping the values into with the scale
    /// - Returns: an Array of the values within the ClosedRange of range
    func ticks(rangeLower: OutputType, rangeHigher: OutputType) -> [Tick<InputType, OutputType>] {
        let tickValues = InputType.rangeOfNiceValues(min: domainLower, max: domainHigher, ofSize: desiredTicks)
        return tickValues.compactMap { tickValue in
            if let tickRangeLocation = scale(tickValue, from: rangeLower, to: rangeHigher),
               tickRangeLocation <= rangeHigher
            {
                return Tick(value: tickValue, location: tickRangeLocation)
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
// Power Scale
// Ordinal Scale
// Band Scale
// Point Scale

// MARK: - general functions used in various implementations of Scale

/// normalize(x, a ... b) takes a value x and normalizes it across the domain a...b
/// It returns the corresponding parameter within the range [0...1] if it was within the domain of the scale
/// If the value provided is outside of the domain of the scale, the resulting normalized value will be extrapolated
func normalize<T: Real>(_ x: T, lower: T, higher: T) -> T {
    precondition(lower < higher)
    let extent = higher - lower
    return (x - lower) / extent
}

// inspiration - https://github.com/d3/d3-interpolate#interpolateNumber
/// interpolate(a, b)(t) takes a parameter t in [0,1] and
/// returns the corresponding range value x in [a,b].
func interpolate<T: Real>(_ x: T, lower: T, higher: T) -> T {
    precondition(lower < higher)
    return lower * (1 - x) + higher * x
}
