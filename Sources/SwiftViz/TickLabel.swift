//
//  TickLabel.swift
//  netlaband
//
//  Created by Joseph Heck on 3/11/20.
//  Copyright © 2020 JFH Consulting. All rights reserved.
//

import Numerics
import Foundation

/// A TickLabel is more specific to the visualization and
/// is generally created with the benefit of a formatter,
/// the type that we use being dependent on the type that's
/// used for the domain of the Scale.
public struct TickLabel<OutputType>: Identifiable {
    public let id: UUID
    public let rangeLocation: OutputType
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
