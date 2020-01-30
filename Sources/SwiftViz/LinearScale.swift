import Foundation

// =============================================================
//  LinearScale.swift

/// A linear scale takes input from a continuous domain
/// and maps it to a continuous range.
public struct LinearScale: Scale {

    public let isClamped: Bool
    public let domain: ClosedRange<Double>
    public let range: ClosedRange<Double>

    public init(domain: ClosedRange<Double>, range: ClosedRange<Double>, isClamped: Bool = false) {
        self.isClamped = isClamped
        self.domain = domain
        self.range = range
    }

    /// scales the input value (within domain) per the scale
    /// to the relevant output (using range)
    ///
    /// - Parameter x: value within the domain
    /// - Returns: scaled value
    public func scale(_ inputValue: Double) -> Double {
        interpolate(normalize(inputValue, domain: domain), range: range)
    }

    public func invert(_ outputValue: Double) -> Double {
        interpolate(normalize(outputValue, domain: range), range: domain)
    }

    /// returns an array of the locations of ticks
    ///
    /// - Parameter count: number of steps to take in the ticks, default of 10
    /// - Returns: array of the locations of the ticks within self.range
    public func ticks(_ count: Int?) -> [Double] {
        let count = count ?? 10 // default of 10 if no value provided
        var result: [Double] = Array()
        for i in stride(from: 0, through: count, by: 1) {
            result.append(interpolate(Double(i) / Double(count), range: domain))
        }
        return result
    }
}
