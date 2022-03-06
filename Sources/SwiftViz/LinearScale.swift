import Numerics
import Foundation

// =============================================================
//  LinearScale.swift

/// A linear scale is created using a continuous input domain and provides methods to
/// convert values within that domain to an output range.
public struct LinearScale: Scale {
    public typealias InputType = Float
    public typealias OutputType = Float
    public func cast(value: Float) -> Float {
        return value
    }
    public func cast(range: ClosedRange<Float>) -> ClosedRange<Float> {
        return range
    }

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
    public func scale(_ inputValue: InputType, range: ClosedRange<InputType>) -> OutputType {
        let result: InputType = interpolate(normalize(inputValue, domain: domain), range: range)
        // if we're clamped, constrain the output to the range
        return clamp(cast(value: result), within: cast(range: range))
    }

    /// inverts the scale, taking a value in the output range and returning the relevant value from the input domain
    public func invert(_ outputValue: OutputType, domain: ClosedRange<InputType>) -> InputType {
        let result: OutputType = interpolate(normalize(outputValue, domain: domain), range: domain)
        // if we're clamped, constrain the output to the domain
        return clamp(result, within: cast(range: domain))
    }

    /// returns an array of the locations of ticks - (value, location)
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(range: ClosedRange<InputType>) -> [Tick<InputType,OutputType>] {
        var result: [Tick<InputType,OutputType>] = Array()
        for i in stride(from: 0, through: desiredTicks, by: 1) {
            let tickDomainValue = interpolate(LinearScale.InputType(i / desiredTicks), range: domain)
            result.append(Tick(value: tickDomainValue,
                                      location: scale(tickDomainValue, range: range)))
        }
        return result
    }
}
