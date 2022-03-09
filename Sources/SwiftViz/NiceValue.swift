//
//  NiceNumber.swift
//  
//
//  Created by Joseph Heck on 3/7/22.
//

import Foundation
import Numerics

public protocol NiceValue {
    associatedtype NumberType: Numeric, Comparable
    /// Returns a nice version of the number that's visually appealing for chart axis values.
    /// - Parameters:
    ///   - number: The number to convert into a nice value.
    ///   - min: A Boolean value that indicates to take the lower, rather than higher, nearest nice number as a result.
    static func niceVersion(for number: NumberType, min: Bool) -> NumberType
    
    /// Returns a nice minimum value for a given range.
    ///
    /// The value returned will be lower than or equal to the minimum value of the range.
    /// The algorithm returns `0` if the top of the range is sufficiently larger than the bottom, and the range doesn't extend into negative values.
    /// - Parameters:
    ///   - min: The minimum value of the range.
    ///   - max: The maximum value of the range.
    static func niceMinimumValueForRange(min: NumberType, max: NumberType) -> NumberType
    
    /// Generates a range of numbers with a minimum, maximum, and step interval that's visually pleasing.
    ///
    /// The values are based on "Nice Numbers for Graph Labels"  in the book "Graphics Gems, Volume 1" by Andrew Glassner.
    /// Examples of this algorithm are also available on StackOverflow as [nice label algorithm for charts with minimum ticks](https://stackoverflow.com/questions/8506881/nice-label-algorithm-for-charts-with-minimum-ticks).
    ///
    /// - Parameters:
    ///   - min: The minimum value of a range of numbers.
    ///   - max: The maximum value of a range of numbers.
    ///   - size: The number of tick marks desired in the resulting range.
    /// - Returns: An array of nice numbers linearly spaced through the range, with the min and max equaling or exceeding the values you provide.
    static func rangeOfNiceValues(min: NumberType, max: NumberType, ofSize size: Int) -> [NumberType]
}

// MARK: - Double

extension Double: NiceValue {
    public typealias NumberType = Double

    public static func niceVersion(for number: NumberType, min: Bool) -> NumberType {
        let negativeInput: Bool = number < 0
        let positiveNumber = abs(number)
        let exponent = floor(log10(positiveNumber))
        let fraction = positiveNumber / pow(10, exponent)
        let niceFraction: NumberType

        if min {
            if fraction <= 1.5 {
                niceFraction = 1
            } else if fraction <= 3 {
                niceFraction = 2
            } else if fraction <= 7 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        } else {
            if fraction <= 1 {
                niceFraction = 1
            } else if fraction <= 2 {
                niceFraction = 2
            } else if fraction <= 5 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        }
        if negativeInput {
            return -1.0 * niceFraction * pow(10, exponent)
        }
        return niceFraction * pow(10, exponent)
    }
    
    public static func niceMinimumValueForRange(min: NumberType, max: NumberType) -> NumberType {
        let negativeMinValue = min < 0
        let nice = niceVersion(for: min, min: !negativeMinValue)
        if negativeMinValue {
            // if the minimum value is below 0, then
            // round it further negative to the next "nice" number
            return nice
        }
        // Otherwise, compare nice against the upper range, and if it's smaller
        // than 10% of the extent of the range, round it down to 0.
        return nice <= (max / 10) ? 0 : nice
    }
    
    public static func rangeOfNiceValues(min: NumberType, max: NumberType, ofSize size: Int) -> [NumberType] {
        precondition(size > 1)
        let niceMin = niceMinimumValueForRange(min: min, max: max)
        // print("niced min: \(niceMin)")
        let step = (max - niceMin) / NumberType(size - 1)
        // print("step: \(step)")
        let niceStep = niceVersion(for: step, min: false)
        // print("niced step: \(niceStep)")
        var niceMax = niceVersion(for: max+niceStep, min: true)
        // print("niced max: \(niceMax)")
        // niceMax should never be below the provided 'max' value, so increment by the
        // calculated step value until it's above it:
        while niceMax < max {
            niceMax += niceStep
        }
        
        var result:[NumberType] = []
        // incrementing the comparison point by a half step
        // prevents some slight rounding errors that could lead
        // to a final value not getting appendded.
        let comparisonPoint = niceMax + (0.5 * niceStep)
        result.append(niceMin)
        for i in 1...size - 1 {
            let steppedValue = niceMin + Double(i) * niceStep
            if (steppedValue <= comparisonPoint) {
                result.append(steppedValue)
            } else {
                break
            }
        }
        return result
    }
}

// MARK: - Float

extension Float: NiceValue {
    public typealias NumberType = Float
    public static func niceVersion(for number: NumberType, min: Bool) -> NumberType {
        let negativeInput: Bool = number < 0
        let positiveNumber = abs(number)
        let exponent = floor(log10(positiveNumber))
        let fraction = positiveNumber / pow(10, exponent)
        let niceFraction: NumberType

        if min {
            if fraction <= 1.5 {
                niceFraction = 1
            } else if fraction <= 3 {
                niceFraction = 2
            } else if fraction <= 7 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        } else {
            if fraction <= 1 {
                niceFraction = 1
            } else if fraction <= 2 {
                niceFraction = 2
            } else if fraction <= 5 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        }
        if negativeInput {
            return -1.0 * niceFraction * pow(10, exponent)
        }
        return niceFraction * pow(10, exponent)
    }

    public static func niceMinimumValueForRange(min: NumberType, max: NumberType) -> NumberType {
        let negativeMinValue = min < 0
        let nice = niceVersion(for: min, min: !negativeMinValue)
        if negativeMinValue {
            // if the minimum value is below 0, then
            // round it further negative to the next "nice" number
            return nice
        }
        // Otherwise, compare nice against the upper range, and if it's smaller
        // than 10% of the extent of the range, round it down to 0.
        return nice <= (max / 10) ? 0 : nice
    }
    
    public static func rangeOfNiceValues(min: NumberType, max: NumberType, ofSize size: Int) -> [NumberType] {
        precondition(size > 1)
        let niceMin = niceMinimumValueForRange(min: min, max: max)
        // print("niced min: \(niceMin)")
        let step = (max - niceMin) / NumberType(size - 1)
        // print("step: \(step)")
        let niceStep = niceVersion(for: step, min: false)
        // print("niced step: \(niceStep)")
        var niceMax = niceVersion(for: max+niceStep, min: true)
        // niceMax should never be below the provided 'max' value, so increment by the
        // calculated step value until it's above it:
        while niceMax < max {
            niceMax += niceStep
        }
        
        var result:[NumberType] = []
        // incrementing the comparison point by a half step
        // prevents some slight rounding errors that could lead
        // to a final value not getting appendded.
        let comparisonPoint = niceMax + (0.5 * niceStep)
        result.append(niceMin)
        for i in 1...size - 1 {
            let steppedValue = niceMin + Float(i) * niceStep
            if (steppedValue <= comparisonPoint) {
                result.append(steppedValue)
            } else {
                break
            }
        }
        print(result)
        return result
    }
}

// MARK: - Int

extension Int: NiceValue {
    public typealias NumberType = Int
    
    public static func niceVersion(for number: NumberType, min: Bool) -> NumberType {
        let negativeInput: Bool = number < 0
        let positiveNumber = abs(number)

        let exponent = floor(log10(Double(positiveNumber)))
        let fraction = Double(number) / pow(10, exponent)
        let niceFraction: Double

        if min {
            if fraction <= 1.5 {
                niceFraction = 1
            } else if fraction <= 3 {
                niceFraction = 2
            } else if fraction <= 7 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        } else {
            if fraction <= 1 {
                niceFraction = 1
            } else if fraction <= 2 {
                niceFraction = 2
            } else if fraction <= 5 {
                niceFraction = 5
            } else {
                niceFraction = 10
            }
        }
        if negativeInput {
            return Int(-1.0 * niceFraction * pow(10, exponent))
        }
        return Int(niceFraction * pow(10, exponent))
    }
    
    public static func niceMinimumValueForRange(min: NumberType, max: NumberType) -> NumberType {
        let negativeMinValue = min < 0
        let nice = niceVersion(for: min, min: !negativeMinValue)
        if negativeMinValue {
            // if the minimum value is below 0, then
            // round it further negative to the next "nice" number
            return nice
        }
        // Otherwise, compare nice against the upper range, and if it's smaller
        // than 10% of the extent of the range, round it down to 0.
        return nice <= (max / 10) ? 0 : nice
    }

    public static func rangeOfNiceValues(min: NumberType, max: NumberType, ofSize size: Int) -> [NumberType] {
        precondition(size > 1)
        let niceMin = niceMinimumValueForRange(min: min, max: max)
        // print("niced min: \(niceMin)")
        let step = (max - niceMin) / NumberType(size - 1)
        // print("step: \(step)")
        let niceStep = niceVersion(for: step, min: false)
        // print("niced step: \(niceStep)")
        var niceMax = niceVersion(for: max+niceStep, min: true)
        // niceMax should never be below the provided 'max' value, so increment by the
        // calculated step value until it's above it:
        while niceMax < max {
            niceMax += niceStep
        }
        
        var result:[NumberType] = []
        result.append(niceMin)
        for i in 1...size - 1 {
            result.append(niceMin + i * Int(niceStep))
        }
        return result
    }
}
