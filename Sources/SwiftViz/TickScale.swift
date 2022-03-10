//
//  TickScale.swift
//
//
//  Created by Joseph Heck on 3/10/22.
//

import Foundation
import Numerics

/// A type of scale that provides tick values from the domain it represents.
public protocol TickScale: Scale {
    /// The number of ticks desired when creating the scale.
    ///
    /// This number may not match the number of ticks returned by ``TickScale/ticks(_:from:to:)``
    var desiredTicks: Int { get }
}

public extension TickScale where OutputType: Real {
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

public extension TickScale where InputType == Int, OutputType: Real {
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

public extension TickScale where InputType == Float, OutputType: Real {
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

public extension TickScale where InputType == Double, OutputType: Real {
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
