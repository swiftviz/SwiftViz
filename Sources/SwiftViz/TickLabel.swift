//
//  TickLabel.swift
//  netlaband
//
//  Created by Joseph Heck on 3/11/20.
//  Copyright © 2020 JFH Consulting. All rights reserved.
//

import Foundation
import Numerics

/// A struct that provides string representation of a value with an accompanying location that represents a tick on an axis of a chart.
public struct TickLabel<OutputType>: Identifiable where OutputType: Numeric, OutputType: Comparable {
    /// A unique identifier for the tick instance.
    public let id: UUID
    /// The location where the tick should be placed within a chart's range.
    public let rangeLocation: OutputType
    /// The value of the tick in a string representation.
    public let value: String

    /// Full initializer for a TickLabel
    /// - Parameters:
    ///   - id: an instance of UUID
    ///   - rangeLocation: location (CGFloat) of the label within the output range of a scale
    ///   - value: String description of the label to be displayed
    public init(id: UUID, rangeLocation: OutputType, value: String) {
        self.id = id
        self.rangeLocation = rangeLocation
        self.value = value
    }

    /// Convenience initializer for TickLabel
    ///
    /// - Parameters:
    ///   - rangeLocation: location (CGFloat) of the label within the output range of a scale
    ///   - value: String description of the label to be displayed
    public init(rangeLocation: OutputType, value: String) {
        id = UUID()
        self.rangeLocation = rangeLocation
        self.value = value
    }

    /// static function on TickLabel that returns a default Formatter
    /// object to assist in creating TickLabel instances
    public static func makeDefaultFormatter() -> Formatter {
        let defaultFormatter = NumberFormatter()
        defaultFormatter.numberStyle = .decimal
        defaultFormatter.minimumFractionDigits = 1
        defaultFormatter.maximumFractionDigits = 2
        return defaultFormatter
    }
}
