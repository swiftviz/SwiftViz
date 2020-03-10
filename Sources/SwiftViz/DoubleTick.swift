//
//  DoubleTick.swift
//  SwiftViz
//
//  Created by Joseph Heck on 3/4/20.
//

import CoreGraphics
import Foundation

public struct DoubleTick: Tick {
    public typealias InputType = Double

    public let id = UUID()
    // making this identifiable as a convenience
    // for use within SwiftUI. You can then use ForEach over
    // a sequence of these more cleanly.

    public let value: Double // value from the domain of an associated Scale
    public let rangeLocation: CGFloat // location maps to the output range of the Scale

    public var stringValue: String {
        String(format: "%.1f", value)
    }

    // public initializer needed in a library, the auto-generated one isn't auto-public
    public init(value: Double, location: CGFloat) {
        self.value = value
        rangeLocation = location
    }
}
