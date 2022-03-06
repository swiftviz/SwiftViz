import Numerics
import Foundation

// =============================================================
//  LinearScale.swift

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
public struct LinearScale<InputType: Real>: Scale {
    public typealias TickType = Tick<InputType, OutputType>

    public let isClamped: Bool
    public let domain: ClosedRange<InputType>
    public let desiredTicks: Int

    public init(domain: ClosedRange<InputType>, isClamped: Bool = false, desiredTicks: Int = 10) {
        self.isClamped = isClamped
        self.domain = domain
        self.desiredTicks = desiredTicks
    }

    /// scales the input value (within domain) per the scale
    /// to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ inputValue: InputType, range: ClosedRange<InputType>) -> InputType {
        let result = interpolate(normalize(inputValue, domain: domain), range: range)
        // if we're clamped, constrain the output to the range
        return clamp(result, within: range)
    }

    /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
    public func invert(_ outputValue: InputType, range: ClosedRange<InputType>) -> InputType {
        let result = interpolate(normalize(outputValue, domain: range), range: domain)
        // if we're clamped, constrain the output to the domain
        return clamp(result, within: domain)
    }

    /// returns an array of the locations of ticks - (value, location)
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(range: ClosedRange<InputType>) -> [Tick<InputType>] {
        var result: [Tick<InputType>] = Array()
        for i in stride(from: 0, through: desiredTicks, by: 1) {
            let tickDomainValue = interpolate(Float(i) / Float(desiredTicks), range: domain)
            result.append(FloatTick(value: tickDomainValue,
                                      location: scale(tickDomainValue, range: range)))
        }
        return result
    }
}
