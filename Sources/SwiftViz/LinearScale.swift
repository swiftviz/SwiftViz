import CoreGraphics
import Foundation

// =============================================================
//  LinearScale.swift

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
public struct LinearScale: Scale {
    public typealias InputType = CGFloat
    public typealias TickType = CGFloatTick

    public let isClamped: Bool
    public let domain: ClosedRange<CGFloat>

    public init(domain: ClosedRange<CGFloat>, isClamped: Bool = false) {
        self.isClamped = isClamped
        self.domain = domain
    }

    /// scales the input value (within domain) per the scale
    /// to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ inputValue: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        let result = interpolate(normalize(inputValue, domain: domain), range: range)
        // if we're clamped, constrain the output to the range
        return clamp(result, within: range)
    }

    /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
    public func invert(_ outputValue: CGFloat, range: ClosedRange<CGFloat>) -> CGFloat {
        let result = interpolate(normalize(outputValue, domain: range), range: domain)
        // if we're clamped, constrain the output to the domain
        return clamp(result, within: domain)
    }

    /// returns an array of the locations of ticks - (value, location)
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(count: Int = 10, range: ClosedRange<CGFloat>) -> [CGFloatTick] {
        var result: [CGFloatTick] = Array()
        for i in stride(from: 0, through: count, by: 1) {
            let tickDomainValue = interpolate(CGFloat(i) / CGFloat(count), range: domain)
            result.append(CGFloatTick(value: tickDomainValue,
                                      location: scale(tickDomainValue, range: range)))
        }
        return result
    }
}
